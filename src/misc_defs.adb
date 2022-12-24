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

-- TITLE miscellaneous definitions
-- AUTHOR: John Self (UCI)
-- DESCRIPTION contains all global variables used in aflex.
--             also some subprograms which are commonly used.
-- NOTES The real purpose of this file is to contain all miscellaneous
--       items (functions, MACROS, variables definitions) which were at the
--       top level of flex.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/misc_defsB.a,v 1.5 90/01/12 15:20:21 self Exp Locker: self $

package body Misc_Defs is

-- returns true if an nfa state has an epsilon out-transition slot
-- that can be used.  This definition is currently not used.

   function Free_Epsilon (State : in Integer) return Boolean is
   begin
      return
        ((Transchar (State) = Sym_Epsilon) and
         (Trans2 (State) = No_Transition) and (Finalst (State) /= State));
   end Free_Epsilon;

   -- returns true if an nfa state has an epsilon out-transition character
   -- and both slots are free

   function Super_Free_Epsilon (State : in Integer) return Boolean is
   begin
      return
        ((Transchar (State) = Sym_Epsilon) and
         (Trans1 (State) = No_Transition));
   end Super_Free_Epsilon;

   function Allocate_Integer_Array (Size : in Integer) return Int_Ptr is
   begin
      return new Unbounded_Int_Array (0 .. Size);
   end Allocate_Integer_Array;

   procedure Reallocate_Integer_Array (Arr : in out Int_Ptr; Size : in Integer)
   is
      New_Arr : Int_Ptr;
   begin
      New_Arr                 := Allocate_Integer_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Integer_Array;

   procedure Reallocate_State_Enum_Array
     (Arr : in out State_Enum_Ptr; Size : in Integer)
   is
      New_Arr : State_Enum_Ptr;
   begin
      New_Arr                 := Allocate_State_Enum_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_State_Enum_Array;

   procedure Reallocate_Rule_Enum_Array
     (Arr : in out Rule_Enum_Ptr; Size : in Integer)
   is
      New_Arr : Rule_Enum_Ptr;
   begin
      New_Arr                 := Allocate_Rule_Enum_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Rule_Enum_Array;

   function Allocate_Int_Ptr_Array (Size : in Integer) return Int_Star_Ptr is
   begin
      return new Unbounded_Int_Star_Array (0 .. Size);
   end Allocate_Int_Ptr_Array;

   function Allocate_Rule_Enum_Array (Size : in Integer) return Rule_Enum_Ptr
   is
   begin
      return new Unbounded_Rule_Enum_Array (0 .. Size);
   end Allocate_Rule_Enum_Array;

   function Allocate_State_Enum_Array (Size : in Integer) return State_Enum_Ptr
   is
   begin
      return new Unbounded_State_Enum_Array (0 .. Size);
   end Allocate_State_Enum_Array;

   function Allocate_Boolean_Array (Size : in Integer) return Boolean_Ptr is
   begin
      return new Boolean_Array (0 .. Size);
   end Allocate_Boolean_Array;

   function Allocate_Vstring_Array (Size : in Integer) return Vstring_Ptr is
   begin
      return new Unbounded_Vstring_Array (0 .. Size);
   end Allocate_Vstring_Array;

   function Allocate_Dfaacc_Union (Size : in Integer) return Dfaacc_Ptr is
   begin
      return new Unbounded_Dfaacc_Array (0 .. Size);
   end Allocate_Dfaacc_Union;

   procedure Reallocate_Int_Ptr_Array
     (Arr : in out Int_Star_Ptr; Size : in Integer)
   is
      New_Arr : Int_Star_Ptr;
   begin
      New_Arr                 := Allocate_Int_Ptr_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Int_Ptr_Array;

   procedure Reallocate_Character_Array
     (Arr : in out Char_Ptr; Size : in Integer)
   is
      New_Arr : Char_Ptr;
   begin
      New_Arr                 := Allocate_Character_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Character_Array;

   procedure Reallocate_Vstring_Array
     (Arr : in out Vstring_Ptr; Size : in Integer)
   is
      New_Arr : Vstring_Ptr;
   begin
      New_Arr                 := Allocate_Vstring_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Vstring_Array;

   function Allocate_Character_Array (Size : in Integer) return Char_Ptr is
   begin
      return new Char_Array (0 .. Size);
   end Allocate_Character_Array;

   procedure Reallocate_Dfaacc_Union
     (Arr : in out Dfaacc_Ptr; Size : in Integer)
   is
      New_Arr : Dfaacc_Ptr;
   begin
      New_Arr                 := Allocate_Dfaacc_Union (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Dfaacc_Union;

   procedure Reallocate_Boolean_Array
     (Arr : in out Boolean_Ptr; Size : in Integer)
   is
      New_Arr : Boolean_Ptr;
   begin
      New_Arr                 := Allocate_Boolean_Array (Size);
      New_Arr (0 .. Arr'Last) := Arr (0 .. Arr'Last);
      Arr                     := New_Arr;
   end Reallocate_Boolean_Array;

end Misc_Defs;
