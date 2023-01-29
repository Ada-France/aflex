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

-- TITLE scanner generation
-- AUTHOR: John Self (UCI)
-- DESCRIPTION
-- NOTES does actual generation (writing) of output aflex scanners
-- $Header: /dc/uc/self/tmp/gnat_aflex/RCS/gen.adb,v 1.1 1995/07/04 20:21:29 self Exp self $

with Misc_Defs, Text_Io, Misc, Int_Io, Tstring, Parse_Tokens;
with Scanner, Skeleton_Manager;
use Misc_Defs, Text_Io, Tstring, Parse_Tokens;

package body Gen is
   Indent_Level : Integer          := 0;  -- each level is 4 spaces
   Indent_Base  : constant Natural := 3;
   Max_Short    : constant Integer := 32_767;

   procedure Indent_Up is
   begin
      Indent_Level := Indent_Level + 1;
   end Indent_Up;

   procedure Indent_Down is
   begin
      Indent_Level := Indent_Level - 1;
   end Indent_Down;

   procedure Set_Indent (Indent_Val : in Integer) is
   begin
      Indent_Level := Indent_Val;
   end Set_Indent;

   -- indent to the current level

   procedure Do_Indent is
      I : Integer := Indent_Level * Indent_Base;
   begin
      while I > 0 loop
         Text_Io.Put (' ');
         I := I - 1;
      end loop;
   end Do_Indent;

   -- generate the code to keep backtracking information

   procedure Gen_Backtracking is
   begin
      if Num_Backtracking = 0 then
         return;
      end if;

      Indent_Puts ("if yy_accept (yy_current_state) /= 0 then");

      Indent_Up;
      Indent_Puts ("yy_last_accepting_state := yy_current_state;");
      Indent_Puts ("yy_last_accepting_cpos := yy_cp;");
      if Use_Yylineno then
         Indent_Puts ("yy_last_yylineno := yylineno;");
         Indent_Puts ("yy_last_yylinecol := yylinecol;");
      end if;
      Indent_Down;
      Indent_Puts ("end if;");
   end Gen_Backtracking;

   -- generate the code to perform the backtrack

   procedure Gen_Bt_Action is
   begin
      if Num_Backtracking = 0 then
         return;
      end if;

      Set_Indent (4);

      Indent_Puts ("when 0 => -- must backtrack");
      Indent_Puts ("-- undo the effects of YY_DO_BEFORE_ACTION");
      Indent_Puts ("yy_ch_buf (yy_cp) := yy_hold_char;");

      if Fulltbl then
         Indent_Puts ("yy_cp := yy_last_accepting_cpos + 1;");
         if Use_Yylineno then
            Indent_Puts ("yylineno := yy_last_yylineno;");
            Indent_Puts ("yylinecol := yy_last_yylinecol;");
         end if;
      else

         -- backtracking info for compressed tables is taken \after/
         -- yy_cp has been incremented for the next state
         Indent_Puts ("yy_cp := yy_last_accepting_cpos;");
         if Use_Yylineno then
            Indent_Puts ("yylineno := yy_last_yylineno;");
            Indent_Puts ("yylinecol := yy_last_yylinecol;");
         end if;
      end if;

      Indent_Puts ("yy_current_state := yy_last_accepting_state;");
      Indent_Puts ("goto next_action;");
      Text_Io.New_Line;

      Set_Indent (0);
   end Gen_Bt_Action;

   -- generate equivalence-class table

   procedure Genecs is
      I, Numrows : Integer;
   begin
      Text_Io.Put ("      yy_ec : constant array (ASCII.NUL .. ");
      Text_Io.Put_Line
        ("Character'Last) of Short := (0,"); -- GdM for >7 bit ch.
--      TEXT_IO.PUT_LINE("      (0, ");

      for Char_Count in 1 .. Csize loop
         if
           (Caseins and
            ((Char_Count >= Character'Pos ('A')) and
             (Char_Count <= Character'Pos ('Z'))))
         then
            Ecgroup (Char_Count) := Ecgroup (Misc.Clower (Char_Count));
         end if;

         Ecgroup (Char_Count) := abs (Ecgroup (Char_Count));
         Misc.Mkdata (Ecgroup (Char_Count));
      end loop;

      -- GdM for >7 bit ch.
      Text_Io.Put_Line (", others => 1");

      Misc.Dataend;

      if (Trace) then
         Text_Io.New_Line (Standard_Error);
         Text_Io.New_Line (Standard_Error);
         Text_Io.Put (Standard_Error, "Equivalence Classes:");
         Text_Io.New_Line (Standard_Error);
         Text_Io.New_Line (Standard_Error);
         Numrows := (Csize + 1) / 8;

         for J in 1 .. Numrows loop
            I := J;
            while I <= Csize loop
               Tstring.Put
                 (Standard_Error, Misc.Readable_Form (Character'Val (I)));
               Text_Io.Put (Standard_Error, " = ");
               Int_Io.Put (Standard_Error, Ecgroup (I), 1);
               Text_Io.Put (Standard_Error, "   ");
               I := I + Numrows;
            end loop;
            Text_Io.New_Line (Standard_Error);
         end loop;
      end if;
   end Genecs;

   -- generate the code to find the action number

   procedure Gen_Find_Action is
   begin
      Indent_Puts ("yy_act := yy_accept (yy_current_state);");
   end Gen_Find_Action;

   -- genftbl - generates full transition table

   procedure Genftbl is
      End_Of_Buffer_Action : constant Integer := Num_Rules + 1;
      -- *everything* is done in terms of arrays starting at 1, so provide
      -- a null entry for the zero element of all C arrays
   begin
      Text_Io.Put ("      yy_accept : constant array (0 .. ");
      Int_Io.Put (Lastdfa, 1);
      Text_Io.Put_Line (") of Short :=");
      Text_Io.Put_Line ("         (0,");

      Dfaacc (End_Of_Buffer_State).Dfaacc_State := End_Of_Buffer_Action;

      for I in 1 .. Lastdfa loop
         declare
            Anum : constant Integer := Dfaacc (I).Dfaacc_State;
         begin
            Misc.Mkdata (Anum);

            if (Trace and (Anum /= 0)) then
               Text_Io.Put (Standard_Error, "state # ");
               Int_Io.Put (Standard_Error, I, 1);
               Text_Io.Put (Standard_Error, " accepts: [");
               Int_Io.Put (Standard_Error, Anum, 1);
               Text_Io.Put (Standard_Error, "]");
               Text_Io.New_Line (Standard_Error);
            end if;
         end;
      end loop;

      Misc.Dataend;

      if (Useecs) then
         Genecs;
      end if;

      -- don't have to dump the actual full table entries - they were created
      -- on-the-fly
   end Genftbl;

   -- generate the code to find the next compressed-table state

   procedure Gen_Next_Compressed_State is
   begin
      if (Useecs) then
         Indent_Puts ("yy_c := yy_ec (yy_ch_buf (yy_cp));");
      else
         Indent_Puts ("yy_c := yy_ch_buf (yy_cp);");
      end if;

      -- save the backtracking info \before/ computing the next state
      -- because we always compute one more state than needed - we
      -- always proceed until we reach a jam state
      Gen_Backtracking;

      Indent_Puts
        ("while yy_chk (yy_base (yy_current_state) + yy_c) /= yy_current_state loop");
      Indent_Up;
      Indent_Puts ("yy_current_state := yy_def (yy_current_state);");

      if (Usemecs) then

         -- we've arrange it so that templates are never chained
         -- to one another.  This means we can afford make a
         -- very simple test to see if we need to convert to
         -- yy_c's meta-equivalence class without worrying
         -- about erroneously looking up the meta-equivalence
         -- class twice
         Do_Indent;

         -- lastdfa + 2 is the beginning of the templates
         Text_Io.Put ("if yy_current_state >= ");
         Int_Io.Put (Lastdfa + 2, 1);
         Text_Io.Put_Line (" then");

         Indent_Up;
         Indent_Puts ("yy_c := yy_meta (yy_c);");
         Indent_Down;
         Indent_Puts ("end if;");
      end if;

      Indent_Down;
      Indent_Puts ("end loop;");

      Indent_Puts
        ("yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);");
      Indent_Down;
   end Gen_Next_Compressed_State;

   -- generate the code to find the next match

   procedure Gen_Next_Match is
   -- note - changes in here should be reflected in get_next_state
   begin
      if Fulltbl then
         Indent_Puts
           ("yy_current_state := yy_nxt (yy_current_state, yy_ch_buf (yy_cp));");
         Indent_Puts ("while yy_current_state > 0 loop");
         Indent_Up;
         if Use_Yylineno then
            Indent_Puts ("if yy_ch_buf (yy_cp) = ASCII.LF then");
            Indent_Up;
            Indent_Puts ("yylineno := yylineno + 1;");
            Indent_Puts ("yylinecol := 0;");
            Indent_Down;
            Indent_Puts ("else");
            Indent_Up;
            Indent_Puts ("yylinecol := yylinecol + 1;");
            Indent_Down;
            Indent_Puts ("end if;");
         end if;
         Indent_Puts ("yy_cp := yy_cp + 1;");
         Indent_Puts
           ("yy_current_state := yy_nxt (yy_current_state, yy_ch_buf (yy_cp));");
         Indent_Down;
         Indent_Puts ("end loop;");

         if (Num_Backtracking > 0) then
            Gen_Backtracking;
            Text_Io.New_Line;
         end if;

         Text_Io.New_Line;
         Indent_Puts ("yy_current_state := -yy_current_state;");
      else

         -- compressed
         Indent_Puts ("loop");

         Indent_Up;

         Gen_Next_State;
         if Use_Yylineno then
            Indent_Puts ("if yy_ch_buf (yy_cp) = ASCII.LF then");
            Indent_Up;
            Indent_Puts ("yylineno := yylineno + 1;");
            Indent_Puts ("yylinecol := 0;");
            Indent_Down;
            Indent_Puts ("else");
            Indent_Up;
            Indent_Puts ("yylinecol := yylinecol + 1;");
            Indent_Down;
            Indent_Puts ("end if;");
         end if;

         Indent_Puts ("yy_cp := yy_cp + 1;");

         if Interactive then
            Text_Io.Put ("            if yy_base (yy_current_state) = ");
            Int_Io.Put (Jambase, 1);
         else
            Text_Io.Put ("            if yy_current_state = ");
            Int_Io.Put (Jamstate, 1);
         end if;

         Text_Io.Put_Line (" then");
         Text_Io.Put_Line ("                exit;");
         Text_Io.Put_Line ("            end if;");

         Indent_Down;

         Do_Indent;

         Text_Io.Put_Line ("end loop;");

         if not Interactive then
            Indent_Puts ("yy_cp := yy_last_accepting_cpos;");
            Indent_Puts ("yy_current_state := yy_last_accepting_state;");
            if Use_Yylineno then
               Indent_Puts ("yylineno := yy_last_yylineno;");
               Indent_Puts ("yylinecol := yy_last_yylinecol;");
            end if;
         end if;
      end if;
   end Gen_Next_Match;

   -- generate the code to find the next state

   procedure Gen_Next_State is
   -- note - changes in here should be reflected in get_next_match
   begin
      Indent_Up;
      if Fulltbl then
         Indent_Puts ("yy_current_state := yy_nxt (yy_current_state,");
         Indent_Puts ("                    yy_ch_buf (yy_cp));");
         Gen_Backtracking;
      else
         Gen_Next_Compressed_State;
      end if;
   end Gen_Next_State;

   -- generate the code to find the start state

   procedure Gen_Start_State is
   begin
      Indent_Puts ("yy_current_state := yy_start;");

      if Bol_Needed then
         Indent_Puts ("if yy_ch_buf (yy_bp - 1) = ASCII.LF then");
         Indent_Up;
         Indent_Puts ("yy_current_state := yy_current_state + 1;");
         Indent_Down;
         Indent_Puts ("end if;");
      end if;

   end Gen_Start_State;

   -- gentabs - generate data statements for the transition tables

   procedure Gentabs is
      I, K, Total_States   : Integer;
      Acc_Array            : Int_Ptr;
      End_Of_Buffer_Action : constant Integer := Num_Rules + 1;
      -- *everything* is done in terms of arrays starting at 1, so provide
      -- a null entry for the zero element of all C arrays

      --    C_LONG_DECL                 : STRING(1 .. 44) :=
      --      "static const long int %s[%d] =\n    {   0,\n";
      --    C_SHORT_DECL                : STRING(1 .. 45) :=
      --      "static const short int %s[%d] =\n    {   0,\n";
      --    C_CHAR_DECL                 : STRING(1 .. 40) :=
      --      "static const char %s[%d] =\n    {   0,\n";
   begin
      Acc_Array := Allocate_Integer_Array (Current_Max_Dfas);
      Nummt     := 0;

      -- the compressed table format jams by entering the "jam state",
      -- losing information about the previous state in the process.
      -- In order to recover the previous state, we effectively need
      -- to keep backtracking information.
      Num_Backtracking := Num_Backtracking + 1;

      Dfaacc (End_Of_Buffer_State).Dfaacc_State := End_Of_Buffer_Action;

      for Cnt in 1 .. Lastdfa loop
         Acc_Array (Cnt) := Dfaacc (Cnt).Dfaacc_State;
      end loop;

      Acc_Array (Lastdfa + 1) := 0;

      -- add accepting number for the jam state

      -- spit out ALIST array, dumping the accepting numbers.

      -- "lastdfa + 2" is the size of ALIST; includes room for arrays
      -- beginning at 0 and for "jam" state
      K := Lastdfa + 2;

      Text_Io.Put ("      yy_accept : constant array (0 .. ");
      Int_Io.Put (K - 1, 1);
      Text_Io.Put_Line (") of Short :=");
      Text_Io.Put_Line ("          (0,");
      for Cnt in 1 .. Lastdfa loop
         Misc.Mkdata (Acc_Array (Cnt));

         if (Trace and (Acc_Array (Cnt) /= 0)) then
            Text_Io.Put (Standard_Error, "state # ");
            Int_Io.Put (Standard_Error, Cnt, 1);
            Text_Io.Put (Standard_Error, " accepts: [");
            Int_Io.Put (Standard_Error, Acc_Array (Cnt), 1);
            Text_Io.Put (Standard_Error, ']');
            Text_Io.New_Line (Standard_Error);
         end if;
      end loop;

      -- add entry for "jam" state
      Misc.Mkdata (Acc_Array (Lastdfa + 1));

      Misc.Dataend;

      if (Useecs) then
         Genecs;
      end if;

      if (Usemecs) then

         -- write out meta-equivalence classes (used to index templates with)
         if (Trace) then
            Text_Io.New_Line (Standard_Error);
            Text_Io.New_Line (Standard_Error);
            Text_Io.Put_Line (Standard_Error, "Meta-Equivalence Classes:");
         end if;

         Text_Io.Put ("      yy_meta : constant array (0 .. ");
         Int_Io.Put (Numecs, 1);
         Text_Io.Put_Line (") of Short :=");
         Text_Io.Put_Line ("          (0,");
         for Cnt in 1 .. Numecs loop
            if (Trace) then
               Int_Io.Put (Standard_Error, Cnt, 1);
               Text_Io.Put (Standard_Error, " = ");
               Int_Io.Put (Standard_Error, abs (Tecbck (Cnt)), 1);
               Text_Io.New_Line (Standard_Error);
            end if;
            Misc.Mkdata (abs (Tecbck (Cnt)));
         end loop;

         Misc.Dataend;
      end if;

      Total_States := Lastdfa + Numtemps;

      Text_Io.Put ("      yy_base : constant array (0 .. ");
      Int_Io.Put (Total_States, 1);
      if Tblend > Max_Short then
         Text_Io.Put_Line (") of Integer :=");
      else
         Text_Io.Put_Line (") of Short :=");
      end if;
      Text_Io.Put_Line ("          (0,");

      for Cnt in 1 .. Lastdfa loop
         declare
            D : constant Integer := Def (Cnt);
         begin
            if Base (Cnt) = Jamstate_Const then
               Base (Cnt) := Jambase;
            end if;

            if D = Jamstate_Const then
               Def (Cnt) := Jamstate;
            else
               if D < 0 then

                  -- template reference
                  Tmpuses   := Tmpuses + 1;
                  Def (Cnt) := Lastdfa - D + 1;
               end if;
            end if;
            Misc.Mkdata (Base (Cnt));
         end;
      end loop;

      -- generate jam state's base index
      I := Lastdfa + 1;
      Misc.Mkdata (Base (I));

      -- skip jam state
      I := I + 1;

      for Cnt in I .. Total_States loop
         Misc.Mkdata (Base (Cnt));
         Def (Cnt) := Jamstate;
      end loop;

      Misc.Dataend;

      Text_Io.Put ("      yy_def : constant array (0 .. ");
      Int_Io.Put (Total_States, 1);
      if Tblend > Max_Short then
         Text_Io.Put_Line (") of Integer :=");
      else
         Text_Io.Put_Line (") of Short :=");
      end if;
      Text_Io.Put_Line ("          (0,");

      for Cnt in 1 .. Total_States loop
         Misc.Mkdata (Def (Cnt));
      end loop;

      Misc.Dataend;
      Text_Io.Put ("      yy_nxt : constant array (0 .. ");
      Int_Io.Put (Tblend, 1);
      if Lastdfa > Max_Short then
         Text_Io.Put_Line (") of Integer :=");
      else
         Text_Io.Put_Line (") of Short :=");
      end if;
      Text_Io.Put_Line ("          (0,");

      for Cnt in 1 .. Tblend loop
         if ((Nxt (Cnt) = 0) or (Chk (Cnt) = 0)) then
            Nxt (Cnt) := Jamstate;

            -- new state is the JAM state
         end if;
         Misc.Mkdata (Nxt (Cnt));
      end loop;

      Misc.Dataend;

      Text_Io.Put ("      yy_chk : constant array (0 .. ");
      Int_Io.Put (Tblend, 1);
      if Lastdfa > Max_Short then
         Text_Io.Put_Line (") of Integer :=");
      else
         Text_Io.Put_Line (") of Short :=");
      end if;
      Text_Io.Put_Line ("          (0,");

      for Cnt in 1 .. Tblend loop
         if Chk (Cnt) = 0 then
            Nummt := Nummt + 1;
         end if;

         Misc.Mkdata (Chk (Cnt));
      end loop;

      Misc.Dataend;

   exception
      when Storage_Error =>
         Misc.Aflexfatal ("dynamic memory failure in gentabs()");
   end Gentabs;

   -- write out a string at the current indentation level, adding a final
   -- newline

   procedure Indent_Puts (Str : in String) is
   begin
      Do_Indent;
      Text_Io.Put_Line (Str);
   end Indent_Puts;

   -- do_sect3_out - dumps section 3.

   procedure Do_Sect3_Out is
      Garbage : Token;
      pragma Unreferenced (Garbage);
   begin
      Scanner.Call_Yylex := True;
      Garbage            := Scanner.Get_Token;
   end Do_Sect3_Out;

   -- make_tables - generate transition tables
   --
   --
   -- Generates transition tables and finishes generating output file

   procedure Make_Tables is
      Did_Eof_Rule : Boolean := False;
      -- TRANS_OFFSET_TYPE : STRING(1 .. 7);
      -- TOTAL_TABLE_SIZE  : INTEGER := TBLEND + NUMECS + 1;
      Buf : Vstring;
   begin
      if not Fulltbl then

         -- if we used full tables this is already output
         Do_Sect3_Out;

         -- intent of this call is to get everything up to ##
         Skeleton_Manager.Skelout;

         -- output YYLex code up to part about tables.
      end if;

      Text_Io.Put ("      YY_END_OF_BUFFER : constant := ");
      Int_Io.Put (Num_Rules + 1, 1);
      Text_Io.Put_Line (";");

      -- now output the constants for the various start conditions
      Reset (Def_File, In_File);

      while (not Text_Io.End_Of_File (Def_File)) loop
         Tstring.Get_Line (Def_File, Buf);
         Tstring.Put_Line ("      " & Buf);
      end loop;

      if (Fulltbl) then
         Genftbl;
      else
         Gentabs;
      end if;

      Reset (Temp_Action_File, In_File);

      -- generate code for yy_get_previous_state
      -- SET_INDENT(3);
      Skeleton_Manager.Skelout;

      Indent_Up;
      Indent_Up;
      if (Bol_Needed) then
         Indent_Up;
         Indent_Puts ("yy_bp : constant Integer := yytext_ptr;");
         Indent_Down;
      end if;
      Skeleton_Manager.Skelout;

      Indent_Up;
      Gen_Start_State;
      Skeleton_Manager.Skelout;
      Gen_Next_State;
      Skeleton_Manager.Skelout;

      --  SET_INDENT(4);

      Indent_Puts ("yy_bp := yy_cp;");

      Gen_Start_State;
      Gen_Next_Match;

      Skeleton_Manager.Skelout;

      -- SET_INDENT(3);
      Gen_Find_Action;

      -- SET_INDENT(1);
      Indent_Down;
      Skeleton_Manager.Skelout;

      Indent_Up;
      Gen_Bt_Action;

      Misc.Action_Out;
      Misc.Action_Out;

      -- generate cases for any missing EOF rules
      for I in 1 .. Lastsc loop
         if not Sceof (I) then
            Do_Indent;
            if not Did_Eof_Rule then
               Text_Io.Put ("         when ");
            else
               Text_Io.Put_Line ("|");
               Text_Io.Put ("              ");
            end if;
            Text_Io.Put ("YY_END_OF_BUFFER + ");
            Tstring.Put (Scname (I));
            Text_Io.Put (" + 1 ");
            Did_Eof_Rule := True;
         end if;
      end loop;
      if Did_Eof_Rule then
         Text_Io.Put_Line ("=>");
      end if;

      if Did_Eof_Rule then
         Indent_Up;
         Indent_Puts ("         return End_Of_Input;");
         Indent_Down;
      end if;

      Skeleton_Manager.Skelout;

      -- copy remainder of input to output
      Misc.Line_Directive_Out;
      Do_Sect3_Out;

      -- copy remainder of input, after ##, to the scanner file.
   end Make_Tables;

end Gen;
