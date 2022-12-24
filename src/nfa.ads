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

-- TITLE NFA construction routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION builds the NFA.
-- NOTES this file mirrors flex as closely as possible.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/nfaS.a,v 1.4 90/01/12 15:20:30 self Exp Locker: self $

package Nfa is
   procedure Add_Accept (Mach : in out Integer; Accepting_Number : in Integer);
   function Copysingl (Singl, Num : in Integer) return Integer;
   procedure Dumpnfa (State1 : in Integer);
   function Dupmachine (Mach : in Integer) return Integer;
   procedure Finish_Rule
     (Mach              : in Integer; Variable_Trail_Rule : in Boolean;
      Headcnt, Trailcnt : in Integer);
   function Link_Machines (First, Last : in Integer) return Integer;
   procedure Mark_Beginning_As_Normal (Mach : in Integer);
   function Mkbranch (First, Second : in Integer) return Integer;
   function Mkclos (State : in Integer) return Integer;
   function Mkopt (Mach : in Integer) return Integer;
   function Mkor (First, Second : in Integer) return Integer;
   function Mkposcl (State : in Integer) return Integer;
   function Mkrep (Mach, Lb, Ub : in Integer) return Integer;
   function Mkstate (Sym : in Integer) return Integer;
   procedure Mkxtion (Statefrom, Stateto : in Integer);
   procedure New_Rule;
end Nfa;
