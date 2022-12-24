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

-- TITLE character classes routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION routines for character classes like [abc]
-- $Header: /dc/uc/self/arcadia/aflex/ada/src/RCS/cclB.a,v 1.7 1993/04/27 23:17:15 self Exp $

with Misc, Tstring;
package body Ccl is

-- ccladd - add a single character to a ccl
   procedure Ccladd (Cclp : in Integer; Ch : in Character) is
      Ind, Len, Newpos : Integer;
   begin
      Len := Ccllen (Cclp);
      Ind := Cclmap (Cclp);

      -- check to see if the character is already in the ccl
      for I in 0 .. Len - 1 loop
         if (Ccltbl (Ind + I) = Ch) then
            return;
         end if;
      end loop;

      Newpos := Ind + Len;

      if (Newpos >= Current_Max_Ccl_Tbl_Size) then
         Current_Max_Ccl_Tbl_Size :=
           Current_Max_Ccl_Tbl_Size + Max_Ccl_Tbl_Size_Increment;

         Num_Reallocs := Num_Reallocs + 1;

         Reallocate_Character_Array (Ccltbl, Current_Max_Ccl_Tbl_Size);
      end if;

      Ccllen (Cclp)   := Len + 1;
      Ccltbl (Newpos) := Ch;

   end Ccladd;

   -- cclinit - make an empty ccl

   function Cclinit return Integer is
   begin
      Lastccl := Lastccl + 1;
      if (Lastccl >= Current_Maxccls) then
         Current_Maxccls := Current_Maxccls + Max_Ccls_Increment;

         Num_Reallocs := Num_Reallocs + 1;

         Reallocate_Integer_Array (Cclmap, Current_Maxccls);
         Reallocate_Integer_Array (Ccllen, Current_Maxccls);
         Reallocate_Integer_Array (Cclng, Current_Maxccls);
      end if;

      if (Lastccl = 1) then

         -- we're making the first ccl
         Cclmap (Lastccl) := 0;

      else

         -- the new pointer is just past the end of the last ccl.  Since
         -- the cclmap points to the \first/ character of a ccl, adding the
         -- length of the ccl to the cclmap pointer will produce a cursor
         -- to the first free space
         Cclmap (Lastccl) := Cclmap (Lastccl - 1) + Ccllen (Lastccl - 1);
      end if;

      Ccllen (Lastccl) := 0;
      Cclng (Lastccl)  := 0;

      -- ccl's start out life un-negated
      return Lastccl;
   end Cclinit;

   -- cclnegate - negate a ccl

   procedure Cclnegate (Cclp : in Integer) is
   begin
      Cclng (Cclp) := 1;
   end Cclnegate;

   -- list_character_set - list the members of a set of characters in CCL form
   --
   -- writes to the given file a character-class representation of those
   -- characters present in the given set.  A character is present if it
   -- has a non-zero value in the set array.

   procedure List_Character_Set (F : in File_Type; Cset : in C_Size_Bool_Array)
   is
      I, Start_Char : Integer;
   begin
      Text_Io.Put (F, '[');

      I := 1;
      while (I <= Csize) loop
         if (Cset (I)) then
            Start_Char := I;

            Text_Io.Put (F, ' ');

            Tstring.Put (F, Misc.Readable_Form (Character'Val (I)));

            I := I + 1;
            while ((I <= Csize) and then (Cset (I))) loop
               I := I + 1;
            end loop;

            if (I - 1 > Start_Char) then

               -- this was a run
               Text_Io.Put (F, "-");
               Tstring.Put (F, Misc.Readable_Form (Character'Val (I - 1)));
            end if;

            Text_Io.Put (F, ' ');
         end if;
         I := I + 1;
      end loop;

      Text_Io.Put (F, ']');
   end List_Character_Set;
end Ccl;
