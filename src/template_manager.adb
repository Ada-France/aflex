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

-- TITLE template manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION supports output of internalized templates for the IO and DFA
--             packages.
-- NOTES This package is quite a memory hog, and is really only useful on
--       virtual memory systems.  It could use an external file to store the
--       templates like the skeleton manager.  This would save memory at the
--       cost of a slight reduction in speed and the necessity of keeping
--       copies of the template files in a known place.
-- $Header: /dc/uc/self/arcadia/aflex/ada/src/RCS/template_managerB.a,v 1.21 1992/12/29 22:46:15 self Exp self $

--  6-Aug-2008 GdM : Added Input_Line
-- 26-Dec-2006 GdM : Added Output_Column and Output_New_Line

with Ada.Strings.Fixed;
with Ada.Directories;
with Misc_Defs, External_File_Manager, Misc;
with Template_Manager.Templates;
package body Template_Manager is

   use Misc_Defs;
   use Ada;
   use Ada.Text_IO;

   Has_Code : array (Code_Filename) of Boolean := (others => False);

   YYTYPE_CODE_FILENAME   : constant String := "yytype.miq";
   YYINIT_CODE_FILENAME   : constant String := "yyinit.miq";
   YYACTION_CODE_FILENAME : constant String := "yyaction.miq";
   YYWRAP_CODE_FILENAME   : constant String := "yywrap.miq";

   function Get_Filename (Code : in Code_Filename) return String is
   begin
      Has_Code (Code) := True;
      case Code is
         when YYTYPE_CODE =>
            return YYTYPE_CODE_FILENAME;

         when YYINIT_CODE =>
            return YYINIT_CODE_FILENAME;

         when YYACTION_CODE =>
            return YYACTION_CODE_FILENAME;

         when YYWRAP_CODE =>
            return YYWRAP_CODE_FILENAME;

      end case;
   end Get_Filename;

   procedure Include_File (Outfile : in File_Type;
                           Filename : in String) is
      Input : File_Type;
   begin
      if not Ada.Directories.Exists (Filename) then
         return;
      end if;
      Open (Input, Ada.Text_IO.In_File, Filename);
      while not End_Of_File (Input) loop
         Put_Line (Outfile, Get_Line (Input));
      end loop;
      Close (Input);
   end Include_File;

   procedure Write_Line (Outfile : in File_Type;
                         Line    : in String) is
      Start : Natural := Line'First;
      Pos   : Natural;
   begin
      while Start <= Line'Last loop
         Pos := Ada.Strings.Fixed.Index (Line, "${", Start);
         if Pos = 0 then
            Text_IO.Put_Line (Outfile, Line (Start .. Line'Last));
            exit;
         elsif Line (Pos .. Pos + 7) = "${YYLEX}" then
            declare
               Name : constant String := Misc.Get_YYLex_Name;
            begin
               Text_IO.Put (Outfile, Line (Start .. Pos - 1));
               if Name'Length > 0 then
                  Text_IO.Put (Outfile, Name);
               else
                  Text_IO.Put (Outfile, "YYLex");
               end if;
               Start := Pos + 8;

            end;

         elsif Line (Pos .. Pos + 6) = "${NAME}" then
            Text_IO.Put (Outfile, Line (Start .. Pos - 1));
            Text_IO.Put (Outfile, Misc.Package_Name);
            Start := Pos + 7;

         elsif Line (Pos .. Pos + 7) = "${YYVAR}" then
            Text_IO.Put (Outfile, Line (Start .. Pos - 1));
            Text_IO.Put (Outfile, Misc.Get_YYVar_Name);
            Start := Pos + 8;

         elsif Line (Pos .. Pos + 11) = "${YYBUFSIZE}" then
            declare
               Bufsize : constant String := Natural'Image (Misc_Defs.YYBuf_Size);
            begin
               Text_IO.Put (Outfile, Line (Start .. Pos - 1));
               Text_IO.Put (Outfile, Bufsize (Bufsize'First + 1 .. Bufsize'Last));
               Start := Pos + 12;
            end;
         else
            Text_IO.Put_Line (Outfile, Line (Start .. Line'Last));
            exit;
         end if;
         if Start > Line'Last then
            Text_IO.New_Line (Outfile);
         end if;
      end loop;
   end Write_Line;

   procedure Write_Indented (Outfile : in File_Type; Line : in String) is
      Start : constant Natural := Ada.Strings.Fixed.Index (Line, "(") + 1;
      Pos   : Natural := Line'First;
      Sep   : Natural;
   begin
      while Pos <= Line'Last loop
         Sep := Ada.Strings.Fixed.Index (Line, ";", Pos);
         if Sep > 0 then
            Text_IO.Put_Line (Outfile, Line (Pos .. Sep));
            Pos := Sep + 1;
            Text_IO.Set_Col (Outfile, Ada.Text_IO.Positive_Count (Start - Line'First));
         else
            Text_IO.Put_Line (Outfile, Line (Pos .. Line'Last));
            return;
         end if;
      end loop;
   end Write_Indented;

   procedure Template_Writer (Outfile  : in File_Type) is

      type Section_Type is (S_COMMON,
                            S_IF_DEBUG,
                            S_IF_OUTPUT,
                            S_IF_INPUT,
                            S_IF_ERROR,
                            S_IF_PRIVATE,
                            S_IF_ECHO,
                            S_IF_INTERACTIVE,
                            S_IF_YYLINENO,
                            S_IF_YYWRAP,
                            S_IF_YYWRAP_CODE,
                            S_IF_YYACTION,
                            S_IF_YYTYPE,
                            S_IF_REENTRANT,
                            S_IF_MINIMALIST_WITH,
                            S_IF_UNPUT);
      type Stack_Location is new Natural range 0 .. 10;
      type Stack_Condition is record
         Section  : Section_Type;
         Invert   : Boolean;
         Visible  : Boolean;
      end record;
      type Session_Stack is array (Stack_Location range 1 .. 10) of Stack_Condition;

      If_Stack   : Session_Stack;
      If_Pos     : Stack_Location := 0;
      Current    : Section_Type := S_COMMON;
      Is_Visible : Boolean := True;
      Parent_Visible : Boolean := True;
      Invert     : Boolean := False;
      Continue   : Boolean := True;

      procedure Push_Condition (Kind : Section_Type) is
      begin
         if If_Pos = Stack_Location'Last then
            raise Program_Error with "Template uses too many nested %if conditions";
         end if;
         If_Pos := If_Pos + 1;
         If_Stack (If_Pos) := (Current, Invert, Is_Visible);
         Current := Kind;
         Invert := False;
         Parent_Visible := Is_Visible;
      end Push_Condition;

      procedure Pop_Condition is
      begin
         if If_Pos = 0 then
            raise Program_Error with "Template contains an unmatched %end";
         end if;
         Current := If_Stack (If_Pos).Section;
         Invert := If_Stack (If_Pos).Invert;
         Parent_Visible := If_Stack (If_Pos).Visible;
         If_Pos := If_Pos - 1;
      end Pop_Condition;

   begin
      while Continue and then Has_Line loop
         declare
            Line : constant String := Get_Line;
         begin
            if Line'Length = 0 then
               if Is_Visible and Parent_Visible then
                  Text_IO.New_Line (Outfile);
               end if;
            elsif Line (Line'First) = '%' then
               if Line = "%if output" then
                  Push_Condition (S_IF_OUTPUT);
               elsif Line = "%if input" then
                  Push_Condition (S_IF_INPUT);
               elsif Line = "%if yylineno" then
                  Push_Condition (S_IF_YYLINENO);
               elsif Line = "%if unput" then
                  Push_Condition (S_IF_UNPUT);
               elsif Line = "%if debug" then
                  Push_Condition (S_IF_DEBUG);
               elsif Line = "%if error" then
                  Push_Condition (S_IF_ERROR);
               elsif Line = "%if private" then
                  Push_Condition (S_IF_PRIVATE);
               elsif Line = "%if interactive" then
                  Push_Condition (S_IF_INTERACTIVE);
               elsif Line = "%if yywrap" then
                  Push_Condition (S_IF_YYWRAP);
               elsif Line = "%if yywrapcode" then
                  Push_Condition (S_IF_YYWRAP_CODE);
               elsif Line = "%if yyaction" then
                  Push_Condition (S_IF_YYACTION);
               elsif Line = "%if yytype" then
                  Push_Condition (S_IF_YYTYPE);
               elsif Line = "%if echo" then
                  Push_Condition (S_IF_ECHO);
               elsif Line = "%if reentrant" then
                  Push_Condition (S_IF_REENTRANT);
               elsif Line = "%if minimalist" then
                  Push_Condition (S_IF_MINIMALIST_WITH);
               elsif Line = "%end" then
                  Pop_Condition;
               elsif Line = "%else" then
                  Invert := True;
               elsif Line = "%yydecl" then
                  if Is_Visible and Parent_Visible then
                     --  Special instruction to emil the function declaration
                     declare
                        Decl : constant String := Misc.Get_YYLex_Declaration;
                        Var  : constant String := Misc.Get_YYVar_Name;
                     begin
                        if Decl'Length > 0 then
                           Write_Indented (Outfile, Decl);
                        elsif not Reentrant then
                           Text_IO.Put_Line (Outfile, "   function YYLex return Token is");
                        else
                           Text_IO.Put (Outfile, "   function YYLex (");
                           Text_IO.Put (Outfile, Var);
                           Text_IO.Put_Line (Outfile, " : in out context_Type) is");
                        end if;
                     end;
                  end if;
               elsif Line = "%yytype" then
                  if Is_Visible and Parent_Visible then
                     Include_File (Outfile, YYTYPE_CODE_FILENAME);
                  end if;
               elsif Line = "%yyaction" then
                  if Is_Visible and Parent_Visible then
                     Include_File (Outfile, YYACTION_CODE_FILENAME);
                  end if;
               elsif Line = "%yywrap" then
                  if Is_Visible and Parent_Visible then
                     Include_File (Outfile, YYWRAP_CODE_FILENAME);
                  end if;
               elsif Line = "%yyinit" then
                  if Is_Visible and Parent_Visible then
                     Include_File (Outfile, YYINIT_CODE_FILENAME);
                  end if;
               elsif Line'Length > 3 and then Line (Line'First + 1) = '%' then
                  Continue := False;
                  return;
               else
                  --  Very crude error report when the template % line is invalid.
                  --  This could happen only during development when templates
                  --  are modified.
                  raise Program_Error with "Invalid template '%' rule: " & Line;
               end if;
               Is_Visible := (Current = S_COMMON)
                 or else (Current = S_IF_YYLINENO and then Use_YYLineno)
                 or else (Current = S_IF_DEBUG and then Ddebug)
                 or else (Current = S_IF_INTERACTIVE and then Interactive)
                 or else (Current = S_IF_PRIVATE and then Private_Package)
                 or else (Current = S_IF_UNPUT and then not No_Unput)
                 or else (Current = S_IF_OUTPUT and then not No_Output)
                 or else (Current = S_IF_INPUT and then not No_Input)
                 or else (Current = S_IF_YYWRAP and then not No_YYWrap)
                 or else (Current = S_IF_YYWRAP_CODE and then Has_Code (YYWRAP_CODE))
                 or else (Current = S_IF_YYACTION and then Has_Code (YYACTION_CODE))
                 or else (Current = S_IF_YYTYPE and then Has_Code (YYTYPE_CODE))
                 or else (Current = S_IF_REENTRANT and then Reentrant)
                 or else (Current = S_IF_ECHO and then not Spprdflt)
                 or else (Current = S_IF_MINIMALIST_WITH and then Minimalist_With)
                 or else (Current = S_IF_ERROR and then Ayacc_Extension_Flag);
               if Invert then
                  Is_Visible := not Is_Visible;
               end if;

            elsif Is_Visible and Parent_Visible then
               Write_Line (Outfile, Line);
            end if;
         end;
      end loop;
   end Template_Writer;

   procedure Write_Template (Outfile  : in File_Type;
                             Lines    : in Content_Array;
                             Position : in out Positive) is
      function Has_Line return Boolean is
      begin
         return Position <= Lines'Last;
      end Has_Line;

      function Get_Line return String is
      begin
         Position := Position + 1;
         return Lines (Position - 1).all;
      end Get_Line;

      procedure Write is new Template_Writer (Has_Line, Get_Line);

   begin
      Write (Outfile);
    end Write_Template;

   procedure Generate_Dfa_File is
      Dfa_Out_File : File_Type;
      Dfa_Line     : Positive := 1;
   begin
      External_File_Manager.Get_Dfa_File (Dfa_Out_File, True);
      Write_Template (Dfa_Out_File,
                      (if Reentrant then Templates.spec_reentrant_dfa else Templates.spec_dfa),
                      Dfa_Line);
      Text_Io.Close (Dfa_Out_File);

      External_File_Manager.Get_Dfa_File (Dfa_Out_File, False);
      Text_Io.New_Line (Dfa_Out_File);

      Dfa_Line := 1;
      Write_Template (Dfa_Out_File,
                      (if Reentrant then Templates.body_reentrant_dfa else Templates.body_dfa),
                      Dfa_Line);
   end Generate_Dfa_File;

   procedure Generate_Io_File is
      Io_Out_File : File_Type;
      IO_Line     : Positive := 1;
   begin
      External_File_Manager.Get_Io_File (Io_Out_File, True);

      Write_Template (Io_Out_File,
                      (if Reentrant then Templates.spec_reentrant_io else Templates.spec_io),
                      IO_Line);
      Text_Io.Close (Io_Out_File);

      External_File_Manager.Get_Io_File (Io_Out_File, False);
      IO_Line := 1;
      Write_Template (Io_Out_File,
                      (if Reentrant then Templates.body_reentrant_io else Templates.body_io),
                      IO_Line);
   end Generate_Io_File;

   procedure Cleanup is
   begin
      if Ada.Directories.Exists (YYTYPE_CODE_FILENAME) then
         Ada.Directories.Delete_File (YYTYPE_CODE_FILENAME);
      end if;
      if Ada.Directories.Exists (YYINIT_CODE_FILENAME) then
         Ada.Directories.Delete_File (YYINIT_CODE_FILENAME);
      end if;
      if Ada.Directories.Exists (YYACTION_CODE_FILENAME) then
         Ada.Directories.Delete_File (YYACTION_CODE_FILENAME);
      end if;
      if Ada.Directories.Exists (YYWRAP_CODE_FILENAME) then
         Ada.Directories.Delete_File (YYWRAP_CODE_FILENAME);
      end if;
   end Cleanup;

end Template_Manager;
