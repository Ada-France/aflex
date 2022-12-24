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

-- TITLE symbol table routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION implements only a simple symbol table using open hashing
-- NOTES could be faster, but it isn't used much
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/symS.a,v 1.4 90/01/12 15:20:42 self Exp Locker: self $

with Tstring;
with Misc_Defs;
package Sym is

   use Tstring;
   use Misc_Defs;

   procedure Addsym
     (Sym, Str_Def : in     Vstring; Int_Def : in Integer;
      Table        : in out Hash_Table; Table_Size : in Integer;
      Result       :    out Boolean);
   -- result indicates success
   procedure Cclinstal (Ccltxt : in Vstring; Cclnum : in Integer);
   function Ccllookup (Ccltxt : in Vstring) return Integer;
   function Findsym
     (Symbol : in Vstring; Table : in Hash_Table; Table_Size : in Integer)
      return Hash_Link;

   function Hashfunct
     (Str : in Vstring; Hash_Size : in Integer) return Integer;
   procedure Ndinstal (Nd, Def : in Vstring);
   function Ndlookup (Nd : in Vstring) return Vstring;
   procedure Scinstal (Str : in Vstring; Xcluflg : in Boolean);
   function Sclookup (Str : in Vstring) return Integer;
end Sym;
