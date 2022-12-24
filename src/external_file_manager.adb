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

-- TITLE external_file_manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION opens external files for other functions
-- NOTES This package opens external files, and thus may be system dependent
--       because of limitations on file names.
--       This version is for the VADS 5.5 Ada development system.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/file_managerB.a,v 1.5 90/01/12 15:19:58 self Exp Locker: self $

with Misc_Defs, Tstring, Misc;
use Misc_Defs, Tstring;

package body External_File_Manager is

-- FIX comment about compiler dependent

   subtype Suffix_Type is String (1 .. 3);

   function Ada_Suffix (Spec : in Boolean) return Suffix_Type is
   begin
      if Spec then
         return "ads";
      else
         return "adb";
      end if;
   end Ada_Suffix;

   procedure Get_Io_File (F : in out File_Type; Spec : in Boolean) is
   begin
      if (Len (Infilename) /= 0) then
         Create
           (F, Out_File, Str (Misc.Basename) & "_io." & Ada_Suffix (Spec));
      else
         Create (F, Out_File, "aflex_yy_io." & Ada_Suffix (Spec));
      end if;
   exception
      when Use_Error | Name_Error =>
         Misc.Aflexfatal ("could not create IO package file");
   end Get_Io_File;

   procedure Get_Dfa_File (F : in out File_Type; Spec : in Boolean) is
   begin
      if (Len (Infilename) /= 0) then
         Create
           (F, Out_File, Str (Misc.Basename) & "_dfa." & Ada_Suffix (Spec));
      else
         Create (F, Out_File, "aflex_yy_dfa." & Ada_Suffix (Spec));
      end if;
   exception
      when Use_Error | Name_Error =>
         Misc.Aflexfatal ("could not create DFA package file");
   end Get_Dfa_File;

   procedure Get_Scanner_File (F : in out File_Type; Spec : in Boolean) is
      Outfile_Name : Vstring;
   begin
      if (Len (Infilename) /= 0) then

         -- give out infile + ada_suffix
         Outfile_Name := Misc.Basename & ".ada";
      else
         Outfile_Name := Vstr ("aflex_yy." & Ada_Suffix (Spec));
      end if;

      Create (F, Out_File, Str (Outfile_Name));
      Set_Output (F);
   exception
      when Name_Error | Use_Error =>
         Misc.Aflexfatal ("can't create scanner file " & Outfile_Name);
   end Get_Scanner_File;

   procedure Get_Backtrack_File (F : in out File_Type) is
   begin
      Create (F, Out_File, "aflex.backtrack");
   exception
      when Use_Error | Name_Error =>
         Misc.Aflexfatal ("could not create backtrack file");
   end Get_Backtrack_File;

   procedure Initialize_Files is
   begin
      null;

      -- doesn't need to do anything on Verdix
   end Initialize_Files;

end External_File_Manager;
