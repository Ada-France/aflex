package body Vstrings is

   -- local declarations

   Fill_Char : constant Character := Ascii.Nul;

--  procedure FORMAT(THE_STRING : in out VSTRING; OLDLEN : in STRINDEX := LAST) is
--    -- fill the string with FILL_CHAR to null out old values

--    begin -- FORMAT (Local Procedure)
--      THE_STRING.VALUE(THE_STRING.LEN + 1 .. OLDLEN) :=
--                                        (others => FILL_CHAR);
--    end FORMAT;

-- CvdL: the above assignment will be compiled wrongly with gcc-2.6.0
-- and gnat-1.83. It overwrites parts if the runtime stack by writing
-- fill_char for a fixed amount(?) of times.
-- Maybe the error is in the caller... it is called FORMAT(Str, 0)!!!
-- The following procedure is far from optimal but it doesn't break
-- NOTE: gcc-2.6.2 and gnat-2.00 do it wrong too!

   procedure Format (The_String : in out Vstring; Oldlen : in Strindex := Last)
   is
   -- fill the string with FILL_CHAR to null out old values

   begin -- FORMAT (Local Procedure)
      for I in The_String.Len + 1 .. Oldlen loop
         The_String.Value (I) := Fill_Char;
      end loop;
   end Format;

   -- bodies of visible operations

   function Len (From : Vstring) return Strindex is
   begin
      return From.Len;
   end Len;

   --  function MAX(FROM : VSTRING) return STRINDEX is
   --    begin
   --      return LAST;
   --    end MAX;

   function Str (From : Vstring) return String is
   begin
      return From.Value (First .. From.Len);
   end Str;

   function Char
     (From : Vstring; Position : Strindex := First) return Character
   is
   begin
      if Position not in First .. From.Len then
         raise Constraint_Error;
      end if;
      return From.Value (Position);
   end Char;

   function "<" (Left : Vstring; Right : Vstring) return Boolean is
   begin -- "<"
      return Left.Value < Right.Value;
   end "<";

   function ">" (Left : Vstring; Right : Vstring) return Boolean is
   begin -- ">"
      return Left.Value > Right.Value;
   end ">";

   function "<=" (Left : Vstring; Right : Vstring) return Boolean is
   begin -- "<="
      return Left.Value <= Right.Value;
   end "<=";

   function ">=" (Left : Vstring; Right : Vstring) return Boolean is
   begin -- ">="
      return Left.Value >= Right.Value;
   end ">=";

   procedure Put (File : in File_Type; Item : in Vstring) is
   begin -- PUT
      Put (File, Item.Value (First .. Item.Len));
   end Put;

   procedure Put (Item : in Vstring) is
   begin -- PUT
      Put (Item.Value (First .. Item.Len));
   end Put;

   procedure Put_Line (File : in File_Type; Item : in Vstring) is
   begin -- PUT_LINE
      Put_Line (File, Item.Value (First .. Item.Len));
   end Put_Line;

   procedure Put_Line (Item : in Vstring) is
   begin -- PUT_LINE
      Put_Line (Item.Value (First .. Item.Len));
   end Put_Line;

   procedure Get
     (File : in File_Type; Item : out Vstring; Length : in Strindex := Last)
   is
   begin -- GET
      if Length not in First .. Last then
         raise Constraint_Error;
      end if;

      Item := Nul;
      for Index in First .. Length loop
         Get (File, Item.Value (Index));
         Item.Len := Index;
      end loop;
   end Get;

   procedure Get (Item : out Vstring; Length : in Strindex := Last) is
   begin -- GET
      if Length not in First .. Last then
         raise Constraint_Error;
      end if;

      Item := Nul;
      for Index in First .. Length loop
         Get (Item.Value (Index));
         Item.Len := Index;
      end loop;
   end Get;

   procedure Get_Line (File : in File_Type; Item : in out Vstring) is

      Oldlen : constant Strindex := Item.Len;

   begin -- GET_LINE
      Get_Line (File, Item.Value, Item.Len);
      Format (Item, Oldlen);
   end Get_Line;

   procedure Get_Line (Item : in out Vstring) is

      Oldlen : constant Strindex := Item.Len;

   begin -- GET_LINE
      Get_Line (Item.Value, Item.Len);
      Format (Item, Oldlen);
   end Get_Line;

   function Slice (From : Vstring; Front, Back : Strindex) return Vstring is

   begin -- SLICE
      if
        ((Front not in First .. From.Len)
         or else (Back not in First .. From.Len))
        and then Front <= Back
      then
         raise Constraint_Error;
      end if;

      return Vstr (From.Value (Front .. Back));
   end Slice;

   function Substr (From : Vstring; Start, Length : Strindex) return Vstring is

   begin -- SUBSTR
      if (Start not in First .. From.Len)
        or else
        ((Start + Length - 1 not in First .. From.Len) and then (Length > 0))
      then
         raise Constraint_Error;
      end if;

      return Vstr (From.Value (Start .. Start + Length - 1));
   end Substr;

   function Delete (From : Vstring; Front, Back : Strindex) return Vstring is

      Temp : Vstring := From;

   begin -- DELETE
      if
        ((Front not in First .. From.Len)
         or else (Back not in First .. From.Len))
        and then Front <= Back
      then
         raise Constraint_Error;
      end if;

      if Front > Back then
         return From;
      end if;
      Temp.Len := From.Len - (Back - Front) - 1;

      Temp.Value (Front .. Temp.Len) := From.Value (Back + 1 .. From.Len);
      Format (Temp, From.Len);
      return Temp;
   end Delete;

   function Insert
     (Target : Vstring; Item : Vstring; Position : Strindex := First)
      return Vstring
   is

      Temp : Vstring;

   begin -- INSERT
      if Position not in First .. Target.Len then
         raise Constraint_Error;
      end if;

      if Target.Len + Item.Len > Last then
         raise Constraint_Error;
      else
         Temp.Len := Target.Len + Item.Len;
      end if;

      Temp.Value (First .. Position - 1) :=
        Target.Value (First .. Position - 1);
      Temp.Value (Position .. (Position + Item.Len - 1)) :=
        Item.Value (First .. Item.Len);
      Temp.Value ((Position + Item.Len) .. Temp.Len) :=
        Target.Value (Position .. Target.Len);

      return Temp;
   end Insert;

   function Insert
     (Target : Vstring; Item : String; Position : Strindex := First)
      return Vstring
   is
   begin -- INSERT
      return Insert (Target, Vstr (Item), Position);
   end Insert;

   function Insert
     (Target : Vstring; Item : Character; Position : Strindex := First)
      return Vstring
   is
   begin -- INSERT
      return Insert (Target, Vstr (Item), Position);
   end Insert;

   function Append
     (Target : Vstring; Item : Vstring; Position : Strindex) return Vstring
   is

      Temp : Vstring;
      Pos  : constant Strindex := Position;

   begin -- APPEND
      if Position not in First .. Target.Len then
         raise Constraint_Error;
      end if;

      if Target.Len + Item.Len > Last then
         raise Constraint_Error;
      else
         Temp.Len := Target.Len + Item.Len;
      end if;

      Temp.Value (First .. Pos)                := Target.Value (First .. Pos);
      Temp.Value (Pos + 1 .. (Pos + Item.Len)) :=
        Item.Value (First .. Item.Len);
      Temp.Value ((Pos + Item.Len + 1) .. Temp.Len) :=
        Target.Value (Pos + 1 .. Target.Len);

      return Temp;
   end Append;

   function Append
     (Target : Vstring; Item : String; Position : Strindex) return Vstring
   is
   begin
      return Append (Target, Vstr (Item), Position);
   end Append;

   function Append
     (Target : Vstring; Item : Character; Position : Strindex) return Vstring
   is
   begin
      return Append (Target, Vstr (Item), Position);
   end Append;

   function Append (Target : Vstring; Item : Vstring) return Vstring is
   begin
      return Append (Target, Item, Target.Len);
   end Append;

   function Append (Target : Vstring; Item : String) return Vstring is
   begin
      return Append (Target, Vstr (Item), Target.Len);
   end Append;

   function Append (Target : Vstring; Item : Character) return Vstring is
   begin
      return Append (Target, Vstr (Item), Target.Len);
   end Append;

   function Replace
     (Target : Vstring; Item : Vstring; Position : Strindex := First)
      return Vstring
   is
      Temp : Vstring;

   begin -- REPLACE
      if Position not in First .. Target.Len then
         raise Constraint_Error;
      end if;

      if Position + Item.Len - 1 <= Target.Len then
         Temp.Len := Target.Len;
      elsif Position + Item.Len - 1 > Last then
         raise Constraint_Error;
      else
         Temp.Len := Position + Item.Len - 1;
      end if;

      Temp.Value (First .. Position - 1) :=
        Target.Value (First .. Position - 1);
      Temp.Value (Position .. (Position + Item.Len - 1)) :=
        Item.Value (First .. Item.Len);
      Temp.Value ((Position + Item.Len) .. Temp.Len) :=
        Target.Value ((Position + Item.Len) .. Target.Len);

      return Temp;
   end Replace;

   function Replace
     (Target : Vstring; Item : String; Position : Strindex := First)
      return Vstring
   is
   begin
      return Replace (Target, Vstr (Item), Position);
   end Replace;

   function Replace
     (Target : Vstring; Item : Character; Position : Strindex := First)
      return Vstring
   is
   begin
      return Replace (Target, Vstr (Item), Position);
   end Replace;

   function "&" (Left : Vstring; Right : Vstring) return Vstring is
      Temp : Vstring;

   begin -- "&"
      if Left.Len + Right.Len > Last then
         raise Constraint_Error;
      else
         Temp.Len := Left.Len + Right.Len;
      end if;

      Temp.Value (First .. Temp.Len) :=
        Left.Value (First .. Left.Len) & Right.Value (First .. Right.Len);
      return Temp;
   end "&";

   function "&" (Left : Vstring; Right : String) return Vstring is
   begin
      return Left & Vstr (Right);
   end "&";

   function "&" (Left : Vstring; Right : Character) return Vstring is
   begin
      return Left & Vstr (Right);
   end "&";

   function "&" (Left : String; Right : Vstring) return Vstring is
   begin
      return Vstr (Left) & Right;
   end "&";

   function "&" (Left : Character; Right : Vstring) return Vstring is
   begin
      return Vstr (Left) & Right;
   end "&";

   function Index
     (Whole : Vstring; Part : Vstring; Occurrence : Natural := 1)
      return Strindex
   is

      Not_Found : constant Natural := 0;
      Index     : Natural          := First;
      Count     : Natural          := 0;

   begin -- INDEX
      if Part = Nul then
         return Not_Found; -- by definition
      end if;

      while Index + Part.Len - 1 <= Whole.Len and then Count < Occurrence loop
         if Whole.Value (Index .. Part.Len + Index - 1) =
           Part.Value (1 .. Part.Len)
         then
            Count := Count + 1;
         end if;
         Index := Index + 1;
      end loop;

      if Count = Occurrence then
         return Index - 1;
      else
         return Not_Found;
      end if;
   end Index;

   function Index
     (Whole : Vstring; Part : String; Occurrence : Natural := 1)
      return Strindex
   is

   begin
      return Index (Whole, Vstr (Part), Occurrence);
   end Index;

   function Index
     (Whole : Vstring; Part : Character; Occurrence : Natural := 1)
      return Strindex
   is

   begin
      return Index (Whole, Vstr (Part), Occurrence);
   end Index;

   function Rindex
     (Whole : Vstring; Part : Vstring; Occurrence : Natural := 1)
      return Strindex
   is

      Not_Found : constant Natural := 0;
      Index     : Integer          := Whole.Len - (Part.Len - 1);
      Count     : Natural          := 0;

   begin -- RINDEX
      if Part = Nul then
         return Not_Found; -- by definition
      end if;

      while Index >= First and then Count < Occurrence loop
         if Whole.Value (Index .. Part.Len + Index - 1) =
           Part.Value (1 .. Part.Len)
         then
            Count := Count + 1;
         end if;
         Index := Index - 1;
      end loop;

      if Count = Occurrence then
         if Count > 0 then
            return Index + 1;
         else
            return Not_Found;
         end if;
      else
         return Not_Found;
      end if;
   end Rindex;

   function Rindex
     (Whole : Vstring; Part : String; Occurrence : Natural := 1)
      return Strindex
   is
   begin
      return Rindex (Whole, Vstr (Part), Occurrence);
   end Rindex;

   function Rindex
     (Whole : Vstring; Part : Character; Occurrence : Natural := 1)
      return Strindex
   is
   begin
      return Rindex (Whole, Vstr (Part), Occurrence);
   end Rindex;

   function Vstr (From : Character) return Vstring is

      Temp : Vstring;

   begin -- VSTR
      if Last < 1 then
         raise Constraint_Error;
      else
         Temp.Len := 1;
      end if;

      Temp.Value (First) := From;
      return Temp;
   end Vstr;

   function Vstr (From : String) return Vstring is

      Temp : Vstring;

   begin -- VSTR
      if From'Length > Last then
         raise Constraint_Error;
      else
         Temp.Len := From'Length;
      end if;

      Temp.Value (First .. From'Length) := From;
      return Temp;
   end Vstr;

   function "+" (From : String) return Vstring is
   begin
      return Vstr (From);
   end "+";

   function "+" (From : Character) return Vstring is
   begin
      return Vstr (From);
   end "+";

   function Convert (X : From) return To is
   begin
      return Vstr (Str (X));
   end Convert;
end Vstrings;
