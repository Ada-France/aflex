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
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/genS.a,v 1.4 90/01/12 15:20:07 self Exp Locker: self $

package Gen is
   procedure Do_Indent;
   procedure Gen_Backtracking;
   procedure Gen_Bt_Action;
   procedure Gen_Find_Action;
   procedure Gen_Next_Compressed_State;
   procedure Gen_Next_Match;
   procedure Gen_Next_State;
   procedure Gen_Start_State;
   procedure Genecs;
   procedure Genftbl;
   procedure Indent_Puts (Str : in String);
   procedure Gentabs;
   procedure Indent_Down;
   pragma Inline (Indent_Down);
   procedure Indent_Up;
   pragma Inline (Indent_Up);
   procedure Set_Indent (Indent_Val : in Integer);
   procedure Make_Tables;
   procedure Do_Sect3_Out;
end Gen;
