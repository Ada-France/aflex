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

-- TITLE table compression routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION used for compressed tables only
-- NOTES somewhat complicated but works fast and generates efficient scanners
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/tblcmpS.a,v 1.3 90/01/12 15:20:47 self Exp Locker: self $

with Misc_Defs; use Misc_Defs;

package Tblcmp is

-- bldtbl - build table entries for dfa state

   procedure Bldtbl
     (State                                   : in Unbounded_Int_Array;
      Statenum, Totaltrans, Comstate, Comfreq : in Integer);

   procedure Cmptmps;

   -- expand_nxt_chk - expand the next check arrays

   procedure Expand_Nxt_Chk;

   -- find_table_space - finds a space in the table for a state to be placed

   function Find_Table_Space
     (State : in Unbounded_Int_Array; Numtrans : in Integer) return Integer;

   -- inittbl - initialize transition tables

   procedure Inittbl;

   -- mkdeftbl - make the default, "jam" table entries

   procedure Mkdeftbl;

   -- mkentry - create base/def and nxt/chk entries for transition array

   procedure Mkentry
     (State                                   : in Unbounded_Int_Array;
      Numchars, Statenum, Deflink, Totaltrans : in Integer);

   -- mk1tbl - create table entries for a state (or state fragment) which
   --            has only one out-transition

   procedure Mk1tbl (State, Sym, Onenxt, Onedef : in Integer);

   -- mkprot - create new proto entry

   procedure Mkprot
     (State : in Unbounded_Int_Array; Statenum, Comstate : in Integer);

-- mktemplate - create a template entry based on a state, and connect the state
   --              to it

   procedure Mktemplate
     (State : in Unbounded_Int_Array; Statenum, Comstate : in Integer);

   -- mv2front - move proto queue element to front of queue

   procedure Mv2front (Qelm : in Integer);

   -- place_state - place a state into full speed transition table

   procedure Place_State
     (State : in Unbounded_Int_Array; Statenum, Transnum : in Integer);

   -- stack1 - save states with only one out-transition to be processed later

   procedure Stack1 (Statenum, Sym, Nextstate, Deflink : in Integer);

   -- tbldiff - compute differences between two state tables

   procedure Tbldiff
     (State : in     Unbounded_Int_Array; Pr : in Integer;
      Ext   :    out Unbounded_Int_Array; Result : out Integer);

end Tblcmp;
