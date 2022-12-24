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

-- TITLE equivalence class
-- AUTHOR: John Self (UCI)
-- DESCRIPTION finds equivalence classes so DFA will be smaller
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/ecsS.a,v 1.4 90/01/12 15:19:57 self Exp Locker: self $

with Misc_Defs; use Misc_Defs;
package Ecs is
   procedure Ccl2ecl;
   procedure Cre8ecs
     (Fwd    : in C_Size_Array; Bck : in out C_Size_Array; Num : in Integer;
      Result :    out Integer);
   procedure Mkeccl
     (Ccls     : in     Char_Array; Lenccl : in Integer;
      Fwd, Bck : in out Unbounded_Int_Array; Llsiz : in Integer);
   procedure Mkechar (Tch : in Integer; Fwd, Bck : in out C_Size_Array);
end Ecs;
