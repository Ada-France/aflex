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

-- TITLE NFA construction routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION builds the NFA.
-- NOTES this file mirrors flex as closely as possible.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/nfaB.a,v 1.6 90/01/12 15:20:27 self Exp Locker: self $

with Misc_Defs, Nfa, Misc, Ecs;
with Int_Io, Text_Io;
use Misc_Defs;

package body Nfa is

-- add_accept - add an accepting state to a machine
--
-- accepting_number becomes mach's accepting number.

   procedure Add_Accept (Mach : in out Integer; Accepting_Number : in Integer)
   is
      -- hang the accepting number off an epsilon state.  if it is associated
      -- with a state that has a non-epsilon out-transition, then the state
      -- will accept BEFORE it makes that transition, i.e., one character
      -- too soon
      Astate : Integer;
   begin
      if (Transchar (Finalst (Mach)) = Sym_Epsilon) then
         Accptnum (Finalst (Mach)) := Accepting_Number;
      else
         Astate            := Mkstate (Sym_Epsilon);
         Accptnum (Astate) := Accepting_Number;
         Mach              := Link_Machines (Mach, Astate);
      end if;
   end Add_Accept;

   -- copysingl - make a given number of copies of a singleton machine
   --
   --     newsng - a new singleton composed of num copies of singl
   --     singl  - a singleton machine
   --     num    - the number of copies of singl to be present in newsng

   function Copysingl (Singl, Num : in Integer) return Integer is
      Copy : Integer;
   begin
      Copy := Mkstate (Sym_Epsilon);

      for I in 1 .. Num loop
         Copy := Link_Machines (Copy, Dupmachine (Singl));
      end loop;

      return Copy;
   end Copysingl;

   -- dumpnfa - debugging routine to write out an nfa

   procedure Dumpnfa (State1 : in Integer) is
      Sym, Tsp1, Tsp2, Anum : Integer;
      use Text_Io;
   begin
      Text_Io.New_Line (Standard_Error);
      Text_Io.New_Line (Standard_Error);
      Text_Io.Put
        (Standard_Error, "********** beginning dump of nfa with start state ");
      Int_Io.Put (Standard_Error, State1, 0);
      Text_Io.New_Line (Standard_Error);

      -- we probably should loop starting at firstst[state1] and going to
      -- lastst[state1], but they're not maintained properly when we "or"
      -- all of the rules together.  So we use our knowledge that the machine
      -- starts at state 1 and ends at lastnfa.
      for Ns in 1 .. Lastnfa loop
         Text_Io.Put (Standard_Error, "state # ");
         Int_Io.Put (Standard_Error, Ns, 4);
         Text_Io.Put (Ascii.Ht);
         Sym  := Transchar (Ns);
         Tsp1 := Trans1 (Ns);
         Tsp2 := Trans2 (Ns);
         Anum := Accptnum (Ns);

         Int_Io.Put (Standard_Error, Sym, 5);
         Text_Io.Put (Standard_Error, ":    ");
         Int_Io.Put (Standard_Error, Tsp1, 4);
         Text_Io.Put (Standard_Error, ",");
         Int_Io.Put (Standard_Error, Tsp2, 4);
         if (Anum /= Nil) then
            Text_Io.Put (Standard_Error, "  [");
            Int_Io.Put (Standard_Error, Anum, 0);
            Text_Io.Put (Standard_Error, "]");
         end if;
         Text_Io.New_Line (Standard_Error);
      end loop;

      Text_Io.Put (Standard_Error, "********** end of dump");
      Text_Io.New_Line (Standard_Error);
   end Dumpnfa;

   -- dupmachine - make a duplicate of a given machine
   --
   --     copy - holds duplicate of mach
   --     mach - machine to be duplicated
   --
   -- note that the copy of mach is NOT an exact duplicate; rather, all the
   -- transition states values are adjusted so that the copy is self-contained,
   -- as the original should have been.
   --
   -- also note that the original MUST be contiguous, with its low and high
   -- states accessible by the arrays firstst and lastst

   function Dupmachine (Mach : in Integer) return Integer is
      Init, State_Offset : Integer;
      State              : Integer          := 0;
      Last               : constant Integer := Lastst (Mach);
      I                  : Integer;
   begin
      I := Firstst (Mach);
      while (I <= Last) loop
         State := Mkstate (Transchar (I));

         if (Trans1 (I) /= No_Transition) then
            Mkxtion (Finalst (State), Trans1 (I) + State - I);

            if
              ((Transchar (I) = Sym_Epsilon) and (Trans2 (I) /= No_Transition))
            then
               Mkxtion (Finalst (State), Trans2 (I) + State - I);
            end if;
         end if;

         Accptnum (State) := Accptnum (I);
         I                := I + 1;
      end loop;

      if (State = 0) then
         Misc.Aflexfatal ("empty machine in dupmachine()");
      end if;

      State_Offset := State - I + 1;

      Init           := Mach + State_Offset;
      Firstst (Init) := Firstst (Mach) + State_Offset;
      Finalst (Init) := Finalst (Mach) + State_Offset;
      Lastst (Init)  := Lastst (Mach) + State_Offset;

      return Init;
   end Dupmachine;

   -- finish_rule - finish up the processing for a rule
   --
-- An accepting number is added to the given machine.  If variable_trail_rule
-- is true then the rule has trailing context and both the head and trail
-- are variable size.  Otherwise if headcnt or trailcnt is non-zero then
-- the machine recognizes a pattern with trailing context and headcnt is
-- the number of characters in the matched part of the pattern, or zero
-- if the matched part has variable length.  trailcnt is the number of
-- trailing context characters in the pattern, or zero if the trailing
-- context has variable length.

   procedure Finish_Rule
     (Mach              : in Integer; Variable_Trail_Rule : in Boolean;
      Headcnt, Trailcnt : in Integer)
   is
      P_Mach : Integer;
      use Text_Io;
   begin
      P_Mach := Mach;
      Add_Accept (P_Mach, Num_Rules);

      -- we did this in new_rule(), but it often gets the wrong
      -- number because we do it before we start parsing the current rule
      Rule_Linenum (Num_Rules) := Linenum;

      Text_Io.Put (Temp_Action_File, "         when ");
      Int_Io.Put (Temp_Action_File, Num_Rules, 1);
      Text_Io.Put_Line (Temp_Action_File, " =>");

      if (Variable_Trail_Rule) then
         Rule_Type (Num_Rules) := Rule_Variable;

         if (Performance_Report) then
            Text_Io.Put
              (Standard_Error, "Variable trailing context rule at line ");
            Int_Io.Put (Standard_Error, Rule_Linenum (Num_Rules), 1);
            Text_Io.New_Line (Standard_Error);
         end if;

         Variable_Trailing_Context_Rules := True;
      else
         Rule_Type (Num_Rules) := Rule_Normal;

         if ((Headcnt > 0) or (Trailcnt > 0)) then

            -- do trailing context magic to not match the trailing characters
            Text_Io.Put_Line
              (Temp_Action_File,
               "            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext");

            if (Headcnt > 0) then
               Text_Io.Put (Temp_Action_File, "            yy_cp := yy_bp + ");
               Int_Io.Put (Temp_Action_File, Headcnt, 1);
               Text_Io.Put_Line (Temp_Action_File, ";");
            else
               Text_Io.Put (Temp_Action_File, "            yy_cp := yy_cp - ");
               Int_Io.Put (Temp_Action_File, Trailcnt, 1);
               Text_Io.Put_Line (Temp_Action_File, ";");
            end if;

            Text_Io.Put_Line
              (Temp_Action_File, "            yy_c_buf_p := yy_cp;");
            Text_Io.Put_Line
              (Temp_Action_File,
               "            YY_DO_BEFORE_ACTION; -- set up yytext again");
         end if;
      end if;

      Misc.Line_Directive_Out (Temp_Action_File);
      Text_Io.Put (Temp_Action_File, "            ");
   end Finish_Rule;

   -- link_machines - connect two machines together
   --
   --     new    - a machine constructed by connecting first to last
   --     first  - the machine whose successor is to be last
   --     last   - the machine whose predecessor is to be first
   --
   -- note: this routine concatenates the machine first with the machine
   --  last to produce a machine new which will pattern-match first first
   --  and then last, and will fail if either of the sub-patterns fails.
   --  FIRST is set to new by the operation.  last is unmolested.

   function Link_Machines (First, Last : in Integer) return Integer is
   begin
      if First = Nil then
         return Last;
      elsif Last = Nil then
         return First;
      else
         Mkxtion (Finalst (First), Last);
         Finalst (First) := Finalst (Last);
         Lastst (First)  := Integer'Max (Lastst (First), Lastst (Last));
         Firstst (First) := Integer'Min (Firstst (First), Firstst (Last));
         return First;
      end if;
   end Link_Machines;

   -- mark_beginning_as_normal - mark each "beginning" state in a machine
--                            as being a "normal" (i.e., not trailing context-
   --                            associated) states
   --
   -- The "beginning" states are the epsilon closure of the first state

   procedure Mark_Beginning_As_Normal (Mach : in Integer) is
   begin
      case State_Type (Mach) is
         when State_Normal =>

            -- oh, we've already visited here
            return;

         when State_Trailing_Context =>
            State_Type (Mach) := State_Normal;

            if Transchar (Mach) = Sym_Epsilon then
               if (Trans1 (Mach) /= No_Transition) then
                  Mark_Beginning_As_Normal (Trans1 (Mach));
               end if;

               if (Trans2 (Mach) /= No_Transition) then
                  Mark_Beginning_As_Normal (Trans2 (Mach));
               end if;
            end if;
--        when others =>
--          MISC.AFLEXERROR("bad state type in mark_beginning_as_normal()");
      end case;
   end Mark_Beginning_As_Normal;

   -- mkbranch - make a machine that branches to two machines
   --
   --     branch - a machine which matches either first's pattern or second's
--     first, second - machines whose patterns are to be or'ed (the | operator)
   --
   -- note that first and second are NEITHER destroyed by the operation.  Also,
   -- the resulting machine CANNOT be used with any other "mk" operation except
   -- more mkbranch's.  Compare with mkor()
   function Mkbranch (First, Second : in Integer) return Integer is
      Eps : Integer;
   begin
      if (First = No_Transition) then
         return Second;
      else
         if (Second = No_Transition) then
            return First;
         end if;
      end if;

      Eps := Mkstate (Sym_Epsilon);

      Mkxtion (Eps, First);
      Mkxtion (Eps, Second);

      return Eps;
   end Mkbranch;

   -- mkclos - convert a machine into a closure
   --
   --     new - a new state which matches the closure of "state"

   function Mkclos (State : in Integer) return Integer is
   begin
      return Nfa.Mkopt (Mkposcl (State));
   end Mkclos;

   -- mkopt - make a machine optional
   --
   --     new  - a machine which optionally matches whatever mach matched
   --     mach - the machine to make optional
   --
   -- notes:
   --     1. mach must be the last machine created
   --     2. mach is destroyed by the call

   function Mkopt (Mach : in Integer) return Integer is
      Eps    : Integer;
      Result : Integer;
   begin
      Result := Mach;
      if (not Super_Free_Epsilon (Finalst (Result))) then
         Eps    := Nfa.Mkstate (Sym_Epsilon);
         Result := Nfa.Link_Machines (Result, Eps);
      end if;

      -- can't skimp on the following if FREE_EPSILON(mach) is true because
      -- some state interior to "mach" might point back to the beginning
      -- for a closure
      Eps    := Nfa.Mkstate (Sym_Epsilon);
      Result := Nfa.Link_Machines (Eps, Result);

      Nfa.Mkxtion (Result, Finalst (Result));

      return Result;
   end Mkopt;

   -- mkor - make a machine that matches either one of two machines
   --
   --     new - a machine which matches either first's pattern or second's
--     first, second - machines whose patterns are to be or'ed (the | operator)
   --
   -- note that first and second are both destroyed by the operation
   -- the code is rather convoluted because an attempt is made to minimize
   -- the number of epsilon states needed

   function Mkor (First, Second : in Integer) return Integer is
      Eps, Orend : Integer;
      P_First    : Integer;
   begin
      P_First := First;
      if (P_First = Nil) then
         return Second;
      else
         if (Second = Nil) then
            return P_First;
         else

            -- see comment in mkopt() about why we can't use the first state
            -- of "first" or "second" if they satisfy "FREE_EPSILON"
            Eps := Mkstate (Sym_Epsilon);

            P_First := Link_Machines (Eps, P_First);

            Mkxtion (P_First, Second);

            if
              ((Super_Free_Epsilon (Finalst (P_First))) and
               (Accptnum (Finalst (P_First)) = Nil))
            then
               Orend := Finalst (P_First);
               Mkxtion (Finalst (Second), Orend);
            else
               if
                 ((Super_Free_Epsilon (Finalst (Second))) and
                  (Accptnum (Finalst (Second)) = Nil))
               then
                  Orend := Finalst (Second);
                  Mkxtion (Finalst (P_First), Orend);
               else
                  Eps     := Mkstate (Sym_Epsilon);
                  P_First := Link_Machines (P_First, Eps);
                  Orend   := Finalst (P_First);

                  Mkxtion (Finalst (Second), Orend);
               end if;
            end if;
         end if;
      end if;

      Finalst (P_First) := Orend;
      return P_First;
   end Mkor;

   -- mkposcl - convert a machine into a positive closure
   --
   --    new - a machine matching the positive closure of "state"

   function Mkposcl (State : in Integer) return Integer is
      Eps : Integer;
   begin
      if (Super_Free_Epsilon (Finalst (State))) then
         Mkxtion (Finalst (State), State);
         return (State);
      else
         Eps := Mkstate (Sym_Epsilon);
         Mkxtion (Eps, State);
         return (Link_Machines (State, Eps));
      end if;
   end Mkposcl;

   -- mkrep - make a replicated machine
   --
   --    new - a machine that matches whatever "mach" matched from "lb"
   --          number of times to "ub" number of times
   --
   -- note
--   if "ub" is INFINITY then "new" matches "lb" or more occurrences of "mach"

   function Mkrep (Mach, Lb, Ub : in Integer) return Integer is
      Base_Mach, Tail, Copy : Integer;
      P_Mach                : Integer;
   begin
      P_Mach    := Mach;
      Base_Mach := Copysingl (P_Mach, Lb - 1);

      if (Ub = Infinity) then
         Copy   := Dupmachine (P_Mach);
         P_Mach :=
           Link_Machines (P_Mach, Link_Machines (Base_Mach, Mkclos (Copy)));
      else
         Tail := Mkstate (Sym_Epsilon);

         for I in Lb .. Ub - 1 loop
            Copy := Dupmachine (P_Mach);
            Tail := Mkopt (Link_Machines (Copy, Tail));
         end loop;

         P_Mach := Link_Machines (P_Mach, Link_Machines (Base_Mach, Tail));
      end if;

      return P_Mach;
   end Mkrep;

   -- mkstate - create a state with a transition on a given symbol
   --
   --     state - a new state matching sym
   --     sym   - the symbol the new state is to have an out-transition on
   --
   -- note that this routine makes new states in ascending order through the
   -- state array (and increments LASTNFA accordingly).  The routine DUPMACHINE
   -- relies on machines being made in ascending order and that they are
   -- CONTIGUOUS.  Change it and you will have to rewrite DUPMACHINE (kludge
   -- that it admittedly is)

   function Mkstate (Sym : in Integer) return Integer is
   begin
      Lastnfa := Lastnfa + 1;
      if (Lastnfa >= Current_Mns) then
         Current_Mns := Current_Mns + Mns_Increment;
         if (Current_Mns >= Maximum_Mns) then
            Misc.Aflexerror
              ("input rules are too complicated (>= " &
               Integer'Image (Current_Mns) & " NFA states) )");
         end if;

         Num_Reallocs := Num_Reallocs + 1;

         Reallocate_Integer_Array (Firstst, Current_Mns);
         Reallocate_Integer_Array (Lastst, Current_Mns);
         Reallocate_Integer_Array (Finalst, Current_Mns);
         Reallocate_Integer_Array (Transchar, Current_Mns);
         Reallocate_Integer_Array (Trans1, Current_Mns);
         Reallocate_Integer_Array (Trans2, Current_Mns);
         Reallocate_Integer_Array (Accptnum, Current_Mns);
         Reallocate_Integer_Array (Assoc_Rule, Current_Mns);
         Reallocate_State_Enum_Array (State_Type, Current_Mns);
      end if;

      Firstst (Lastnfa)    := Lastnfa;
      Finalst (Lastnfa)    := Lastnfa;
      Lastst (Lastnfa)     := Lastnfa;
      Transchar (Lastnfa)  := Sym;
      Trans1 (Lastnfa)     := No_Transition;
      Trans2 (Lastnfa)     := No_Transition;
      Accptnum (Lastnfa)   := Nil;
      Assoc_Rule (Lastnfa) := Num_Rules;
      State_Type (Lastnfa) := Current_State_Enum;

      -- fix up equivalence classes base on this transition.  Note that any
      -- character which has its own transition gets its own equivalence class.
      -- Thus only characters which are only in character classes have a chance
      -- at being in the same equivalence class.  E.g. "a|b" puts 'a' and 'b'
      -- into two different equivalence classes.  "[ab]" puts them in the same
      -- equivalence class (barring other differences elsewhere in the input).
      if (Sym < 0) then

         -- we don't have to update the equivalence classes since that was
         -- already done when the ccl was created for the first time
         null;
      else
         if (Sym = Sym_Epsilon) then
            Numeps := Numeps + 1;
         else
            if (Useecs) then
               Ecs.Mkechar (Sym, Nextecm, Ecgroup);
            end if;
         end if;
      end if;

      return Lastnfa;
   end Mkstate;

   -- mkxtion - make a transition from one state to another
   --
   --     statefrom - the state from which the transition is to be made
   --     stateto   - the state to which the transition is to be made

   procedure Mkxtion (Statefrom, Stateto : in Integer) is
   begin
      if (Trans1 (Statefrom) = No_Transition) then
         Trans1 (Statefrom) := Stateto;
      else
         if
           ((Transchar (Statefrom) /= Sym_Epsilon) or
            (Trans2 (Statefrom) /= No_Transition))
         then
            Misc.Aflexfatal ("found too many transitions in mkxtion()");
         else

            -- second out-transition for an epsilon state
            Eps2               := Eps2 + 1;
            Trans2 (Statefrom) := Stateto;
         end if;
      end if;
   end Mkxtion;

   -- new_rule - initialize for a new rule
   --
   -- the global num_rules is incremented and the any corresponding dynamic
   -- arrays (such as rule_type()) are grown as needed.

   procedure New_Rule is
   begin
      Num_Rules := Num_Rules + 1;
      if (Num_Rules >= Current_Max_Rules) then
         Num_Reallocs      := Num_Reallocs + 1;
         Current_Max_Rules := Current_Max_Rules + Max_Rules_Increment;
         Reallocate_Rule_Enum_Array (Rule_Type, Current_Max_Rules);
         Reallocate_Integer_Array (Rule_Linenum, Current_Max_Rules);
      end if;

      if (Num_Rules > Max_Rule) then
         Misc.Aflexerror
           ("too many rules  (> " & Integer'Image (Max_Rule) & ")!");
      end if;

      Rule_Linenum (Num_Rules) := Linenum;
   end New_Rule;

end Nfa;
