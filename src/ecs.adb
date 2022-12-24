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
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/ecsB.a,v 1.7 90/01/12 15:19:54 self Exp Locker: self $

with Misc;

package body Ecs is

-- ccl2ecl - convert character classes to set of equivalence classes

   procedure Ccl2ecl is
      Ich, Newlen, Cclp, Cclmec : Integer;
   begin
      for I in 1 .. Lastccl loop

         -- we loop through each character class, and for each character
         -- in the class, add the character's equivalence class to the
         -- new "character" class we are creating.  Thus when we are all
         -- done, character classes will really consist of collections
         -- of equivalence classes
         Newlen := 0;
         Cclp   := Cclmap (I);

         for Ccls in 0 .. Ccllen (I) - 1 loop
            Ich    := Character'Pos (Ccltbl (Cclp + Ccls));
            Cclmec := Ecgroup (Ich);
            if (Cclmec > 0) then
               Ccltbl (Cclp + Newlen) := Character'Val (Cclmec);
               Newlen                 := Newlen + 1;
            end if;
         end loop;

         Ccllen (I) := Newlen;
      end loop;
   end Ccl2ecl;

   -- cre8ecs - associate equivalence class numbers with class members
   --  fwd is the forward linked-list of equivalence class members.  bck
   --  is the backward linked-list, and num is the number of class members.
   --  Returned is the number of classes.

   procedure Cre8ecs
     (Fwd    : in C_Size_Array; Bck : in out C_Size_Array; Num : in Integer;
      Result :    out Integer)
   is
      J, Numcl : Integer;
   begin
      Numcl := 0;

      -- create equivalence class numbers.  From now on, abs( bck(x) )
      -- is the equivalence class number for object x.  If bck(x)
      -- is positive, then x is the representative of its equivalence
      -- class.
      for I in 1 .. Num loop
         if Bck (I) = Nil then
            Numcl   := Numcl + 1;
            Bck (I) := Numcl;
            J       := Fwd (I);
            while J /= Nil loop
               Bck (J) := -Numcl;
               J       := Fwd (J);
            end loop;
         end if;
      end loop;
      Result := Numcl;
   end Cre8ecs;

-- mkeccl - update equivalence classes based on character class xtions
-- where ccls contains the elements of the character class, lenccl is the
-- number of elements in the ccl, fwd is the forward link-list of equivalent
-- characters, bck is the backward link-list, and llsiz size of the link-list

   procedure Mkeccl
     (Ccls     : in     Char_Array; Lenccl : in Integer;
      Fwd, Bck : in out Unbounded_Int_Array; Llsiz : in Integer)
   is
      subtype Oldec_Type is Integer range Fwd'First .. Fwd'Last;
      Cclp, Newec, Cclm, I, J : Integer;
      Oldec                   : Oldec_Type;
      Proc_Array              : Boolean_Ptr;
   begin

      -- note that it doesn't matter whether or not the character class is
      -- negated.  The same results will be obtained in either case.
      Cclp := Ccls'First;

      -- this array tells whether or not a character class has been processed.
      Proc_Array := new Boolean_Array (Ccls'First .. Ccls'Last);
      for Ccl_Index in Ccls'First .. Ccls'Last loop
         Proc_Array (Ccl_Index) := False;
      end loop;

      while Cclp < Lenccl + Ccls'First loop
         Cclm  := Character'Pos (Ccls (Cclp));
         Oldec := Bck (Cclm);
         Newec := Cclm;

         J := Cclp + 1;

         I := Fwd (Cclm);
         while (I /= Nil) and (I <= Llsiz) loop

            -- look for the symbol in the character class
            while (J < Lenccl + Ccls'First) and
              ((Ccls (J) <= Character'Val (I)) or Proc_Array (J))
            loop
               if Ccls (J) = Character'Val (I) then

                  -- we found an old companion of cclm in the ccl.
                  -- link it into the new equivalence class and flag it as
                  -- having been processed
                  Bck (I)        := Newec;
                  Fwd (Newec)    := I;
                  Newec          := I;
                  Proc_Array (J) := True;

                  -- set flag so we don't reprocess

                  -- get next equivalence class member
                  -- continue 2
                  goto Next_Pt;
               end if;
               J := J + 1;
            end loop;

            -- symbol isn't in character class.  Put it in the old equivalence
            -- class
            Bck (I) := Oldec;

            if Oldec /= Nil then
               Fwd (Oldec) := I;
            end if;

            Oldec := I;
            <<Next_Pt>>
            I := Fwd (I);
         end loop;

         if Bck (Cclm) /= Nil or Oldec /= Bck (Cclm) then
            Bck (Cclm)  := Nil;
            Fwd (Oldec) := Nil;
         end if;

         Fwd (Newec) := Nil;

         -- find next ccl member to process
         Cclp := Cclp + 1;

         while Cclp < Lenccl + Ccls'First and Proc_Array (Cclp) loop
            -- reset "doesn't need processing" flag
            Proc_Array (Cclp) := False;
            Cclp              := Cclp + 1;
         end loop;
      end loop;
   exception
      when Storage_Error =>
         Misc.Aflexfatal ("dynamic memory failure in mkeccl()");

      when Constraint_Error =>
         Misc.Aflexfatal ("index out of bounds: may be CSIZE is not correct");

   end Mkeccl;

   -- mkechar - create equivalence class for single character

   procedure Mkechar (Tch : in Integer; Fwd, Bck : in out C_Size_Array) is
   begin

      -- if until now the character has been a proper subset of
      -- an equivalence class, break it away to create a new ec
      if Fwd (Tch) /= Nil then
         Bck (Fwd (Tch)) := Bck (Tch);
      end if;

      if Bck (Tch) /= Nil then
         Fwd (Bck (Tch)) := Fwd (Tch);
      end if;

      Fwd (Tch) := Nil;
      Bck (Tch) := Nil;
   end Mkechar;

end Ecs;
