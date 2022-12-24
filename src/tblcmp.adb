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

-- TITLE table compression routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION used for compressed tables only
-- NOTES somewhat complicated but works fast and generates efficient scanners
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/tblcmpB.a,v 1.8 90/01/12 15:20:43 self Exp Locker: self $

with Dfa, Ecs;

package body Tblcmp is

-- bldtbl - build table entries for dfa state
--
-- synopsis
--   int state[numecs], statenum, totaltrans, comstate, comfreq;
--   bldtbl( state, statenum, totaltrans, comstate, comfreq );
--
-- State is the statenum'th dfa state.  It is indexed by equivalence class and
-- gives the number of the state to enter for a given equivalence class.
-- totaltrans is the total number of transitions out of the state.  Comstate
-- is that state which is the destination of the most transitions out of State.
-- Comfreq is how many transitions there are out of State to Comstate.
--
-- A note on terminology:
--    "protos" are transition tables which have a high probability of
-- either being redundant (a state processed later will have an identical
-- transition table) or nearly redundant (a state processed later will have
-- many of the same out-transitions).  A "most recently used" queue of
-- protos is kept around with the hope that most states will find a proto
-- which is similar enough to be usable, and therefore compacting the
-- output tables.
--    "templates" are a special type of proto.  If a transition table is
-- homogeneous or nearly homogeneous (all transitions go to the same
-- destination) then the odds are good that future states will also go
-- to the same destination state on basically the same character set.
-- These homogeneous states are so common when dealing with large rule
-- sets that they merit special attention.  If the transition table were
-- simply made into a proto, then (typically) each subsequent, similar
-- state will differ from the proto for two out-transitions.  One of these
-- out-transitions will be that character on which the proto does not go
-- to the common destination, and one will be that character on which the
-- state does not go to the common destination.  Templates, on the other
-- hand, go to the common state on EVERY transition character, and therefore
-- cost only one difference.

   procedure Bldtbl
     (State                                   : in Unbounded_Int_Array;
      Statenum, Totaltrans, Comstate, Comfreq : in Integer)
   is
      Extptr : Integer;
      subtype Carray is Unbounded_Int_Array (0 .. Csize + 1);
      Extrct                 : array (0 .. 1) of Carray;
      Mindiff, Minprot, I, D : Integer;
      Checkcom               : Boolean;
      Local_Comstate         : Integer;
   begin

   -- If extptr is 0 then the first array of extrct holds the result of the
   -- "best difference" to date, which is those transitions which occur in
   -- "state" but not in the proto which, to date, has the fewest differences
   -- between itself and "state".  If extptr is 1 then the second array of
   -- extrct hold the best difference.  The two arrays are toggled
   -- between so that the best difference to date can be kept around and
   -- also a difference just created by checking against a candidate "best"
   -- proto.
      Local_Comstate := Comstate;
      Extptr         := 0;

      -- if the state has too few out-transitions, don't bother trying to
      -- compact its tables
      if Totaltrans * 100 < Numecs * Proto_Size_Percentage then
         Mkentry (State, Numecs, Statenum, Jamstate_Const, Totaltrans);
      else

         -- checkcom is true if we should only check "state" against
         -- protos which have the same "comstate" value
         Checkcom := Comfreq * 100 > Totaltrans * Check_Com_Percentage;

         Minprot := Firstprot;
         Mindiff := Totaltrans;

         if Checkcom then

            -- find first proto which has the same "comstate"
            I := Firstprot;
            while (I /= Nil) loop
               if Protcomst (I) = Local_Comstate then
                  Minprot := I;
                  Tbldiff (State, Minprot, Extrct (Extptr), Mindiff);
                  exit;
               end if;
               I := Protnext (I);
            end loop;
         else

            -- since we've decided that the most common destination out
            -- of "state" does not occur with a high enough frequency,
            -- we set the "comstate" to zero, assuring that if this state
            -- is entered into the proto list, it will not be considered
            -- a template.
            Local_Comstate := 0;

            if Firstprot /= Nil then
               Minprot := Firstprot;
               Tbldiff (State, Minprot, Extrct (Extptr), Mindiff);
            end if;
         end if;

         -- we now have the first interesting proto in "minprot".  If
         -- it matches within the tolerances set for the first proto,
         -- we don't want to bother scanning the rest of the proto list
         -- to see if we have any other reasonable matches.
         if Mindiff * 100 > Totaltrans * First_Match_Diff_Percentage then

            -- not a good enough match.  Scan the rest of the protos
            I := Minprot;
            while I /= Nil loop
               Tbldiff (State, I, Extrct (1 - Extptr), D);
               if D < Mindiff then
                  Extptr  := 1 - Extptr;
                  Mindiff := D;
                  Minprot := I;
               end if;
               I := Protnext (I);
            end loop;
         end if;

         -- check if the proto we've decided on as our best bet is close
         -- enough to the state we want to match to be usable
         if Mindiff * 100 > Totaltrans * Acceptable_Diff_Percentage then

            -- no good.  If the state is homogeneous enough, we make a
            -- template out of it.  Otherwise, we make a proto.
            if Comfreq * 100 >= Totaltrans * Template_Same_Percentage then
               Mktemplate (State, Statenum, Local_Comstate);
            else
               Mkprot (State, Statenum, Local_Comstate);
               Mkentry (State, Numecs, Statenum, Jamstate_Const, Totaltrans);
            end if;
         else

            -- use the proto
            Mkentry
              (Extrct (Extptr), Numecs, Statenum, Prottbl (Minprot), Mindiff);

            -- if this state was sufficiently different from the proto
            -- we built it from, make it, too, a proto
            if Mindiff * 100 >= Totaltrans * New_Proto_Diff_Percentage then
               Mkprot (State, Statenum, Local_Comstate);
            end if;

            -- since mkprot added a new proto to the proto queue, it's possible
            -- that "minprot" is no longer on the proto queue (if it happened
            -- to have been the last entry, it would have been bumped off).
            -- If it's not there, then the new proto took its physical place
            -- (though logically the new proto is at the beginning of the
            -- queue), so in that case the following call will do nothing.
            Mv2front (Minprot);
         end if;
      end if;
   end Bldtbl;

   -- cmptmps - compress template table entries
   --
   --  template tables are compressed by using the 'template equivalence
   --  classes', which are collections of transition character equivalence
--  classes which always appear together in templates - really meta-equivalence
   --  classes.  until this point, the tables for templates have been stored
   --  up at the top end of the nxt array; they will now be compressed and have
   --  table entries made for them.

   procedure Cmptmps is
      Tmpstorage        : C_Size_Array;
      Totaltrans, Trans : Integer;
   begin
      Peakpairs := Numtemps * Numecs + Tblend;

      if Usemecs then

         -- create equivalence classes base on data gathered on template
         -- transitions
         Ecs.Cre8ecs (Tecfwd, Tecbck, Numecs, Nummecs);
      else
         Nummecs := Numecs;
      end if;

      if Lastdfa + Numtemps + 1 >= Current_Max_Dfas then
         Dfa.Increase_Max_Dfas;
      end if;

      -- loop through each template
      for I in 1 .. Numtemps loop
         Totaltrans := 0;

         -- number of non-jam transitions out of this template
         for J in 1 .. Numecs loop
            Trans := Tnxt (Numecs * I + J);

            if Usemecs then

               -- the absolute value of tecbck is the meta-equivalence class
               -- of a given equivalence class, as set up by cre8ecs
               if Tecbck (J) > 0 then
                  Tmpstorage (Tecbck (J)) := Trans;

                  if Trans > 0 then
                     Totaltrans := Totaltrans + 1;
                  end if;
               end if;
            else
               Tmpstorage (J) := Trans;

               if Trans > 0 then
                  Totaltrans := Totaltrans + 1;
               end if;
            end if;
         end loop;

         -- it is assumed (in a rather subtle way) in the skeleton that
         -- if we're using meta-equivalence classes, the def[] entry for
         -- all templates is the jam template, i.e., templates never default
         -- to other non-jam table entries (e.g., another template)

         -- leave room for the jam-state after the last real state
         Mkentry
           (Tmpstorage, Nummecs, Lastdfa + I + 1, Jamstate_Const, Totaltrans);
      end loop;
   end Cmptmps;

   -- expand_nxt_chk - expand the next check arrays

   procedure Expand_Nxt_Chk is
      Old_Max : constant Integer := Current_Max_Xpairs;
   begin
      Current_Max_Xpairs := Current_Max_Xpairs + Max_Xpairs_Increment;

      Num_Reallocs := Num_Reallocs + 1;

      Reallocate_Integer_Array (Nxt, Current_Max_Xpairs);
      Reallocate_Integer_Array (Chk, Current_Max_Xpairs);

      for I in Old_Max .. Current_Max_Xpairs loop
         Chk (I) := 0;
      end loop;
   end Expand_Nxt_Chk;

   -- find_table_space - finds a space in the table for a state to be placed
   --
   -- State is the state to be added to the full speed transition table.
   -- Numtrans is the number of out-transitions for the state.
   --
-- find_table_space() returns the position of the start of the first block (in
   -- chk) able to accommodate the state
   --
-- In determining if a state will or will not fit, find_table_space() must take
   -- into account the fact that an end-of-buffer state will be added at [0],
   -- and an action number will be added in [-1].

   function Find_Table_Space
     (State : in Unbounded_Int_Array; Numtrans : in Integer) return Integer
   is
      -- firstfree is the position of the first possible occurrence of two
      -- consecutive unused records in the chk and nxt arrays

      I, Cnt, Scnt : Integer;
      -- if there are too many out-transitions, put the state at the end of
      -- nxt and chk
   begin
      if Numtrans > Max_Xtions_Full_Interior_Fit then

         -- if table is empty, return the first available spot in chk/nxt,
         -- which should be 1
         if Tblend < 2 then
            return 1;
         end if;

         I := Tblend - Numecs;

         -- start searching for table space near the
         -- end of chk/nxt arrays
      else
         I := Firstfree;

         -- start searching for table space from the
         -- beginning (skipping only the elements
         -- which will definitely not hold the new
         -- state)
      end if;

      loop

         -- loops until a space is found
         if I + Numecs > Current_Max_Xpairs then
            Expand_Nxt_Chk;
         end if;

         -- loops until space for end-of-buffer and action number are found
         loop
            if Chk (I - 1) = 0 then

               -- check for action number space
               if Chk (I) = 0 then

                  -- check for end-of-buffer space
                  exit;
               else
                  I := I + 2;

                  -- since i != 0, there is no use checking to
                  -- see if (++i) - 1 == 0, because that's the
                  -- same as i == 0, so we skip a space
               end if;
            else
               I := I + 1;
            end if;

            if I + Numecs > Current_Max_Xpairs then
               Expand_Nxt_Chk;
            end if;
         end loop;

      -- if we started search from the beginning, store the new firstfree for
      -- the next call of find_table_space()
         if Numtrans <= Max_Xtions_Full_Interior_Fit then
            Firstfree := I + 1;
         end if;

         -- check to see if all elements in chk (and therefore nxt) that are
         -- needed for the new state have not yet been taken
         Cnt  := I + 1;
         Scnt := 1;
         while Cnt /= I + Numecs + 1 loop
            if State (Scnt) /= 0 and Chk (Cnt) /= 0 then
               exit;
            end if;
            Scnt := Scnt + 1;
            Cnt  := Cnt + 1;
         end loop;

         if Cnt = I + Numecs + 1 then
            return I;
         else
            I := I + 1;
         end if;
      end loop;
   end Find_Table_Space;

   -- inittbl - initialize transition tables
   --
-- Initializes "firstfree" to be one beyond the end of the table.  Initializes
   -- all "chk" entries to be zero.  Note that templates are built in their
   -- own tbase/tdef tables.  They are shifted down to be contiguous
   -- with the non-template entries during table generation.

   procedure Inittbl is
   begin
      for I in 0 .. Current_Max_Xpairs loop
         Chk (I) := 0;
      end loop;

      Tblend    := 0;
      Firstfree := Tblend + 1;
      Numtemps  := 0;

      if Usemecs then

         -- set up doubly-linked meta-equivalence classes
         -- these are sets of equivalence classes which all have identical
         -- transitions out of TEMPLATES
         Tecbck (1) := Nil;

         for I in 2 .. Numecs loop
            Tecbck (I)     := I - 1;
            Tecfwd (I - 1) := I;
         end loop;

         Tecfwd (Numecs) := Nil;
      end if;
   end Inittbl;

   -- mkdeftbl - make the default, "jam" table entries

   procedure Mkdeftbl is
   begin
      Jamstate := Lastdfa + 1;

      Tblend := Tblend + 1;

      -- room for transition on end-of-buffer character
      if Tblend + Numecs > Current_Max_Xpairs then
         Expand_Nxt_Chk;
      end if;

      -- add in default end-of-buffer transition
      Nxt (Tblend) := End_Of_Buffer_State;
      Chk (Tblend) := Jamstate;

      for I in 1 .. Numecs loop
         Nxt (Tblend + I) := 0;
         Chk (Tblend + I) := Jamstate;
      end loop;

      Jambase := Tblend;

      Base (Jamstate) := Jambase;
      Def (Jamstate)  := 0;

      Tblend   := Tblend + Numecs;
      Numtemps := Numtemps + 1;
   end Mkdeftbl;

   -- mkentry - create base/def and nxt/chk entries for transition array
   --
   -- "state" is a transition array "numchars" characters in size, "statenum"
   -- is the offset to be used into the base/def tables, and "deflink" is the
   -- entry to put in the "def" table entry.  If "deflink" is equal to
   -- "JAMSTATE", then no attempt will be made to fit zero entries of "state"
   -- (i.e., jam entries) into the table.  It is assumed that by linking to
   -- "JAMSTATE" they will be taken care of.  In any case, entries in "state"
   -- marking transitions to "SAME_TRANS" are treated as though they will be
   -- taken care of by whereever "deflink" points.  "totaltrans" is the total
-- number of transitions out of the state.  If it is below a certain threshold,
   -- the tables are searched for an interior spot that will accommodate the
   -- state array.

   procedure Mkentry
     (State                                   : in Unbounded_Int_Array;
      Numchars, Statenum, Deflink, Totaltrans : in Integer)
   is
      I, Minec, Maxec, Baseaddr, Tblbase, Tbllast : Integer;
   begin
      if Totaltrans = 0 then

         -- there are no out-transitions
         if Deflink = Jamstate_Const then
            Base (Statenum) := Jamstate_Const;
         else
            Base (Statenum) := 0;
         end if;

         Def (Statenum) := Deflink;
         return;
      end if;

      Minec := 1;
      while Minec <= Numchars loop
         if State (Minec) /= Same_Trans then
            if State (Minec) /= 0 or Deflink /= Jamstate_Const then
               exit;
            end if;
         end if;
         Minec := Minec + 1;
      end loop;

      if Totaltrans = 1 then

         -- there's only one out-transition.  Save it for later to fill
         -- in holes in the tables.
         Stack1 (Statenum, Minec, State (Minec), Deflink);
         return;
      end if;

      Maxec := Numchars;
      while Maxec >= 1 loop
         if State (Maxec) /= Same_Trans then
            if State (Maxec) /= 0 or Deflink /= Jamstate_Const then
               exit;
            end if;
         end if;
         Maxec := Maxec - 1;
      end loop;

   -- Whether we try to fit the state table in the middle of the table
   -- entries we have already generated, or if we just take the state
   -- table at the end of the nxt/chk tables, we must make sure that we
   -- have a valid base address (i.e., non-negative).  Note that not only are
   -- negative base addresses dangerous at run-time (because indexing the
   -- next array with one and a low-valued character might generate an
   -- array-out-of-bounds error message), but at compile-time negative
   -- base addresses denote TEMPLATES.

      -- find the first transition of state that we need to worry about.
      if Totaltrans * 100 <= Numchars * Interior_Fit_Percentage then

         -- attempt to squeeze it into the middle of the tabls
         Baseaddr := Firstfree;

         while Baseaddr < Minec loop

            -- using baseaddr would result in a negative base address below
            -- find the next free slot
            Baseaddr := Baseaddr + 1;
            while Chk (Baseaddr) /= 0 loop
               Baseaddr := Baseaddr + 1;
            end loop;
         end loop;

         if Baseaddr + Maxec - Minec >= Current_Max_Xpairs then
            Expand_Nxt_Chk;
         end if;

         I := Minec;
         while I <= Maxec loop
            if State (I) /= Same_Trans then
               if State (I) /= 0 or Deflink /= Jamstate_Const then
                  if Chk (Baseaddr + I - Minec) /= 0 then

                     -- baseaddr unsuitable - find another
                     Baseaddr := Baseaddr + 1;
                     while Baseaddr < Current_Max_Xpairs and
                       Chk (Baseaddr) /= 0
                     loop
                        Baseaddr := Baseaddr + 1;
                     end loop;

                     if Baseaddr + Maxec - Minec >= Current_Max_Xpairs then
                        Expand_Nxt_Chk;
                     end if;

                     -- reset the loop counter so we'll start all
                     -- over again next time it's incremented
                     I := Minec - 1;
                  end if;
               end if;
            end if;
            I := I + 1;
         end loop;
      else

         -- ensure that the base address we eventually generate is
         -- non-negative
         Baseaddr := Integer'Max (Tblend + 1, Minec);
      end if;

      Tblbase := Baseaddr - Minec;
      Tbllast := Tblbase + Maxec;

      if Tbllast >= Current_Max_Xpairs then
         Expand_Nxt_Chk;
      end if;

      Base (Statenum) := Tblbase;
      Def (Statenum)  := Deflink;

      for J in Minec .. Maxec loop
         if State (J) /= Same_Trans then
            if State (J) /= 0 or Deflink /= Jamstate_Const then
               Nxt (Tblbase + J) := State (J);
               Chk (Tblbase + J) := Statenum;
            end if;
         end if;
      end loop;

      if Baseaddr = Firstfree then

         -- find next free slot in tables
         Firstfree := Firstfree + 1;
         while Chk (Firstfree) /= 0 loop
            Firstfree := Firstfree + 1;
         end loop;
      end if;

      Tblend := Integer'Max (Tblend, Tbllast);
   end Mkentry;

   -- mk1tbl - create table entries for a state (or state fragment) which
   --            has only one out-transition

   procedure Mk1tbl (State, Sym, Onenxt, Onedef : in Integer) is
   begin
      if Firstfree < Sym then
         Firstfree := Sym;
      end if;

      while Chk (Firstfree) /= 0 loop
         Firstfree := Firstfree + 1;
         if Firstfree >= Current_Max_Xpairs then
            Expand_Nxt_Chk;
         end if;
      end loop;

      Base (State)    := Firstfree - Sym;
      Def (State)     := Onedef;
      Chk (Firstfree) := State;
      Nxt (Firstfree) := Onenxt;

      if Firstfree > Tblend then
         Tblend    := Firstfree;
         Firstfree := Firstfree + 1;

         if Firstfree >= Current_Max_Xpairs then
            Expand_Nxt_Chk;
         end if;
      end if;
   end Mk1tbl;

   -- mkprot - create new proto entry

   procedure Mkprot
     (State : in Unbounded_Int_Array; Statenum, Comstate : in Integer)
   is
      Slot, Tblbase : Integer;
   begin
      Numprots := Numprots + 1;
      if Numprots >= Msp or Numecs * Numprots >= Prot_Save_Size then

         -- gotta make room for the new proto by dropping last entry in
         -- the queue
         Slot                := Lastprot;
         Lastprot            := Protprev (Lastprot);
         Protnext (Lastprot) := Nil;
      else
         Slot := Numprots;
      end if;

      Protnext (Slot) := Firstprot;

      if Firstprot /= Nil then
         Protprev (Firstprot) := Slot;
      end if;

      Firstprot        := Slot;
      Prottbl (Slot)   := Statenum;
      Protcomst (Slot) := Comstate;

      -- copy state into save area so it can be compared with rapidly
      Tblbase := Numecs * (Slot - 1);

      for I in 1 .. Numecs loop
         Protsave (Tblbase + I) := State (I + State'First);
      end loop;
   end Mkprot;

-- mktemplate - create a template entry based on a state, and connect the state
   --              to it

   procedure Mktemplate
     (State : in Unbounded_Int_Array; Statenum, Comstate : in Integer)
   is
      Numdiff, Tmpbase : Integer;
      Tmp              : C_Size_Array;
      subtype Tarray is Char_Array (0 .. Csize);
      Transset : Tarray;
      Tsptr    : Integer;
   begin
      Numtemps := Numtemps + 1;

      Tsptr := 0;

      -- calculate where we will temporarily store the transition table
      -- of the template in the tnxt[] array.  The final transition table
      -- gets created by cmptmps()
      Tmpbase := Numtemps * Numecs;

      if Tmpbase + Numecs >= Current_Max_Template_Xpairs then
         Current_Max_Template_Xpairs :=
           Current_Max_Template_Xpairs + Max_Template_Xpairs_Increment;

         Num_Reallocs := Num_Reallocs + 1;

         Reallocate_Integer_Array (Tnxt, Current_Max_Template_Xpairs);
      end if;

      for I in 1 .. Numecs loop
         if State (I) = 0 then
            Tnxt (Tmpbase + I) := 0;
         else
            Transset (Tsptr)   := Character'Val (I);
            Tsptr              := Tsptr + 1;
            Tnxt (Tmpbase + I) := Comstate;
         end if;
      end loop;

      if Usemecs then
         Ecs.Mkeccl (Transset, Tsptr, Tecfwd, Tecbck, Numecs);
      end if;

      Mkprot
        (Tnxt (Tmpbase .. Current_Max_Template_Xpairs), -Numtemps, Comstate);

      -- we rely on the fact that mkprot adds things to the beginning
      -- of the proto queue
      Tbldiff (State, Firstprot, Tmp, Numdiff);
      Mkentry (Tmp, Numecs, Statenum, -Numtemps, Numdiff);
   end Mktemplate;

   -- mv2front - move proto queue element to front of queue

   procedure Mv2front (Qelm : in Integer) is
   begin
      if Firstprot /= Qelm then
         if Qelm = Lastprot then
            Lastprot := Protprev (Lastprot);
         end if;

         Protnext (Protprev (Qelm)) := Protnext (Qelm);

         if Protnext (Qelm) /= Nil then
            Protprev (Protnext (Qelm)) := Protprev (Qelm);
         end if;

         Protprev (Qelm)      := Nil;
         Protnext (Qelm)      := Firstprot;
         Protprev (Firstprot) := Qelm;
         Firstprot            := Qelm;
      end if;
   end Mv2front;

   -- place_state - place a state into full speed transition table
   --
   -- State is the statenum'th state.  It is indexed by equivalence class and
   -- gives the number of the state to enter for a given equivalence class.
   -- Transnum is the number of out-transitions for the state.

   procedure Place_State
     (State : in Unbounded_Int_Array; Statenum, Transnum : in Integer)
   is
      I        : Integer;
      Position : constant Integer := Find_Table_Space (State, Transnum);
   begin

      -- base is the table of start positions
      Base (Statenum) := Position;

      -- put in action number marker; this non-zero number makes sure that
      -- find_table_space() knows that this position in chk/nxt is taken
      -- and should not be used for another accepting number in another state
      Chk (Position - 1) := 1;

      -- put in end-of-buffer marker; this is for the same purposes as above
      Chk (Position) := 1;

      -- place the state into chk and nxt
      I := 1;
      while I <= Numecs loop
         if State (I) /= 0 then
            Chk (Position + I) := I;
            Nxt (Position + I) := State (I);
         end if;
         I := I + 1;
      end loop;

      if Position + Numecs > Tblend then
         Tblend := Position + Numecs;
      end if;
   end Place_State;

   -- stack1 - save states with only one out-transition to be processed later
   --
   -- if there's room for another state one the "one-transition" stack, the
   -- state is pushed onto it, to be processed later by mk1tbl.  If there's
   -- no room, we process the sucker right now.

   procedure Stack1 (Statenum, Sym, Nextstate, Deflink : in Integer) is
   begin
      if Onesp >= One_Stack_Size - 1 then
         Mk1tbl (Statenum, Sym, Nextstate, Deflink);
      else
         Onesp            := Onesp + 1;
         Onestate (Onesp) := Statenum;
         Onesym (Onesp)   := Sym;
         Onenext (Onesp)  := Nextstate;
         Onedef (Onesp)   := Deflink;
      end if;
   end Stack1;

   -- tbldiff - compute differences between two state tables
   --
   -- "state" is the state array which is to be extracted from the pr'th
   -- proto.  "pr" is both the number of the proto we are extracting from
   -- and an index into the save area where we can find the proto's complete
   -- state table.  Each entry in "state" which differs from the corresponding
   -- entry of "pr" will appear in "ext".
   -- Entries which are the same in both "state" and "pr" will be marked
   -- as transitions to "SAME_TRANS" in "ext".  The total number of differences
   -- between "state" and "pr" is returned as function value.  Note that this
   -- number is "numecs" minus the number of "SAME_TRANS" entries in "ext".

   procedure Tbldiff
     (State : in     Unbounded_Int_Array; Pr : in Integer;
      Ext   :    out Unbounded_Int_Array; Result : out Integer)
   is
      Sp      : Integer := 0;
      Ep      : Integer := 0;
      Numdiff : Integer := 0;
      Protp   : Integer;
   begin
      Protp := Numecs * (Pr - 1);

      for I in reverse 1 .. Numecs loop
         Protp := Protp + 1;
         Sp    := Sp + 1;
         if Protsave (Protp) = State (Sp) then
            Ep       := Ep + 1;
            Ext (Ep) := Same_Trans;
         else
            Ep       := Ep + 1;
            Ext (Ep) := State (Sp);
            Numdiff  := Numdiff + 1;
         end if;
      end loop;

      Result := Numdiff;
   end Tbldiff;

end Tblcmp;
