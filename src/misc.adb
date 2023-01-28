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

-- TITLE  miscellaneous aflex routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION
-- NOTES contains functions used in various places throughout aflex.
-- $Header: /dc/uc/self/tmp/gnat_aflex/orig/RCS/misc.adb,v 1.1 1995/02/19 01:38:51 self Exp self $
--
-- 2004/10/16 Thierry Bernier
-- + Add support for Ada95 parent/child units
-- + Less GNAT warnings

with Ada.Characters.Handling;
with Ada.Strings.Fixed;
with Misc, Main_Body, Int_Io, Calendar;
with Ascan_DFA;

package body Misc is

   -- action_out - write the actions from the temporary file to lex.yy.c
   Unitname_Defined : Boolean := False;
   Unitname_Value   : Vstring;
   Lex_Filename     : Vstring;
   YYDecl_Name      : Vstring;
   YYVar_Name       : Vstring;

   procedure Action_Out is
      Buf : Vstring;
   begin
      while not Text_Io.End_Of_File (Temp_Action_File) loop
         Tstring.Get_Line (Temp_Action_File, Buf);
         if
           ((Tstring.Len (Buf) >= 2)
            and then ((Char (Buf, 1) = '%') and (Char (Buf, 2) = '%')))
         then
            exit;
         else
            Tstring.Put_Line (Buf);
         end if;
      end loop;
   end Action_Out;

   -- bubble - bubble sort an integer array in increasing order
   --
   -- description
   --   sorts the first n elements of array v and replaces them in
   --   increasing order.
   --
   -- passed
   --   v - the array to be sorted
   --   n - the number of elements of 'v' to be sorted

   procedure Bubble (V : in Int_Ptr; N : in Integer) is
      K : Integer;
   begin
      for I in reverse 2 .. N loop
         for J in 1 .. I - 1 loop
            if V (J) > V (J + 1) then

               -- compare
               K := V (J);

               -- exchange
               V (J)     := V (J + 1);
               V (J + 1) := K;
            end if;
         end loop;
      end loop;
   end Bubble;

   -- clower - replace upper-case letter to lower-case

   function Clower (C : in Integer) return Integer is
   begin
      if Isupper (Character'Val (C)) then
         return Tolower (C);
      else
         return C;
      end if;
   end Clower;

   -- cshell - shell sort a character array in increasing order
   --
   -- description
   --   does a shell sort of the first n elements of array v.
   --
   -- passed
   --   v - array to be sorted
   --   n - number of elements of v to be sorted

   procedure Cshell (V : in out Char_Array; N : in Integer) is
      Gap, J, Jg  : Integer;
      K           : Character;
      Lower_Bound : constant Integer := V'First;
   begin
      Gap := N / 2;
      while Gap > 0 loop
         for I in Gap .. N - 1 loop
            J := I - Gap;
            while (J >= 0) loop
               Jg := J + Gap;

               if V (J + Lower_Bound) <= V (Jg + Lower_Bound) then
                  exit;
               end if;

               K                    := V (J + Lower_Bound);
               V (J + Lower_Bound)  := V (Jg + Lower_Bound);
               V (Jg + Lower_Bound) := K;
               J                    := J - Gap;
            end loop;
         end loop;
         Gap := Gap / 2;
      end loop;
   end Cshell;

   -- dataend - finish up a block of data declarations

   procedure Dataend is
   begin
      if Datapos > 0 then
         Dataflush;

         -- add terminator for initialization
         Text_Io.Put_Line ("       );");
         Text_Io.New_Line;

         Dataline := 0;
      end if;
   end Dataend;

   -- dataflush - flush generated data statements

   procedure Dataflush (File : in File_Type) is
   begin
      Text_Io.New_Line (File);
      Dataline := Dataline + 1;
      if Dataline >= Numdatalines then

         -- put out a blank line so that the table is grouped into
         -- large blocks that enable the user to find elements easily
         Text_Io.New_Line (File);
         Dataline := 0;
      end if;

      -- reset the number of characters written on the current line
      Datapos := 0;
   end Dataflush;

   procedure Dataflush is
   begin
      Dataflush (Current_Output);
   end Dataflush;
   -- aflex_gettime - return current time

   function Aflex_Gettime return Vstring is
      use Calendar;
      Current_Time                                            : Time;
      Current_Year                                            : Year_Number;
      Current_Month                                           : Month_Number;
      Current_Day                                             : Day_Number;
      Current_Seconds                                         : Day_Duration;
      Month_String, Hour_String, Minute_String, Second_String : Vstring;
      Hour, Minute, Second                                    : Integer;
      Seconds_Per_Hour : constant Day_Duration := 3_600.0;
   begin
      Current_Time := Clock;
      Split
        (Current_Time, Current_Year, Current_Month, Current_Day,
         Current_Seconds);
      case Current_Month is
         when 1 =>
            Month_String := Vstr ("Jan");
         when 2 =>
            Month_String := Vstr ("Feb");
         when 3 =>
            Month_String := Vstr ("Mar");
         when 4 =>
            Month_String := Vstr ("Apr");
         when 5 =>
            Month_String := Vstr ("May");
         when 6 =>
            Month_String := Vstr ("Jun");
         when 7 =>
            Month_String := Vstr ("Jul");
         when 8 =>
            Month_String := Vstr ("Aug");
         when 9 =>
            Month_String := Vstr ("Sep");
         when 10 =>
            Month_String := Vstr ("Oct");
         when 11 =>
            Month_String := Vstr ("Nov");
         when 12 =>
            Month_String := Vstr ("Dec");
      end case;

      Hour   := Integer (Current_Seconds) / Integer (Seconds_Per_Hour);
      Minute := Integer ((Current_Seconds - (Hour * Seconds_Per_Hour)) / 60);
      Second :=
        Integer (Current_Seconds - Hour * Seconds_Per_Hour - Minute * 60.0);

      if Hour >= 10 then
         Hour_String := Vstr (Integer'Image (Hour));
      else
         Hour_String := Vstr ("0" & Integer'Image (Hour));
      end if;

      if Minute >= 10 then
         Minute_String :=
           Vstr (Integer'Image (Minute) (2 .. Integer'Image (Minute)'Length));
      else
         Minute_String :=
           Vstr
             ("0" &
              Integer'Image (Minute) (2 .. Integer'Image (Minute)'Length));
      end if;

      if Second >= 10 then
         Second_String :=
           Vstr (Integer'Image (Second) (2 .. Integer'Image (Second)'Length));
      else
         Second_String :=
           Vstr
             ("0" &
              Integer'Image (Second) (2 .. Integer'Image (Second)'Length));
      end if;

      return
        Month_String & Vstr (Integer'Image (Current_Day)) & Hour_String & ":" &
        Minute_String & ":" & Second_String & Integer'Image (Current_Year);
   end Aflex_Gettime;

   -- aflexerror - report an error message and terminate
   -- overloaded function, one for vstring, one for string.
   procedure Aflexerror (Msg : in Vstring) is
   begin
      Tstring.Put (Standard_Error, "aflex: " & Msg);
      Text_Io.New_Line (Standard_Error);
      Main_Body.Aflexend (1);
   end Aflexerror;

   procedure Aflexerror (Msg : in String) is
   begin
      Text_Io.Put (Standard_Error, "aflex: " & Msg);
      Text_Io.New_Line (Standard_Error);
      Main_Body.Aflexend (1);
   end Aflexerror;

   -- aflexfatal - report a fatal error message and terminate
   -- overloaded function, one for vstring, one for string.
   procedure Aflexfatal (Msg : in Vstring) is
   begin
      Tstring.Put (Standard_Error, "aflex: fatal internal error " & Msg);
      Text_Io.New_Line (Standard_Error);
      Main_Body.Aflexend (1);
   end Aflexfatal;

   procedure Aflexfatal (Msg : in String) is
   begin
      Text_Io.Put (Standard_Error, "aflex: fatal internal error " & Msg);
      Text_Io.New_Line (Standard_Error);
      Main_Body.Aflexend (1);
   end Aflexfatal;

   -- basename - find the basename of a file
   function Basename return Vstring is
      End_Char_Pos   : Integer := Len (Infilename);
      Start_Char_Pos : Integer;
   begin
      if End_Char_Pos = 0 then
         -- if reading standard input give everything this name
         return Vstr ("aflex_yy");
      end if;

      -- find out where the end of the basename is
      while
        ((End_Char_Pos >= 1) and then (Char (Infilename, End_Char_Pos) /= '.'))
      loop
         End_Char_Pos := End_Char_Pos - 1;
      end loop;

      -- find out where the beginning of the basename is
      Start_Char_Pos := End_Char_Pos; -- start at the end of the basename
      while
        ((Start_Char_Pos > 1)
         and then (Char (Infilename, Start_Char_Pos) /= '/'))
      loop
         Start_Char_Pos := Start_Char_Pos - 1;
      end loop;

      if Char (Infilename, Start_Char_Pos) = '/' then
         Start_Char_Pos := Start_Char_Pos + 1;
      end if;

      if End_Char_Pos >= 1 then
         return Slice (Infilename, Start_Char_Pos, End_Char_Pos - 1);
      else
         return Infilename;
      end if;
   end Basename;

   procedure Set_Unitname (Str : in Vstring) is
   begin
      Unitname_Value   := Str;
      Unitname_Defined := True;
   end Set_Unitname;

   -- unitname - finds the parent unit name of the parser
   function Unitname return Vstring is
   begin
      -- if no unitname is defined, use the file name
      if not Unitname_Defined then
         return Basename & "_";
      else
         return Unitname_Value;
      end if;
   end Unitname;

   procedure Set_Option (Opt : in Vstring) is
      Option : constant String := Str (Opt);
      Pos    : constant Natural := Ada.Strings.Fixed.Index (Option, "=");
   begin
      if Pos > 0 then
         if Option (Option'First .. Pos) = "bufsize=" then
            Misc_Defs.YYBuf_Size := Natural'Value (Option (Pos + 1 .. Option'Last));
         else
            Synerr ("variable option '" & Option & "' is not recognized");
         end if;
      elsif Option = "case-sensitive" or Option = "casefull" then
         Misc_Defs.Caseins := False;
      elsif Option = "case-insensitive" or Option = "caseless" then
         Misc_Defs.Caseins := True;
      elsif Option = "debug" then
         Misc_Defs.Ddebug := True;
      elsif Option = "interactive" then
         Misc_Defs.Interactive := True;
      elsif Option = "full" then
         Misc_Defs.Useecs  := False;
         Misc_Defs.Usemecs := False;
         Misc_Defs.Fulltbl := True;
      elsif Option = "yylineno" then
         Misc_Defs.Use_Yylineno := True;
      elsif Option = "nounput" then
         Misc_Defs.No_Unput := True;
      elsif Option = "unput" then
         Misc_Defs.No_Unput := False;
      elsif Option = "nooutput" then
         Misc_Defs.No_Output := True;
      elsif Option = "output" then
         Misc_Defs.No_Output := False;
      elsif Option = "noinput" then
         Misc_Defs.No_Input := True;
      elsif Option = "input" then
         Misc_Defs.No_Input := False;
      elsif Option = "noyywrap" then
         Misc_Defs.No_YYWrap := True;
      elsif Option = "yywrap" then
         Misc_Defs.No_YYWrap := False;
      elsif Option = "reentrant" then
         Misc_Defs.Reentrant := True;
      else
         Synerr ("option '" & Option & "' is not recognized");
      end if;
   end Set_Option;

   procedure Set_YYDecl (Str : in Vstring) is
   begin
      YYDecl_Name := Str;
   end Set_YYDecl;

   procedure Set_YYVar (Str : in Vstring) is
   begin
      YYVar_Name := Str;
   end Set_YYVar;

   function Get_YYLex_Declaration return String is
      Decl : constant String := Str (YYDecl_Name);
   begin
      if Decl'Length > 0 then
         return "   " & Decl & " is";
      else
         return "";
      end if;
   end Get_YYLex_Declaration;

   function Get_YYLex_Name return String is
      use Ada.Characters.Handling;

      function Is_Alnum (C : Character) return Boolean
        is (Is_Letter (C) or else C = '_' or else Is_Digit (C));

      Decl : constant String := Str (YYDecl_Name);
      Pos1 : Natural := Decl'First;
      Pos2 : Natural;
   begin
      while Pos1 <= Decl'Last and then Is_Space (Decl (Pos1)) loop
         Pos1 := Pos1 + 1;
      end loop;
      if Pos1 + 7 >= Decl'Last or else Decl (Pos1 .. Pos1 + 7) /= "function" then
         return "";
      end if;
      Pos1 := Pos1 + 8;
      if not Is_Space (Decl (Pos1)) then
         return "";
      end if;
      while Pos1 <= Decl'Last and then Is_Space (Decl (Pos1)) loop
         Pos1 := Pos1 + 1;
      end loop;
      Pos2 := Pos1;
      while Pos2 <= Decl'Last and then Is_Alnum (Decl (Pos2)) loop
         Pos2 := Pos2 + 1;
      end loop;
      return Decl (Pos1 .. Pos2 - 1);
   end Get_YYLex_Name;

   function Get_YYVar_Name return String is
      Name : constant String := Str (YYVar_Name);
   begin
      if Name'Length = 0 then
         return "Context";
      else
         return Name;
      end if;
   end Get_YYVar_Name;

   -- basename - find the basename of a file
   function Package_Name return String is
      Name : String := Str (Basename);
   begin
      if Unitname_Defined then
         return Tstring.Str (Unitname_Value);
      end if;
      for I in Name'Range loop
         if Name (I) = '-' then
            Name (I) := '.';
         end if;
      end loop;
      return Name;
   end Package_Name;

   -- line_directive_out - spit out a "# line" statement

   procedure Line_Directive_Out (Output_File_Name : in File_Type) is
   begin
      if Gen_Line_Dirs then
         Text_Io.Put (Output_File_Name, "--# line ");
         Int_Io.Put (Output_File_Name, Linenum, 1);
         Text_Io.Put (Output_File_Name, " """);
         Tstring.Put (Output_File_Name, Infilename);
         Text_Io.Put_Line (Output_File_Name, """");
      end if;
   end Line_Directive_Out;

   procedure Line_Directive_Out is
   begin
      if Gen_Line_Dirs then
         Text_Io.Put ("--# line ");
         Int_Io.Put (Linenum, 1);
         Text_Io.Put (" """);
         Tstring.Put (Infilename);
         Text_Io.Put_Line ("""");
      end if;
   end Line_Directive_Out;

   -- all_upper - returns true if a string is all upper-case
   function All_Upper (Str : in Vstring) return Boolean is
   begin
      for I in 1 .. Len (Str) loop
         if (not ((Char (Str, I) >= 'A') and (Char (Str, I) <= 'Z'))) then
            return False;
         end if;
      end loop;
      return True;
   end All_Upper;

   -- all_lower - returns true if a string is all lower-case
   function All_Lower (Str : in Vstring) return Boolean is
   begin
      for I in 1 .. Len (Str) loop
         if (not ((Char (Str, I) >= 'a') and (Char (Str, I) <= 'z'))) then
            return False;
         end if;
      end loop;
      return True;
   end All_Lower;

   -- mk2data - generate a data statement for a two-dimensional array
   --
   --  generates a data statement initializing the current 2-D array to "value"

   procedure Mk2data (File : in File_Type; Value : in Integer) is
   begin

      if Datapos >= Numdataitems then
         Text_Io.Put (File, ',');
         Dataflush (File);
      end if;

      if Datapos = 0 then

         -- indent
         Text_Io.Put (File, "    ");
      else
         Text_Io.Put (File, ',');
      end if;

      Datapos := Datapos + 1;

      Int_Io.Put (File, Value, 5);
   end Mk2data;

   procedure Mk2data (Value : in Integer) is
   begin
      Mk2data (Current_Output, Value);
   end Mk2data;

   --
   --  generates a data statement initializing the current array element to
   --  "value"

   procedure Mkdata (Value : in Integer) is
   begin
      if Datapos >= Numdataitems then
         Text_Io.Put (',');
         Dataflush;
      end if;

      if Datapos = 0 then

         -- indent
         Text_Io.Put ("    ");
      else
         Text_Io.Put (',');
      end if;

      Datapos := Datapos + 1;

      Int_Io.Put (Value, 5);
   end Mkdata;

   -- myctoi - return the integer represented by a string of digits

   function Myctoi (Num_Array : in Vstring) return Integer is
      Total : Integer := 0;
      Cnt   : Integer := Tstring.First;
   begin
      while (Cnt <= Tstring.Len (Num_Array)) loop
         Total := Total * 10;
         Total :=
           Total + Character'Pos (Char (Num_Array, Cnt)) - Character'Pos ('0');
         Cnt := Cnt + 1;
      end loop;
      return Total;
   end Myctoi;

   -- myesc - return character corresponding to escape sequence

   function Myesc (Arr : in Vstring) return Character is
   begin
      case (Char (Arr, Tstring.First + 1)) is
         when 'a' =>
            return Ascii.Bel;
         when 'b' =>
            return Ascii.Bs;
         when 'f' =>
            return Ascii.Ff;
         when 'n' =>
            return Ascii.Lf;
         when 'r' =>
            return Ascii.Cr;
         when 't' =>
            return Ascii.Ht;
         when 'v' =>
            return Ascii.Vt;

         when '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' =>

            -- \<octal>
            declare
               Esc_Char : Character;
               -- SPTR        : INTEGER := TSTRING.FIRST + 1;
            begin
               Esc_Char :=
                 Otoi
                   (Tstring.Slice (Arr, Tstring.First + 1, Tstring.Len (Arr)));
               if Esc_Char = Ascii.Nul then
                  Misc.Synerr ("escape sequence for null not allowed");
                  return Ascii.Soh;
               end if;

               return Esc_Char;
            end;
         when others =>
            return Char (Arr, Tstring.First + 1);
      end case;
   end Myesc;

   -- otoi - convert an octal digit string to an integer value

   function Otoi (Str : in Vstring) return Character is
      Total : Integer := 0;
      Cnt   : Integer := Tstring.First;
   begin
      while (Cnt <= Tstring.Len (Str)) loop
         Total := Total * 8;
         Total :=
           Total + Character'Pos (Char (Str, Cnt)) - Character'Pos ('0');
         Cnt := Cnt + 1;
      end loop;
      return Character'Val (Total);
   end Otoi;

   -- readable_form - return the the human-readable form of a character
   --
   -- The returned string is in static storage.

   function Readable_Form (C : in Character) return Vstring is
   begin
      if
        ((Character'Pos (C) >= 0 and Character'Pos (C) < 32) or
         (C = Ascii.Del))
      then
         case C is
            when Ascii.Lf =>
               return (Vstr ("\n"));

               -- Newline
            when Ascii.Ht =>
               return (Vstr ("\t"));

               -- Horizontal Tab
            when Ascii.Ff =>
               return (Vstr ("\f"));

               -- Form Feed
            when Ascii.Cr =>
               return (Vstr ("\r"));

               -- Carriage Return
            when Ascii.Bs =>
               return (Vstr ("\b"));

               -- Backspace
            when others =>
               return Vstr ("\" & Integer'Image (Character'Pos (C)));
         end case;
      elsif C = ' ' then
         return Vstr ("' '");
      else
         return Vstr (C);
      end if;
   end Readable_Form;

   -- transition_struct_out - output a yy_trans_info structure
   --
   -- outputs the yy_trans_info structure with the two elements, element_v and
   -- element_n.  Formats the output with spaces and carriage returns.

   procedure Transition_Struct_Out (Element_V, Element_N : in Integer) is
   begin
      Int_Io.Put (Element_V, 7);
      Text_Io.Put (", ");
      Int_Io.Put (Element_N, 5);
      Text_Io.Put (",");
      Datapos := Datapos + Trans_Struct_Print_Length;

      if Datapos >= 75 then
         Text_Io.New_Line;

         Dataline := Dataline + 1;
         if Dataline mod 10 = 0 then
            Text_Io.New_Line;
         end if;

         Datapos := 0;
      end if;
   end Transition_Struct_Out;

   function Set_Yy_Trailing_Head_Mask (Src : in Integer) return Integer is
   begin
      if Check_Yy_Trailing_Head_Mask (Src) = 0 then
         return Src + Yy_Trailing_Head_Mask;
      else
         return Src;
      end if;
   end Set_Yy_Trailing_Head_Mask;

   function Check_Yy_Trailing_Head_Mask (Src : in Integer) return Integer is
   begin
      if Src >= Yy_Trailing_Head_Mask then
         return Yy_Trailing_Head_Mask;
      else
         return 0;
      end if;
   end Check_Yy_Trailing_Head_Mask;

   function Set_Yy_Trailing_Mask (Src : in Integer) return Integer is
   begin
      if Check_Yy_Trailing_Mask (Src) = 0 then
         return Src + Yy_Trailing_Mask;
      else
         return Src;
      end if;
   end Set_Yy_Trailing_Mask;

   function Check_Yy_Trailing_Mask (Src : in Integer) return Integer is
   begin

-- this test is whether both bits are on, or whether onlyy TRAIL_MASK is set
      if
        ((Src >= Yy_Trailing_Head_Mask + Yy_Trailing_Mask) or
         ((Check_Yy_Trailing_Head_Mask (Src) = 0) and
          (Src >= Yy_Trailing_Mask)))
      then
         return Yy_Trailing_Mask;
      else
         return 0;
      end if;
   end Check_Yy_Trailing_Mask;

   function Islower (C : in Character) return Boolean is
   begin
      return C in 'a' .. 'z';
   end Islower;

   function Isupper (C : in Character) return Boolean is
   begin
      return C in 'A' .. 'Z';
   end Isupper;

   function Isdigit (C : in Character) return Boolean is
   begin
      return C in '0' .. '9';
   end Isdigit;

   function Tolower (C : in Integer) return Integer is
   begin
      return C - Character'Pos ('A') + Character'Pos ('a');
   end Tolower;

   procedure Synerr (Str : in String) is
   begin
      Syntaxerror := True;
      Put (Standard_Error, Lex_Filename);
      Text_Io.Put (Standard_Error, ":");
      --  Old Linenum is not reliable and wrong in most cases.
      --  Put (Standard_Error, Integer'Image (Linenum));
      --  Text_IO.Put (Standard_Error, ":");
      Put (Standard_Error, Integer'Image (Ascan_DFA.YYlineno));
      Text_Io.Put (Standard_Error, ": syntax error: ");
      Text_Io.Put (Standard_Error, Str);
      Text_Io.New_Line (Standard_Error);
   end Synerr;

   procedure Set_Filename (Str : in Vstring) is
   begin
      Lex_Filename := Str;
   end Set_Filename;

end Misc;
