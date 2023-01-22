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

-- TITLE main body
-- AUTHOR: John Self (UCI)
-- DESCRIPTION driver routines for aflex.  Calls drivers for all
-- high level routines from other packages.
-- $Header: /dc/uc/self/arcadia/aflex/ada/src/RCS/mainB.a,v 1.26 1992/12/29 22:46:15 self Exp self $

with Misc_Defs, Misc, Command_Line_Interface, Ecs, Text_Io, Parser;
with Main_Body, Tstring, Parse_Tokens, Skeleton_Manager, External_File_Manager;
with Template_Manager;
with Int_Io;
use Misc_Defs, Command_Line_Interface, Tstring, Text_Io;

package body Main_Body is

   Aflex_Version      : constant String := "1.6";
   Starttime, Endtime : Vstring;

   -- aflexend - terminate aflex
   --
   -- note
   --    This routine does not return.

   procedure Aflexend (Status : in Integer) is
      Tblsiz : Integer;
   begin
      Termination_Status := Status;

      Template_Manager.Cleanup;

      -- we'll return this value of the OS.
      if Is_Open (Skelfile) then
         Close (Skelfile);
      end if;

      if Is_Open (Temp_Action_File) then
         Delete (Temp_Action_File);
      end if;

      if Is_Open (Def_File) then
         Delete (Def_File);
      end if;

      if Backtrack_Report then
         if Num_Backtracking = 0 then
            Text_Io.Put_Line (Backtrack_File, "No backtracking.");
         else
            if Fulltbl then
               Int_Io.Put (Backtrack_File, Num_Backtracking, 0);
               Text_Io.Put_Line
                 (Backtrack_File, " backtracking (non-accepting) states.");
            else
               Text_Io.Put_Line
                 (Backtrack_File, "Compressed tables always backtrack.");
            end if;
         end if;

         Close (Backtrack_File);
      end if;

      if Printstats then
         Endtime := Misc.Aflex_Gettime;

         Text_Io.Put_Line
           (Standard_Error,
            "aflex version " & Aflex_Version & " usage statistics:");

         Tstring.Put_Line
           (Standard_Error,
            "  started at " & Starttime & ", finished at " & Endtime);
         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Lastnfa, 0);
         Text_Io.Put (Standard_Error, '/');
         Int_Io.Put (Standard_Error, Current_Mns, 0);
         Text_Io.Put_Line (Standard_Error, "  NFA states");

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Lastdfa, 0);
         Text_Io.Put (Standard_Error, '/');
         Int_Io.Put (Standard_Error, Current_Max_Dfas, 0);
         Text_Io.Put (Standard_Error, " DFA states (");
         Int_Io.Put (Standard_Error, Totnst, 0);
         Text_Io.Put (Standard_Error, "  words)");

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Num_Rules - 1, 0);

         -- - 1 for def. rule
         Text_Io.Put_Line (Standard_Error, "  rules");

         if (Num_Backtracking = 0) then
            Text_Io.Put_Line (Standard_Error, "  No backtracking");
         else
            if Fulltbl then
               Text_Io.Put (Standard_Error, "  ");
               Int_Io.Put (Standard_Error, Num_Backtracking, 0);
               Text_Io.Put_Line
                 (Standard_Error, "  backtracking (non-accepting) states");
            else
               Text_Io.Put_Line
                 (Standard_Error, " compressed tables always backtrack");
            end if;
         end if;

         if Bol_Needed then
            Text_Io.Put_Line
              (Standard_Error, "  Beginning-of-line patterns used");
         end if;

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Lastsc, 0);
         Text_Io.Put (Standard_Error, '/');
         Int_Io.Put (Standard_Error, Current_Max_Scs, 0);
         Text_Io.Put_Line (Standard_Error, " start conditions");

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Numeps, 0);
         Text_Io.Put (Standard_Error, " epsilon states, ");
         Int_Io.Put (Standard_Error, Eps2, 0);
         Text_Io.Put_Line (Standard_Error, "  double epsilon states");

         if Lastccl = 0 then
            Text_Io.Put_Line (Standard_Error, "  no character classes");
         else
            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Lastccl, 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Current_Maxccls, 0);
            Text_Io.Put (Standard_Error, " character classes needed ");
            Int_Io.Put
              (Standard_Error, Cclmap (Lastccl) + Ccllen (Lastccl), 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Current_Max_Ccl_Tbl_Size, 0);
            Text_Io.Put (Standard_Error, " words of storage, ");
            Int_Io.Put (Standard_Error, Cclreuse, 0);
            Text_Io.Put_Line (Standard_Error, " reused");
         end if;

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Numsnpairs, 0);
         Text_Io.Put_Line (Standard_Error, " state/nextstate pairs created");

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Numuniq, 0);
         Text_Io.Put (Standard_Error, '/');
         Int_Io.Put (Standard_Error, Numdup, 0);
         Text_Io.Put_Line (Standard_Error, " unique/duplicate transitions");

         if (Fulltbl) then
            Tblsiz := Lastdfa * Numecs;
            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Tblsiz, 0);
            Text_Io.Put_Line (Standard_Error, " table entries");
         else
            Tblsiz := 2 * (Lastdfa + Numtemps) + 2 * Tblend;

            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Lastdfa + Numtemps, 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Current_Max_Dfas, 0);
            Text_Io.Put_Line (Standard_Error, " base-def entries created");

            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Tblend, 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Current_Max_Xpairs, 0);
            Text_Io.Put (Standard_Error, " (peak ");
            Int_Io.Put (Standard_Error, Peakpairs, 0);
            Text_Io.Put_Line (Standard_Error, ") nxt-chk entries created");

            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Numtemps * Nummecs, 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Current_Max_Template_Xpairs, 0);
            Text_Io.Put (Standard_Error, " (peak ");
            Int_Io.Put (Standard_Error, Numtemps * Numecs, 0);
            Text_Io.Put_Line
              (Standard_Error, ") template nxt-chk entries created");

            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Nummt, 0);
            Text_Io.Put_Line (Standard_Error, " empty table entries");
            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Numprots, 0);
            Text_Io.Put_Line (Standard_Error, " protos created");
            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Numtemps, 0);
            Text_Io.Put (Standard_Error, " templates created, ");
            Int_Io.Put (Standard_Error, Tmpuses, 0);
            Text_Io.Put_Line (Standard_Error, "uses");
         end if;

         if (Useecs) then
            Tblsiz := Tblsiz + Csize;
            Text_Io.Put_Line (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Numecs, 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Csize, 0);
            Text_Io.Put_Line (Standard_Error, " equivalence classes created");
         end if;

         if (Usemecs) then
            Tblsiz := Tblsiz + Numecs;
            Text_Io.Put (Standard_Error, "  ");
            Int_Io.Put (Standard_Error, Nummecs, 0);
            Text_Io.Put (Standard_Error, '/');
            Int_Io.Put (Standard_Error, Csize, 0);
            Text_Io.Put_Line
              (Standard_Error, " meta-equivalence classes created");
         end if;

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Hshcol, 0);
         Text_Io.Put (Standard_Error, " (");
         Int_Io.Put (Standard_Error, Hshsave, 0);
         Text_Io.Put_Line (Standard_Error, " saved) hash collisions, ");
         Int_Io.Put (Standard_Error, Dfaeql, 0);
         Text_Io.Put_Line (Standard_Error, " DFAs equal");

         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Num_Reallocs, 0);
         Text_Io.Put_Line (Standard_Error, " sets of reallocations needed");
         Text_Io.Put (Standard_Error, "  ");
         Int_Io.Put (Standard_Error, Tblsiz, 0);
         Text_Io.Put_Line (Standard_Error, " total table entries needed");
      end if;

      if Status /= 0 then
         raise Aflex_Terminate;
      end if;
   end Aflexend;

   --  Print aflex usage.
   procedure Usage is
   begin
      Put_Line (Standard_Error, "aflex version 1.6");
      Put_Line (Standard_Error, "");
      Put_Line
        (Standard_Error,
         "Usage: aflex [-bdfimpstvEILT] [-Sskeleton] [filename]");
      Put_Line
        (Standard_Error, "-b         Generate backtracking information");
      Put_Line
        (Standard_Error, "-d         Generate the scanner with debug mode");
      Put_Line
        (Standard_Error, "-f         Don't compress the scanner tables");
      Put_Line
        (Standard_Error, "-i         Generate case-insensitive scanner");
      Put_Line
        (Standard_Error,
         "-m         Minimalist with clauses (do not emit a with Text_IO)");
      Put_Line
        (Standard_Error,
         "-p         Generate performance report on standard error");
      Put_Line
        (Standard_Error,
         "-s         Suppress the default rule to ECHO unmached text");
      Put_Line
        (Standard_Error,
         "-t         Write the scanner output on standard output");
      Put_Line
        (Standard_Error, "-v         Write summary of scanner statistics");
      Put_Line
        (Standard_Error,
         "-E         Generate additional information about tokens for ayacc");
      Put_Line
        (Standard_Error,
         "-P         Generate private Ada package for the scanner");
      Put_Line (Standard_Error, "-I         Generate an interactive scanner");
      Put_Line (Standard_Error, "-L         Do not generate #line directives");
      Put_Line (Standard_Error, "-R         Generate a reentrant scanner");
      Put_Line (Standard_Error, "-T         Run in trace mode");
      Put_Line (Standard_Error, "-Sskeleton Specify the skeleton file");
   end Usage;

   -- aflexinit - initialize aflex

   procedure Aflexinit is
      Use_Stdout    : Boolean;
      Output_File   : File_Type;
      Input_File    : File_Type;
      Arg_Cnt       : Integer;
      Flag_Pos      : Integer;
      Arg           : Vstring;
      Skelname      : Vstring;
      Skelname_Used : Boolean := False;
   begin
      Printstats         := False;
      Syntaxerror        := False;
      Trace              := False;
      Spprdflt           := False;
      Interactive        := False;
      Caseins            := False;
      Backtrack_Report   := False;
      Performance_Report := False;
      Ddebug             := False;
      Fulltbl            := False;
      Continued_Action   := False;
      Gen_Line_Dirs      := True;
      Usemecs            := True;
      Useecs             := True;
      Use_Yylineno       := False;
      Private_Package    := False;
      Reentrant          := False;

      Use_Stdout := False;

      -- read flags
      Command_Line_Interface.Initialize_Command_Line;

      -- load up argv
      External_File_Manager.Initialize_Files;

      -- do external files setup

      -- loop through the list of arguments
      Arg_Cnt := 1;
      while Arg_Cnt <= Argc - 1 loop
         if Char (Argv (Arg_Cnt), 1) /= '-' or Len (Argv (Arg_Cnt)) < 2 then
            exit;
         end if;

         -- loop through the flags in this argument.
         Arg      := Argv (Arg_Cnt);
         Flag_Pos := 2;
         while Flag_Pos <= Len (Arg) loop
            case Char (Arg, Flag_Pos) is
               when 'b' =>
                  Backtrack_Report := True;
               when 'd' =>
                  Ddebug := True;
               when 'f' =>
                  Useecs  := False;
                  Usemecs := False;
                  Fulltbl := True;
               when 'I' =>
                  Interactive := True;
               when 'i' =>
                  Caseins := True;
               when 'm' =>
                  Minimalist_With := True;
               when 'L' =>
                  Gen_Line_Dirs := False;
               when 'p' =>
                  Performance_Report := True;
               when 'S' =>
                  if (Flag_Pos /= 2) then
                     Misc.Aflexerror ("-S flag must be given separately");
                  end if;
                  Skelname      := Slice (Arg, Flag_Pos + 1, Len (Arg));
                  Skelname_Used := True;
                  goto Get_Next_Arg;
               when 's' =>
                  Spprdflt := True;
               when 't' =>
                  Use_Stdout := True;
               when 'P' =>
                  Private_Package := True;
               when 'R' =>
                  Reentrant := True;
               when 'T' =>
                  Trace := True;
               when 'v' =>
                  Printstats := True;
-- UMASS CODES :
--    Added an flag to indicate whether or not the aflex generated
--    codes will be used by Ayacc extension. Ayacc extension has
--    more power in error recovery.
               when 'E' =>
                  Ayacc_Extension_Flag := True;
-- END OF UMASS CODES.
               when others =>
                  Usage;
                  Misc.Aflexerror ("unknown flag " & Char (Arg, Flag_Pos));
            end case;
            Flag_Pos := Flag_Pos + 1;
         end loop;
         <<Get_Next_Arg>>
         Arg_Cnt := Arg_Cnt + 1;

         -- go on to next argument from list.
      end loop;

      if Fulltbl and Usemecs then
         Misc.Aflexerror ("full table and -cm don't make sense together");
      end if;

      if Fulltbl and Interactive then
         Misc.Aflexerror ("full table and -I are (currently) incompatible");
      end if;

      --initialize the statistics
      Starttime := Misc.Aflex_Gettime;

      if Arg_Cnt < Argc then
         begin
            if Argc - Arg_Cnt > 1 then
               Misc.Aflexerror ("extraneous argument(s) given");
            end if;

            -- Tell aflex where to read input from.
            Infilename := Argv (Arg_Cnt);

            Misc.Set_Filename (Infilename);
            Open (Input_File, In_File, Str (Argv (Arg_Cnt)));
            Set_Input (Input_File);

            --CvdL: first result is junk, get another one here (optimizer!)
            Starttime := Misc.Aflex_Gettime;

         exception
            when Name_Error =>
               Misc.Aflexfatal ("can't open " & Infilename);
         end;
      end if;

      if not Use_Stdout then
         External_File_Manager.Get_Scanner_File (Output_File, False);
      end if;

      if Backtrack_Report then
         External_File_Manager.Get_Backtrack_File (Backtrack_File);
      end if;

      Lastccl := 0;
      Lastsc  := 0;

      begin

         -- open the skeleton file
         if Skelname_Used then
            Open (Skelfile, In_File, Str (Skelname));
            Skeleton_Manager.Set_External_Skeleton;
         end if;
      exception
         when Use_Error | Name_Error =>
            Misc.Aflexfatal ("couldn't open skeleton file " & Skelname);
      end;

      -- without a third argument create make an anonymous temp file.
      begin
         Template_Manager.Cleanup;
         Create (Temp_Action_File, Out_File, "tmpact.miq");
         Create (Def_File, Out_File, "deffile.miq");
      exception
         when Use_Error | Name_Error =>
            Misc.Aflexfatal ("can't create temporary file");
      end;

      Lastdfa                         := 0;
      Lastnfa                         := 0;
      Num_Rules                       := 0;
      Numas                           := 0;
      Numsnpairs                      := 0;
      Tmpuses                         := 0;
      Numecs                          := 0;
      Numeps                          := 0;
      Eps2                            := 0;
      Num_Reallocs                    := 0;
      Hshcol                          := 0;
      Dfaeql                          := 0;
      Totnst                          := 0;
      Numuniq                         := 0;
      Numdup                          := 0;
      Hshsave                         := 0;
      Eofseen                         := False;
      Datapos                         := 0;
      Dataline                        := 0;
      Num_Backtracking                := 0;
      Onesp                           := 0;
      Numprots                        := 0;
      Variable_Trailing_Context_Rules := False;
      Bol_Needed                      := False;

      Linenum   := 1;
      Sectnum   := 1;
      Firstprot := Nil;

      -- used in mkprot() so that the first proto goes in slot 1
      -- of the proto queue

      Lastprot := 1;

      if Useecs then
         -- set up doubly-linked equivalence classes
         Ecgroup (1) := Nil;

         for Cnt in 2 .. Csize loop
            Ecgroup (Cnt)     := Cnt - 1;
            Nextecm (Cnt - 1) := Cnt;
         end loop;

         Nextecm (Csize) := Nil;
      else
         -- put everything in its own equivalence class
         for Cnt in 1 .. Csize loop
            Ecgroup (Cnt) := Cnt;
            Nextecm (Cnt) := Bad_Subscript;  -- to catch errors
         end loop;
      end if;

      Set_Up_Initial_Allocations;

   end Aflexinit;

   -- readin - read in the rules section of the input file(s)
   procedure Readin is
   begin
      Skeleton_Manager.Skelout;
      if not Minimalist_With then
         Text_Io.Put ("with " & Misc.Package_Name & "_DFA" & "; ");
         Text_Io.Put_Line ("use " & Misc.Package_Name & "_DFA" & ";");
         Text_Io.Put ("with " & Misc.Package_Name & "_IO" & "; ");
         Text_Io.Put_Line ("use " & Misc.Package_Name & "_IO" & ";");
      end if;
      Misc.Line_Directive_Out;

      Parser.Yyparse;

      if (Useecs) then
         Ecs.Cre8ecs (Nextecm, Ecgroup, Csize, Numecs);
         Ecs.Ccl2ecl;
      else
         Numecs := Csize;
      end if;
   exception
      when Parse_Tokens.Syntax_Error =>
         Misc.Aflexerror
           ("fatal parse error at line " & Integer'Image (Linenum));
         Main_Body.Aflexend (1);
   end Readin;

   -- set_up_initial_allocations - allocate memory for internal tables
   procedure Set_Up_Initial_Allocations is
   begin
      Current_Mns := Initial_Mns;
      Firstst     := Allocate_Integer_Array (Current_Mns);
      Lastst      := Allocate_Integer_Array (Current_Mns);
      Finalst     := Allocate_Integer_Array (Current_Mns);
      Transchar   := Allocate_Integer_Array (Current_Mns);
      Trans1      := Allocate_Integer_Array (Current_Mns);
      Trans2      := Allocate_Integer_Array (Current_Mns);
      Accptnum    := Allocate_Integer_Array (Current_Mns);
      Assoc_Rule  := Allocate_Integer_Array (Current_Mns);
      State_Type  := Allocate_State_Enum_Array (Current_Mns);

      Current_Max_Rules := Initial_Max_Rules;
      Rule_Type         := Allocate_Rule_Enum_Array (Current_Max_Rules);
      Rule_Linenum      := Allocate_Integer_Array (Current_Max_Rules);

      Current_Max_Scs := Initial_Max_Scs;
      Scset           := Allocate_Integer_Array (Current_Max_Scs);
      Scbol           := Allocate_Integer_Array (Current_Max_Scs);
      Scxclu          := Allocate_Boolean_Array (Current_Max_Scs);
      Sceof           := Allocate_Boolean_Array (Current_Max_Scs);
      Scname          := Allocate_Vstring_Array (Current_Max_Scs);
      Actvsc          := Allocate_Integer_Array (Current_Max_Scs);

      Current_Maxccls := Initial_Max_Ccls;
      Cclmap          := Allocate_Integer_Array (Current_Maxccls);
      Ccllen          := Allocate_Integer_Array (Current_Maxccls);
      Cclng           := Allocate_Integer_Array (Current_Maxccls);

      Current_Max_Ccl_Tbl_Size := Initial_Max_Ccl_Tbl_Size;
      Ccltbl := Allocate_Character_Array (Current_Max_Ccl_Tbl_Size);

      Current_Max_Dfa_Size := Initial_Max_Dfa_Size;

      Current_Max_Xpairs := Initial_Max_Xpairs;
      Nxt                := Allocate_Integer_Array (Current_Max_Xpairs);
      Chk                := Allocate_Integer_Array (Current_Max_Xpairs);

      Current_Max_Template_Xpairs := Initial_Max_Template_Xpairs;
      Tnxt := Allocate_Integer_Array (Current_Max_Template_Xpairs);

      Current_Max_Dfas := Initial_Max_Dfas;
      Base             := Allocate_Integer_Array (Current_Max_Dfas);
      Def              := Allocate_Integer_Array (Current_Max_Dfas);
      Dfasiz           := Allocate_Integer_Array (Current_Max_Dfas);
      Accsiz           := Allocate_Integer_Array (Current_Max_Dfas);
      Dhash            := Allocate_Integer_Array (Current_Max_Dfas);
      Dss              := Allocate_Int_Ptr_Array (Current_Max_Dfas);
      Dfaacc           := Allocate_Dfaacc_Union (Current_Max_Dfas);
   end Set_Up_Initial_Allocations;
end Main_Body;
