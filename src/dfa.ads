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

-- TITLE DFA construction routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION converts non-deterministic finite automatons to finite ones.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/dfaS.a,v 1.4 90/01/12 15:19:52 self Exp Locker: self $

with Misc_Defs;
with Text_Io;
package Dfa is
   use Misc_Defs, Text_Io;
   procedure Check_For_Backtracking
     (Ds : in Integer; State : in Unbounded_Int_Array);
   procedure Check_Trailing_Context
     (Nfa_States : in Int_Ptr; Num_States : in Integer; Accset : in Int_Ptr;
      Nacc       : in Integer);

   procedure Dump_Associated_Rules (F : in File_Type; Ds : in Integer);

   procedure Dump_Transitions
     (F : in File_Type; State : in Unbounded_Int_Array);

   procedure Epsclosure
     (T : in out Int_Ptr; Ns_Addr : in out Integer; Accset : in Int_Ptr;
      Nacc_Addr, Hv_Addr :    out Integer);

   procedure Increase_Max_Dfas;

   procedure Ntod;

   procedure Snstods
     (Sns           : in Int_Ptr; Numstates : in Integer; Accset : in Int_Ptr;
      Nacc, Hashval : in     Integer; Newds_Addr : out Integer;
      Result        :    out Boolean);

   function Symfollowset
     (Ds : in Int_Ptr; Dsize, Transsym : in Integer; Nset : in Int_Ptr)
      return Integer;

   procedure Sympartition
     (Ds      : in     Int_Ptr; Numstates : in Integer;
      Symlist : in out C_Size_Bool_Array; Duplist : in out C_Size_Array);
end Dfa;
