-- Copyright (c) 1990 Regents of the University of California.
-- All rights reserved.
--
-- This software was developed by John Self of the Arcadia project
-- at the University of California, Irvine.
--
-- Redistribution and use in source and binary forms are permitted
-- provided that the above copyright notice and this paragraph are
-- duplicated in all such forms and that any documentation,
-- advertising materials, and other materials related to such
-- distribution and use acknowledge that the software was developed
-- by the University of California, Irvine.  The name of the
-- University may not be used to endorse or promote products derived
-- from this software without specific prior written permission.
-- THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
-- IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

-- TITLE DFA construction routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION converts non-deterministic finite automatons to finite ones.
-- $Header: /dc/uc/self/tmp/gnat_aflex/RCS/dfa.adb,v 1.1 1995/07/04 20:18:39 self Exp self $

with Dfa, Int_Io, Misc, Tblcmp, Ccl;
with Ecs, Nfa, Tstring, Gen, Skeleton_Manager;

package body Dfa is
   use Tstring;
   -- check_for_backtracking - check a DFA state for backtracking
   --
-- ds is the number of the state to check and state[) is its out-transitions,
-- indexed by equivalence class, and state_rules[) is the set of rules
-- associated with this state

   Did_Stk_Init : Boolean := False;
   Stk          : Int_Ptr;

   procedure Check_For_Backtracking
     (Ds : in Integer; State : in Unbounded_Int_Array)
   is
   begin
      if Dfaacc (Ds).Dfaacc_State = 0 then

         -- state is non-accepting
         Num_Backtracking := Num_Backtracking + 1;

         if Backtrack_Report then
            Text_Io.Put (Backtrack_File, "State #");
            Int_Io.Put (Backtrack_File, Ds, 1);
            Text_Io.Put (Backtrack_File, "is non-accepting -");
            Text_Io.New_Line (Backtrack_File);

            -- identify the state
            Dump_Associated_Rules (Backtrack_File, Ds);

            -- now identify it further using the out- and jam-transitions
            Dump_Transitions (Backtrack_File, State);
            Text_Io.New_Line (Backtrack_File);
         end if;
      end if;
   end Check_For_Backtracking;

   -- check_trailing_context - check to see if NFA state set constitutes
   --                          "dangerous" trailing context
   --
   -- NOTES
   --    Trailing context is "dangerous" if both the head and the trailing
   --  part are of variable size \and/ there's a DFA state which contains
   --  both an accepting state for the head part of the rule and NFA states
   --  which occur after the beginning of the trailing context.
   --  When such a rule is matched, it's impossible to tell if having been
   --  in the DFA state indicates the beginning of the trailing context
   --  or further-along scanning of the pattern.  In these cases, a warning
   --  message is issued.
   --
   --    nfa_states[1 .. num_states) is the list of NFA states in the DFA.
   --    accset[1 .. nacc) is the list of accepting numbers for the DFA state.

   procedure Check_Trailing_Context
     (Nfa_States : in Int_Ptr; Num_States : in Integer; Accset : in Int_Ptr;
      Nacc       : in Integer)
   is
      Ns, Ar   : Integer;
      Type_Var : State_Enum;

      use Misc;
   begin
      for I in 1 .. Num_States loop
         Ns       := Nfa_States (I);
         Type_Var := State_Type (Ns);
         Ar       := Assoc_Rule (Ns);

         if Type_Var = State_Normal or Rule_Type (Ar) /= Rule_Variable then
            null;

            -- do nothing
         else
            if Type_Var = State_Trailing_Context then

               -- potential trouble.  Scan set of accepting numbers for
               -- the one marking the end of the "head".  We assume that
               -- this looping will be fairly cheap since it's rare that
               -- an accepting number set is large.
               for J in 1 .. Nacc loop
                  if Check_Yy_Trailing_Head_Mask (Accset (J)) /= 0 then
                     Text_Io.Put
                       (Standard_Error,
                        "aflex: Dangerous trailing context in rule at line ");
                     Int_Io.Put (Standard_Error, Rule_Linenum (Ar), 1);
                     Text_Io.New_Line (Standard_Error);
                     return;
                  end if;
               end loop;
            end if;
         end if;
      end loop;
   end Check_Trailing_Context;

   -- dump_associated_rules - list the rules associated with a DFA state
   --
   -- goes through the set of NFA states associated with the DFA and
   -- extracts the first MAX_ASSOC_RULES unique rules, sorts them,
   -- and writes a report to the given file

   procedure Dump_Associated_Rules (F : in File_Type; Ds : in Integer) is
      J                    : Integer;
      Num_Associated_Rules : Integer := 0;
      Rule_Set             : Int_Ptr;
      Size, Rule_Num       : Integer;
   begin
      Rule_Set := new Unbounded_Int_Array (0 .. Max_Assoc_Rules + 1);
      Size     := Dfasiz (Ds);

      for I in 1 .. Size loop
         Rule_Num := Rule_Linenum (Assoc_Rule (Dss (Ds) (I)));

         J := 1;
         while J <= Num_Associated_Rules loop
            if Rule_Num = Rule_Set (J) then
               exit;
            end if;
            J := J + 1;
         end loop;
         if J > Num_Associated_Rules then

            --new rule
            if Num_Associated_Rules < Max_Assoc_Rules then
               Num_Associated_Rules            := Num_Associated_Rules + 1;
               Rule_Set (Num_Associated_Rules) := Rule_Num;
            end if;
         end if;
      end loop;

      Misc.Bubble (Rule_Set, Num_Associated_Rules);

      Text_Io.Put (F, " associated rules:");

      for I in 1 .. Num_Associated_Rules loop
         if I mod 8 = 1 then
            Text_Io.New_Line (F);
         end if;

         Text_Io.Put (F, Ascii.Ht);
         Int_Io.Put (F, Rule_Set (I), 1);
      end loop;

      Text_Io.New_Line (F);
   exception
      when Storage_Error =>
         Misc.Aflexfatal ("dynamic memory failure in dump_associated_rules()");
   end Dump_Associated_Rules;

   -- dump_transitions - list the transitions associated with a DFA state
   --
   -- goes through the set of out-transitions and lists them in human-readable
   -- form (i.e., not as equivalence classes); also lists jam transitions
   -- (i.e., all those which are not out-transitions, plus EOF).  The dump
   -- is done to the given file.

   procedure Dump_Transitions
     (F : in File_Type; State : in Unbounded_Int_Array)
   is
      Ec           : Integer;
      Out_Char_Set : C_Size_Bool_Array;
   begin
      for I in 1 .. Csize loop
         Ec := Ecgroup (I);

         if Ec < 0 then
            Ec := -Ec;
         end if;

         Out_Char_Set (I) := State (Ec) /= 0;
      end loop;

      Text_Io.Put (F, " out-transitions: ");

      Ccl.List_Character_Set (F, Out_Char_Set);

      -- now invert the members of the set to get the jam transitions
      for I in 1 .. Csize loop
         Out_Char_Set (I) := not Out_Char_Set (I);
      end loop;

      Text_Io.New_Line (F);
      Text_Io.Put (F, "jam-transitions: EOF ");

      Ccl.List_Character_Set (F, Out_Char_Set);

      Text_Io.New_Line (F);
   end Dump_Transitions;

   -- epsclosure - construct the epsilon closure of a set of ndfa states
   --
   -- NOTES
   --    the epsilon closure is the set of all states reachable by an arbitrary
--  number of epsilon transitions which themselves do not have epsilon
--  transitions going out, unioned with the set of states which have non-null
--  accepting numbers.  t is an array of size numstates of nfa state numbers.
--  Upon return, t holds the epsilon closure and numstates is updated.  accset
   --  holds a list of the accepting numbers, and the size of accset is given
   --  by nacc.  t may be subjected to reallocation if it is not large enough
   --  to hold the epsilon closure.
   --
   --    hashval is the hash value for the dfa corresponding to the state set

   procedure Epsclosure
     (T : in out Int_Ptr; Ns_Addr : in out Integer; Accset : in Int_Ptr;
      Nacc_Addr, Hv_Addr :    out Integer)
   is
      Ns, Tsp                                      : Integer;
      Numstates, Nacc, Hashval, Transsym, Nfaccnum : Integer;
      Stkend                                       : Integer;
      Stkpos                                       : Integer;
      procedure Mark_State (State : in Integer) is
         pragma Inline (Mark_State);
      begin
         Trans1 (State) := Trans1 (State) - Marker_Difference;
      end Mark_State;

      function Is_Marked (State : in Integer) return Boolean is
         pragma Inline (Is_Marked);
      begin
         return Trans1 (State) < 0;
      end Is_Marked;

      procedure Unmark_State (State : in Integer) is
         pragma Inline (Unmark_State);
      begin
         Trans1 (State) := Trans1 (State) + Marker_Difference;
      end Unmark_State;

      procedure Check_Accept (State : in Integer) is
         pragma Inline (Check_Accept);
      begin
         Nfaccnum := Accptnum (State);
         if Nfaccnum /= Nil then
            Nacc          := Nacc + 1;
            Accset (Nacc) := Nfaccnum;
         end if;
      end Check_Accept;

      procedure Do_Reallocation is
         pragma Inline (Do_Reallocation);
      begin
         Current_Max_Dfa_Size := Current_Max_Dfa_Size + Max_Dfa_Size_Increment;
         Num_Reallocs         := Num_Reallocs + 1;
         Reallocate_Integer_Array (T, Current_Max_Dfa_Size);
         Reallocate_Integer_Array (Stk, Current_Max_Dfa_Size);
      end Do_Reallocation;

      procedure Put_On_Stack (State : in Integer) is
         pragma Inline (Put_On_Stack);
      begin
         Stkend := Stkend + 1;
         if Stkend >= Current_Max_Dfa_Size then
            Do_Reallocation;
         end if;
         Stk (Stkend) := State;
         Mark_State (State);
      end Put_On_Stack;

      procedure Add_State (State : in Integer) is
         pragma Inline (Add_State);
      begin
         Numstates := Numstates + 1;
         if Numstates >= Current_Max_Dfa_Size then
            Do_Reallocation;
         end if;
         T (Numstates) := State;
         Hashval       := Hashval + State;
      end Add_State;

      procedure Stack_State (State : in Integer) is
         pragma Inline (Stack_State);
      begin
         Put_On_Stack (State);
         Check_Accept (State);
         if Nfaccnum /= Nil or Transchar (State) /= Sym_Epsilon then
            Add_State (State);
         end if;
      end Stack_State;

   begin
      Numstates := Ns_Addr;
      if not Did_Stk_Init then
         Stk          := Allocate_Integer_Array (Current_Max_Dfa_Size);
         Did_Stk_Init := True;
      end if;

      Nacc    := 0;
      Stkend  := 0;
      Hashval := 0;

      for Nstate in 1 .. Numstates loop
         Ns := T (Nstate);

         -- the state could be marked if we've already pushed it onto
         -- the stack
         if not Is_Marked (Ns) then
            Put_On_Stack (Ns);
            null;
         end if;

         Check_Accept (Ns);
         Hashval := Hashval + Ns;
      end loop;

      Stkpos := 1;
      while Stkpos <= Stkend loop
         Ns       := Stk (Stkpos);
         Transsym := Transchar (Ns);

         if Transsym = Sym_Epsilon then
            Tsp := Trans1 (Ns) + Marker_Difference;

            if Tsp /= No_Transition then
               if not Is_Marked (Tsp) then
                  Stack_State (Tsp);
               end if;

               Tsp := Trans2 (Ns);

               if Tsp /= No_Transition then
                  if not Is_Marked (Tsp) then
                     Stack_State (Tsp);
                  end if;
               end if;
            end if;
         end if;
         Stkpos := Stkpos + 1;
      end loop;

      -- clear out "visit" markers
      for Chk_Stkpos in 1 .. Stkend loop
         if Is_Marked (Stk (Chk_Stkpos)) then
            Unmark_State (Stk (Chk_Stkpos));
         else
            Misc.Aflexfatal ("consistency check failed in epsclosure()");
         end if;
      end loop;

      Ns_Addr   := Numstates;
      Hv_Addr   := Hashval;
      Nacc_Addr := Nacc;

   end Epsclosure;

   -- increase_max_dfas - increase the maximum number of DFAs

   procedure Increase_Max_Dfas is
   begin
      Current_Max_Dfas := Current_Max_Dfas + Max_Dfas_Increment;

      Num_Reallocs := Num_Reallocs + 1;

      Reallocate_Integer_Array (Base, Current_Max_Dfas);
      Reallocate_Integer_Array (Def, Current_Max_Dfas);
      Reallocate_Integer_Array (Dfasiz, Current_Max_Dfas);
      Reallocate_Integer_Array (Accsiz, Current_Max_Dfas);
      Reallocate_Integer_Array (Dhash, Current_Max_Dfas);
      Reallocate_Int_Ptr_Array (Dss, Current_Max_Dfas);
      Reallocate_Dfaacc_Union (Dfaacc, Current_Max_Dfas);
   end Increase_Max_Dfas;

   -- ntod - convert an ndfa to a dfa
   --
   --  creates the dfa corresponding to the ndfa we've constructed.  the
   --  dfa starts out in state #1.

   procedure Ntod is

      Accset                                             : Int_Ptr;
      Ds, Nacc, Newds                                    : Integer;
      Duplist, Targfreq, Targstate, State                : C_Size_Array;
      Symlist                                            : C_Size_Bool_Array;
      Hashval, Numstates, Dsize                          : Integer;
      Nset, Dset                                         : Int_Ptr;
      Targptr, Totaltrans, I, J, Comstate, Comfreq, Targ : Integer;
      Num_Start_States, Todo_Head, Todo_Next             : Integer;
      Snsresult                                          : Boolean;
      Full_Table_Temp_File                               : File_Type;
      Buf                                                : Vstring;
      Num_Nxt_States                                     : Integer;

      -- this is so find_table_space(...) will know where to start looking in
      -- chk/nxt for unused records for space to put in the state
   begin
      Accset := Allocate_Integer_Array (Num_Rules + 1);
      Nset   := Allocate_Integer_Array (Current_Max_Dfa_Size);

      -- the "todo" queue is represented by the head, which is the DFA
      -- state currently being processed, and the "next", which is the
      -- next DFA state number available (not in use).  We depend on the
      -- fact that snstods() returns DFA's \in increasing order/, and thus
      -- need only know the bounds of the dfas to be processed.
      Todo_Head := 0;
      Todo_Next := 0;

      for Cnt in 0 .. Csize loop
         Duplist (Cnt) := Nil;
         Symlist (Cnt) := False;
      end loop;

      for Cnt in 0 .. Num_Rules loop
         Accset (Cnt) := Nil;
      end loop;

      if Trace then
         Nfa.Dumpnfa (Scset (1));
         Text_Io.New_Line (Standard_Error);
         Text_Io.New_Line (Standard_Error);
         Text_Io.Put (Standard_Error, "DFA Dump:");
         Text_Io.New_Line (Standard_Error);
         Text_Io.New_Line (Standard_Error);
      end if;

      Tblcmp.Inittbl;

      if Fulltbl then
         Gen.Do_Sect3_Out;

         -- output user code up to ##
         Skeleton_Manager.Skelout;

         -- declare it "short" because it's a real long-shot that that
         -- won't be large enough
         begin -- make a temporary file to write yy_nxt array into
            Create (Full_Table_Temp_File, Out_File);
         exception
            when Use_Error | Name_Error =>
               Misc.Aflexfatal ("can't create temporary file");
         end;

         Num_Nxt_States := 1;
         Text_Io.Put (Full_Table_Temp_File, "( ");
         -- generate 0 entries for state #0
         for Cnt in 0 .. Numecs loop
            Misc.Mk2data (Full_Table_Temp_File, 0);
         end loop;

         Text_Io.Put (Full_Table_Temp_File, " )");
         -- force extra blank line next dataflush()
         Dataline := Numdatalines;
      end if;

      -- create the first states

      Num_Start_States := Lastsc * 2;

      for Cnt in 1 .. Num_Start_States loop
         Numstates := 1;

         -- for each start condition, make one state for the case when
         -- we're at the beginning of the line (the '%' operator) and
         -- one for the case when we're not

         if Cnt mod 2 = 1 then
            Nset (Numstates) := Scset ((Cnt / 2) + 1);
         else
            Nset (Numstates) :=
              Nfa.Mkbranch (Scbol (Cnt / 2), Scset (Cnt / 2));
         end if;

         Dfa.Epsclosure (Nset, Numstates, Accset, Nacc, Hashval);

         Snstods (Nset, Numstates, Accset, Nacc, Hashval, Ds, Snsresult);
         if Snsresult then
            Numas     := Numas + Nacc;
            Totnst    := Totnst + Numstates;
            Todo_Next := Todo_Next + 1;

            if (Variable_Trailing_Context_Rules and (Nacc > 0)) then
               Check_Trailing_Context (Nset, Numstates, Accset, Nacc);
            end if;
         end if;
      end loop;

      Snstods (Nset, 0, Accset, 0, 0, End_Of_Buffer_State, Snsresult);
      if not Snsresult then
         Misc.Aflexfatal ("could not create unique end-of-buffer state");
      end if;
      Numas            := Numas + 1;
      Num_Start_States := Num_Start_States + 1;
      Todo_Next        := Todo_Next + 1;

      while Todo_Head < Todo_Next loop
         Num_Nxt_States := Num_Nxt_States + 1;
         Targptr        := 0;
         Totaltrans     := 0;

         for State_Cnt in 1 .. Numecs loop
            State (State_Cnt) := 0;
         end loop;

         Todo_Head := Todo_Head + 1;
         Ds        := Todo_Head;

         Dset  := Dss (Ds);
         Dsize := Dfasiz (Ds);

         if Trace then
            Text_Io.Put (Standard_Error, "state # ");
            Int_Io.Put (Standard_Error, Ds, 1);
            Text_Io.Put_Line (Standard_Error, ":");
         end if;

         Sympartition (Dset, Dsize, Symlist, Duplist);

         for Sym in 1 .. Numecs loop
            if Symlist (Sym) then
               Symlist (Sym) := False;

               if (Duplist (Sym) = Nil) then
                  -- symbol has unique out-transitions
                  Numstates := Symfollowset (Dset, Dsize, Sym, Nset);
                  Dfa.Epsclosure (Nset, Numstates, Accset, Nacc, Hashval);

                  Snstods
                    (Nset, Numstates, Accset, Nacc, Hashval, Newds, Snsresult);
                  if Snsresult then
                     Totnst    := Totnst + Numstates;
                     Todo_Next := Todo_Next + 1;
                     Numas     := Numas + Nacc;

                     if (Variable_Trailing_Context_Rules and (Nacc > 0)) then
                        Check_Trailing_Context (Nset, Numstates, Accset, Nacc);
                     end if;
                  end if;

                  State (Sym) := Newds;

                  if Trace then
                     Text_Io.Put (Standard_Error, Ascii.Ht);
                     Int_Io.Put (Standard_Error, Sym, 1);
                     Text_Io.Put (Standard_Error, Ascii.Ht);
                     Int_Io.Put (Standard_Error, Newds, 1);
                     Text_Io.New_Line (Standard_Error);
                  end if;

                  Targptr             := Targptr + 1;
                  Targfreq (Targptr)  := 1;
                  Targstate (Targptr) := Newds;
                  Numuniq             := Numuniq + 1;
               else
                  -- sym's equivalence class has the same transitions
                  -- as duplist(sym)'s equivalence class

                  Targ        := State (Duplist (Sym));
                  State (Sym) := Targ;
                  if Trace then
                     Text_Io.Put (Standard_Error, Ascii.Ht);
                     Int_Io.Put (Standard_Error, Sym, 1);
                     Text_Io.Put (Standard_Error, Ascii.Ht);
                     Int_Io.Put (Standard_Error, Targ, 1);
                     Text_Io.New_Line (Standard_Error);
                  end if;

                  -- update frequency count for destination state

                  I := 1;

                  while Targstate (I) /= Targ loop
                     I := I + 1;
                  end loop;

                  Targfreq (I) := Targfreq (I) + 1;
                  Numdup       := Numdup + 1;
               end if;

               Totaltrans    := Totaltrans + 1;
               Duplist (Sym) := Nil;
            end if;
         end loop;

         Numsnpairs := Numsnpairs + Totaltrans;

         if Caseins and not Useecs then
            I := Character'Pos ('A');
            J := Character'Pos ('a');
            while I < Character'Pos ('Z') loop
               State (I) := State (J);
               I         := I + 1;
               J         := J + 1;
            end loop;
         end if;

         if Ds > Num_Start_States then
            Check_For_Backtracking (Ds, State);
         end if;

         if Fulltbl then
            -- supply array's 0-element
            Text_Io.Put (Full_Table_Temp_File, ",");
            Misc.Dataflush (Full_Table_Temp_File);
            Text_Io.Put (Full_Table_Temp_File, "( ");
            if Ds = End_Of_Buffer_State then
               Misc.Mk2data (Full_Table_Temp_File, -End_Of_Buffer_State);
            else
               Misc.Mk2data (Full_Table_Temp_File, End_Of_Buffer_State);
            end if;

            for Cnt in 1 .. Numecs loop
               -- jams are marked by negative of state number
               if State (Cnt) /= 0 then
                  Misc.Mk2data (Full_Table_Temp_File, State (Cnt));
               else
                  Misc.Mk2data (Full_Table_Temp_File, -Ds);
               end if;
            end loop;

            Text_Io.Put (Full_Table_Temp_File, " )");
            -- force extra blank line next dataflush()
            Dataline := Numdatalines;
         else
            if Ds = End_Of_Buffer_State then
               -- special case this state to make sure it does what it's
               -- supposed to, i.e., jam on end-of-buffer
               Tblcmp.Stack1 (Ds, 0, 0, Jamstate_Const);
            else  -- normal, compressed state
               -- determine which destination state is the most common, and
               -- how many transitions to it there are
               Comfreq  := 0;
               Comstate := 0;

               for Cnt in 1 .. Targptr loop
                  if Targfreq (Cnt) > Comfreq then
                     Comfreq  := Targfreq (Cnt);
                     Comstate := Targstate (Cnt);
                  end if;
               end loop;

               Tblcmp.Bldtbl (State, Ds, Totaltrans, Comstate, Comfreq);
            end if;
         end if;
      end loop;

      if Fulltbl then
         Text_Io.Put ("yy_nxt : constant array(0..");
         Int_Io.Put (Num_Nxt_States - 1, 1);
         Text_Io.Put_Line (" , ASCII.NUL..ASCII.DEL) of short :=");
         Text_Io.Put_Line ("   (");

         Reset (Full_Table_Temp_File, In_File);
         while (not End_Of_File (Full_Table_Temp_File)) loop
            Tstring.Get_Line (Full_Table_Temp_File, Buf);
            Tstring.Put_Line (Buf);
         end loop;
         Delete (Full_Table_Temp_File);

         Misc.Dataend;
      else
         Tblcmp.Cmptmps;  -- create compressed template entries

         -- create tables for all the states with only one out-transition
         while Onesp > 0 loop
            Tblcmp.Mk1tbl
              (Onestate (Onesp), Onesym (Onesp), Onenext (Onesp),
               Onedef (Onesp));
            Onesp := Onesp - 1;
         end loop;

         Tblcmp.Mkdeftbl;
      end if;
   end Ntod;

   -- snstods - converts a set of ndfa states into a dfa state
   --
   -- on return, the dfa state number is in newds.
   procedure Snstods
     (Sns           : in Int_Ptr; Numstates : in Integer; Accset : in Int_Ptr;
      Nacc, Hashval : in     Integer; Newds_Addr : out Integer;
      Result        :    out Boolean)
   is
      Didsort : Boolean := False;
      J       : Integer;
      Newds   : Integer;
      Oldsns  : Int_Ptr;
   begin
      for I in 1 .. Lastdfa loop
         if Hashval = Dhash (I) then
            if Numstates = Dfasiz (I) then
               Oldsns := Dss (I);

               if not Didsort then
                  -- we sort the states in sns so we can compare it to
                  -- oldsns quickly.  we use bubble because there probably
                  -- aren't very many states

                  Misc.Bubble (Sns, Numstates);
                  Didsort := True;
               end if;

               J := 1;
               while J <= Numstates loop
                  if Sns (J) /= Oldsns (J) then
                     exit;
                  end if;
                  J := J + 1;
               end loop;

               if J > Numstates then
                  Dfaeql     := Dfaeql + 1;
                  Newds_Addr := I;
                  Result     := False;
                  return;
               end if;

               Hshcol := Hshcol + 1;
            else
               Hshsave := Hshsave + 1;
            end if;
         end if;
      end loop;
      -- make a new dfa

      Lastdfa := Lastdfa + 1;
      if Lastdfa >= Current_Max_Dfas then
         Increase_Max_Dfas;
      end if;

      Newds := Lastdfa;

      Dss (Newds) := new Unbounded_Int_Array (0 .. Numstates + 1);

      -- if we haven't already sorted the states in sns, we do so now, so that
      -- future comparisons with it can be made quickly

      if not Didsort then
         Misc.Bubble (Sns, Numstates);
      end if;

      for I in 1 .. Numstates loop
         Dss (Newds) (I) := Sns (I);
      end loop;

      Dfasiz (Newds) := Numstates;
      Dhash (Newds)  := Hashval;

      if Nacc = 0 then
         Dfaacc (Newds).Dfaacc_State := 0;
         Accsiz (Newds)              := 0;
      else
         -- find lowest numbered rule so the disambiguating rule will work
         J := Num_Rules + 1;

         for I in 1 .. Nacc loop
            if Accset (I) < J then
               J := Accset (I);
            end if;
         end loop;

         Dfaacc (Newds).Dfaacc_State := J;
      end if;

      Newds_Addr := Newds;
      Result     := True;
      return;

   exception
      when Storage_Error =>
         Misc.Aflexfatal ("dynamic memory failure in snstods()");
   end Snstods;

   -- symfollowset - follow the symbol transitions one step
   function Symfollowset
     (Ds : in Int_Ptr; Dsize, Transsym : in Integer; Nset : in Int_Ptr)
      return Integer
   is
      Ns, Tsp, Sym, Lenccl, Ch, Numstates, Ccllist : Integer;
   begin
      Numstates := 0;

      for I in 1 .. Dsize loop
         -- for each nfa state ns in the state set of ds
         Ns  := Ds (I);
         Sym := Transchar (Ns);
         Tsp := Trans1 (Ns);

         if Sym < 0 then
            -- it's a character class
            Sym     := -Sym;
            Ccllist := Cclmap (Sym);
            Lenccl  := Ccllen (Sym);

            if Cclng (Sym) /= 0 then
               for J in 0 .. Lenccl - 1 loop
                  -- loop through negated character class
                  Ch := Character'Pos (Ccltbl (Ccllist + J));

                  if Ch > Transsym then
                     exit;  -- transsym isn't in negated ccl
                  else
                     if Ch = Transsym then
                        goto Bottom;  -- next 2
                     end if;
                  end if;
               end loop;

               -- didn't find transsym in ccl
               Numstates        := Numstates + 1;
               Nset (Numstates) := Tsp;
            else
               for J in 0 .. Lenccl - 1 loop
                  Ch := Character'Pos (Ccltbl (Ccllist + J));

                  if Ch > Transsym then
                     exit;
                  else
                     if Ch = Transsym then
                        Numstates        := Numstates + 1;
                        Nset (Numstates) := Tsp;
                        exit;
                     end if;
                  end if;
               end loop;
            end if;
         else
            if Sym >= Character'Pos ('A') and Sym <= Character'Pos ('Z') and
              Caseins
            then
               Misc.Aflexfatal ("consistency check failed in symfollowset");
            else
               if Sym = Sym_Epsilon then
                  null;  -- do nothing
               else
                  if Ecgroup (Sym) = Transsym then
                     Numstates        := Numstates + 1;
                     Nset (Numstates) := Tsp;
                  end if;
               end if;
            end if;
         end if;

         <<Bottom>>
         null;
      end loop;
      return Numstates;
   end Symfollowset;

   -- sympartition - partition characters with same out-transitions
   procedure Sympartition
     (Ds      : in     Int_Ptr; Numstates : in Integer;
      Symlist : in out C_Size_Bool_Array; Duplist : in out C_Size_Array)
   is
      Tch, J, Ns, Lenccl, Cclp, Ich : Integer;
      Dupfwd                        : C_Size_Array;

      -- partitioning is done by creating equivalence classes for those
      -- characters which have out-transitions from the given state.  Thus
      -- we are really creating equivalence classes of equivalence classes.
   begin
      for I in 1 .. Numecs loop
         -- initialize equivalence class list
         Duplist (I) := I - 1;
         Dupfwd (I)  := I + 1;
      end loop;

      Duplist (1)     := Nil;
      Dupfwd (Numecs) := Nil;
      Dupfwd (0)      := 0;

      for I in 1 .. Numstates loop
         Ns  := Ds (I);
         Tch := Transchar (Ns);

         if Tch /= Sym_Epsilon then
            if Tch < -Lastccl or Tch > Csize then
               Misc.Aflexfatal
                 ("bad transition character detected in sympartition()");
            end if;

            if Tch > 0 then
               -- character transition
               Ecs.Mkechar (Ecgroup (Tch), Dupfwd, Duplist);
               Symlist (Ecgroup (Tch)) := True;
            else
               -- character class
               Tch := -Tch;

               Lenccl := Ccllen (Tch);
               Cclp   := Cclmap (Tch);
               Ecs.Mkeccl
                 (Ccltbl (Cclp .. Cclp + Lenccl), Lenccl, Dupfwd, Duplist,
                  Numecs);

               if Cclng (Tch) /= 0 then
                  J := 0;

                  for K in 0 .. Lenccl - 1 loop
                     Ich := Character'Pos (Ccltbl (Cclp + K));

                     J := J + 1;
                     while J < Ich loop
                        Symlist (J) := True;
                        J           := J + 1;
                     end loop;
                  end loop;

                  J := J + 1;
                  while J <= Numecs loop
                     Symlist (J) := True;
                     J           := J + 1;
                  end loop;
               else
                  for K in 0 .. Lenccl - 1 loop
                     Ich           := Character'Pos (Ccltbl (Cclp + K));
                     Symlist (Ich) := True;
                  end loop;
               end if;
            end if;
         end if;
      end loop;
   end Sympartition;
end Dfa;
