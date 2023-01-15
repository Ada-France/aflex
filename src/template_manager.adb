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
with Misc_Defs, Text_Io, External_File_Manager, Misc;
use Misc_Defs, Text_Io;
with Template_Manager.Templates;
package body Template_Manager is

   Dfa_Current_Line : Integer := 1;

   Io_Current_Line : Integer := 1;

   procedure Write_Template (Outfile     : in File_Type;
                             Lines       : in Templates.Content_Array;
                             Line_Number : in out Integer;
                             Pkg_Name    : in String) is
      type Section_Type is (S_COMMON,
                            S_IF_DEBUG,
                            S_IF_OUTPUT,
                            S_IF_ERROR,
                            S_IF_PRIVATE,
                            S_IF_INTERACTIVE,
                            S_IF_YYLINENO,
                            S_IF_YYWRAP,
                            S_IF_UNPUT);
      Current    : Section_Type := S_COMMON;
      Is_Visible : Boolean := True;
      Invert     : Boolean := False;
   begin
      for Line of Lines loop
         if Line'Length = 0 then
            if Is_Visible then
               Text_IO.New_Line (Outfile);
            end if;
         elsif Line (Line'First) = '%' then
            if Line.all = "%if output" then
               Current := S_IF_OUTPUT;
            elsif Line.all = "%if yylineno" then
               Current := S_IF_YYLINENO;
            elsif Line.all = "%if unput" then
               Current := S_IF_UNPUT;
            elsif Line.all = "%if debug" then
               Current := S_IF_DEBUG;
            elsif Line.all = "%if error" then
               Current := S_IF_ERROR;
            elsif Line.all = "%if private" then
               Current := S_IF_PRIVATE;
            elsif Line.all = "%if interactive" then
               Current := S_IF_INTERACTIVE;
            elsif Line.all = "%if yywrap" then
               Current := S_IF_YYWRAP;
            elsif Line.all = "%end" then
               Current := S_COMMON;
               Invert := False;
            elsif Line.all = "%else" then
               Invert := True;
            else
               --  Very crude error report when the template % line is invalid.
               --  This could happen only during development when templates
               --  are modified.
               raise Program_Error with "Invalid template '%' rule: " & Line.all;
            end if;
            Is_Visible := (Current = S_COMMON)
              or else (Current = S_IF_YYLINENO and then YYLineno)
              or else (Current = S_IF_DEBUG and then Ddebug)
              or else (Current = S_IF_INTERACTIVE and then Interactive)
              or else (Current = S_IF_PRIVATE and then Private_Package)
              or else (Current = S_IF_UNPUT and then not No_Unput)
              or else (Current = S_IF_OUTPUT and then not No_Output)
              or else (Current = S_IF_YYWRAP and then not No_YYWrap)
              or else (Current = S_IF_ERROR and then Ayacc_Extension_Flag);
            if Invert then
               Is_Visible := not Is_Visible;
            end if;

         elsif Is_Visible then
            Line_Number := Line_Number + 1;
            declare
               Start : Natural := Line'First;
               Pos   : Natural;
            begin
               while Start <= Line'Last loop
                  Pos := Ada.Strings.Fixed.Index (Line.all, "${NAME}", Start);
                  if Pos = 0 then
                     Text_IO.Put_Line (Outfile, Line (Start .. Line'Last));
                     exit;
                  else
                     Text_IO.Put (Outfile, Line (Start .. Pos - 1));
                     Text_IO.Put (Outfile, Misc.Package_Name);
                     Start := Pos + 7;
                     --  Text_IO.Put_Line (Outfile, Line (Pos .. Line'Last));
                  end if;
               end loop;
            end;
         end if;
      end loop;
   end Write_Template;

   procedure Generate_Dfa_File is
      Dfa_Out_File : File_Type;
   begin
      External_File_Manager.Get_Dfa_File (Dfa_Out_File, True);
      Write_Template (Dfa_Out_File, Templates.spec_dfa, Dfa_Current_Line,
                      Misc.Package_Name & "_DFA");
      Text_Io.Close (Dfa_Out_File);

      External_File_Manager.Get_Dfa_File (Dfa_Out_File, False);
      Text_Io.New_Line (Dfa_Out_File);
      --  Text_Io.Put (Dfa_Out_File, "with " & Misc.Package_Name & "_DFA" & "; ");
      --  Text_Io.Put_Line (Dfa_Out_File, "use " & Misc.Package_Name & "_DFA;");
      Write_Template (Dfa_Out_File, Templates.body_dfa, Dfa_Current_Line,
                      Misc.Package_Name & "_DFA");
   end Generate_Dfa_File;

   procedure Generate_Io_File is
      Io_Out_File : File_Type;
   begin
      External_File_Manager.Get_Io_File (Io_Out_File, True);
      --  Text_Io.Put (Io_Out_File, "with " & Misc.Package_Name & "_DFA; ");
      --  Text_Io.Put_Line (Io_Out_File, "use " & Misc.Package_Name & "_DFA;");
      Write_Template (Io_Out_File, Templates.spec_io, Io_Current_Line,
                      Misc.Package_Name & "_IO");
      Text_Io.Close (Io_Out_File);

      External_File_Manager.Get_Io_File (Io_Out_File, False);
      Write_Template (Io_Out_File, Templates.body_io, Io_Current_Line,
                      Misc.Package_Name & "_IO");
   end Generate_Io_File;

end Template_Manager;
