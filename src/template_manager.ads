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
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/template_managerS.a,v 1.3 90/01/12 15:20:49 self Exp Locker: self $

with Ada.Text_IO;
package Template_Manager is

   type Content_Array is array (Positive range <>) of access constant String;
   type Content_Access is access constant Content_Array;

   type Code_Filename is (YYTYPE_CODE, YYINIT_CODE, YYACTION_CODE, YYWRAP_CODE);

   function Get_Filename (Code : in Code_Filename) return String;

   generic
      with function Has_Line return Boolean;
      with function Get_Line return String;
   procedure Template_Writer (Outfile  : in Ada.Text_IO.File_Type);

   procedure Write_Template (Outfile  : in Ada.Text_IO.File_Type;
                             Lines    : in Content_Array;
                             Position : in out Positive);

   procedure Generate_Dfa_File;
   procedure Generate_Io_File;

   procedure Cleanup;

end Template_Manager;
