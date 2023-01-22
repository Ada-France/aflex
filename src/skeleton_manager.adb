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

-- TITLE skeleton manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION outputs skeleton sections when called by gen.
-- NOTES allows use of internal or external skeleton
-- $Header: /dc/uc/self/arcadia/aflex/ada/src/RCS/skeleton_managerB.a,v 1.19 1992/12/29 22:46:15 self Exp self $

with Misc_Defs;
with Template_Manager.Templates;
with Template_Manager;
with Ada.Text_IO;
package body Skeleton_Manager is
   use Template_Manager;
   use Misc_Defs;

   Use_External_Skeleton : Boolean := False;
   -- are we using an external skelfile?

   Body_Current_Line : Positive := 1;

   -- set_external_skeleton
   --
   -- DESCRIPTION
   -- sets flag so we know to use an external skelfile

   procedure Set_External_Skeleton is
   begin
      Use_External_Skeleton := True;
   end Set_External_Skeleton;

   procedure Write_Template (Outfile  : in Ada.Text_IO.File_Type) is
      function Has_Line return Boolean is
      begin
         return not Ada.Text_IO.End_Of_File (Skelfile);
      end Has_Line;

      function Get_Line return String is
      begin
         return Ada.Text_IO.Get_Line (Skelfile);
      end Get_Line;

      procedure Write is new Template_Writer (Has_Line, Get_Line);

   begin
      Write (Outfile);
    end Write_Template;

   -- skelout - write out one section of the skeleton file
   --
   -- DESCRIPTION
   --    Either outputs internal skeleton, or from a file with "%%" dividers
   --    if a skeleton file is specified by the user.
   --    Copies from skelfile to stdout until a line beginning with "%%" or
   --    EOF is found.

   procedure Skelout is
   begin
      if Use_External_Skeleton then
         Write_Template (Ada.Text_IO.Current_Output);
      elsif Reentrant then
         Template_Manager.Write_Template (Ada.Text_IO.Current_Output,
                                          Template_Manager.Templates.body_reentrant_lex,
                                          Body_Current_Line);
      else
         Template_Manager.Write_Template (Ada.Text_IO.Current_Output,
                                          Template_Manager.Templates.body_lex,
                                          Body_Current_Line);
      end if;
   end Skelout;

end Skeleton_Manager;
