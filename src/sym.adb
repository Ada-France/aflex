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
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/symB.a,v 1.6 90/01/12 15:20:39 self Exp Locker: self $

with Misc, Nfa, Text_Io, Int_Io;

package body Sym is

   -- addsym - add symbol and definitions to symbol table
   --
   -- true is returned if the symbol already exists, and the change not made.

   procedure Addsym
     (Sym, Str_Def : in     Vstring; Int_Def : in Integer;
      Table : in out Hash_Table; Table_Size : in Integer; Result : out Boolean)
   is
      Hash_Val             : constant Integer := Hashfunct (Sym, Table_Size);
      Sym_Entry            : Hash_Link        := Table (Hash_Val);
      New_Entry, Successor : Hash_Link;
   begin
      while Sym_Entry /= null loop
         if Sym = Sym_Entry.Name then
            -- entry already exists
            Result := True;
            return;
         end if;

         Sym_Entry := Sym_Entry.Next;
      end loop;

      -- create new entry
      New_Entry := new Hash_Entry;

      Successor := Table (Hash_Val);
      if Successor /= null then
         New_Entry.Next := Successor;
         Successor.Prev := New_Entry;
      else
         New_Entry.Next := null;
      end if;

      New_Entry.Prev    := null;
      New_Entry.Name    := Sym;
      New_Entry.Str_Val := Str_Def;
      New_Entry.Int_Val := Int_Def;

      Table (Hash_Val) := New_Entry;

      Result := False;

   exception
      when Storage_Error =>
         Misc.Aflexfatal ("symbol table memory allocation failed");
   end Addsym;

   -- cclinstal - save the text of a character class

   procedure Cclinstal (Ccltxt : in Vstring; Cclnum : in Integer) is
      -- we don't bother checking the return status because we are not called
      -- unless the symbol is new
      Dummy : Boolean;
   begin
      Addsym (Ccltxt, Nul, Cclnum, Ccltab, Ccl_Hash_Size, Dummy);
   end Cclinstal;

   -- ccllookup - lookup the number associated with character class text

   function Ccllookup (Ccltxt : in Vstring) return Integer is
   begin
      return Findsym (Ccltxt, Ccltab, Ccl_Hash_Size).Int_Val;
   end Ccllookup;

   -- findsym - find symbol in symbol table

   function Findsym
     (Symbol : in Vstring; Table : in Hash_Table; Table_Size : in Integer)
      return Hash_Link
   is
      Sym_Entry   : Hash_Link := Table (Hashfunct (Symbol, Table_Size));
      Empty_Entry : Hash_Link;
   begin
      while Sym_Entry /= null loop
         if Symbol = Sym_Entry.Name then
            return Sym_Entry;
         end if;
         Sym_Entry := Sym_Entry.Next;
      end loop;
      Empty_Entry     := new Hash_Entry;
      Empty_Entry.all := (null, null, Nul, Nul, 0);

      return Empty_Entry;
   exception
      when Storage_Error =>
         Misc.Aflexfatal ("dynamic memory failure in findsym()");
         return Empty_Entry;
   end Findsym;

   -- hashfunct - compute the hash value for "str" and hash size "hash_size"

   function Hashfunct (Str : in Vstring; Hash_Size : in Integer) return Integer
   is
      Hashval, Locstr : Integer;
   begin
      Hashval := 0;
      Locstr  := Tstring.First;

      while Locstr <= Tstring.Len (Str) loop
         Hashval :=
           ((Hashval * 2) + Character'Pos (Char (Str, Locstr))) mod Hash_Size;
         Locstr := Locstr + 1;
      end loop;

      return Hashval;
   end Hashfunct;

   --ndinstal - install a name definition

   procedure Ndinstal (Nd, Def : in Vstring) is
      Result : Boolean;
   begin
      Addsym (Nd, Def, 0, Ndtbl, Name_Table_Hash_Size, Result);
      if Result then
         Misc.Synerr ("name defined twice");
      end if;
   end Ndinstal;

   -- ndlookup - lookup a name definition

   function Ndlookup (Nd : in Vstring) return Vstring is
   begin
      return Findsym (Nd, Ndtbl, Name_Table_Hash_Size).Str_Val;
   end Ndlookup;

   -- scinstal - make a start condition
   --
   -- NOTE
   --    the start condition is Exclusive if xcluflg is true

   procedure Scinstal (Str : in Vstring; Xcluflg : in Boolean) is
      -- bit of a hack.  We know how the default start-condition is
      -- declared, and don't put out a define for it, because it
      -- would come out as "#define 0 1"

      -- actually, this is no longer the case.  The default start-condition
      -- is now called "INITIAL".  But we keep the following for the sake
      -- of future robustness.
      Result : Boolean;
   begin
      if Str /= Vstr ("0") then
         Tstring.Put (Def_File, Str);
         Text_Io.Put (Def_File, " : constant := ");
         Int_Io.Put (Def_File, Lastsc, 1);
         Text_Io.Put_Line (Def_File, ";");
      end if;

      Lastsc := Lastsc + 1;
      if Lastsc >= Current_Max_Scs then
         Current_Max_Scs := Current_Max_Scs + Max_Scs_Increment;

         Num_Reallocs := Num_Reallocs + 1;

         Reallocate_Integer_Array (Scset, Current_Max_Scs);
         Reallocate_Integer_Array (Scbol, Current_Max_Scs);
         Reallocate_Boolean_Array (Scxclu, Current_Max_Scs);
         Reallocate_Boolean_Array (Sceof, Current_Max_Scs);
         Reallocate_Vstring_Array (Scname, Current_Max_Scs);
         Reallocate_Integer_Array (Actvsc, Current_Max_Scs);
      end if;

      Scname (Lastsc) := Str;

      Addsym
        (Scname (Lastsc), Nul, Lastsc, Sctbl, Start_Cond_Hash_Size, Result);
      if Result then
         Misc.Aflexerror ("start condition " & Str & " declared twice");
      end if;

      Scset (Lastsc)  := Nfa.Mkstate (Sym_Epsilon);
      Scbol (Lastsc)  := Nfa.Mkstate (Sym_Epsilon);
      Scxclu (Lastsc) := Xcluflg;
      Sceof (Lastsc)  := False;
   end Scinstal;

   -- sclookup - lookup the number associated with a start condition

   function Sclookup (Str : in Vstring) return Integer is
   begin
      return Findsym (Str, Sctbl, Start_Cond_Hash_Size).Int_Val;
   end Sclookup;

end Sym;
