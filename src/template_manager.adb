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

-- TITLE template manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION supports output of internalized templates for the IO and DFA
--             packages.
-- NOTES This package is quite a memory hog, and is really only useful on
--       virtual memory systems.  It could use an external file to store the
--       templates like the skeleton manager.  This would save memory at the
--       cost of a slight reduction in speed and the necessity of keeping
--       copies of the template files in a known place.
-- $Header: /dc/uc/self/arcadia/aflex/ada/src/RCS/template_managerB.a,v 1.21 1992/12/29 22:46:15 self Exp self $

--  6-Aug-2008 GdM : Added Input_Line
-- 26-Dec-2006 GdM : Added Output_Column and Output_New_Line

with File_String, Misc_Defs, Text_Io, External_File_Manager, Misc;
use File_String, Misc_Defs, Text_Io;
package body Template_Manager is

   type File_Array is array (Positive range <>) of Vstring;

   Dfa_Template : constant File_Array :=
     (
   --DFA TEMPLATE START
   Vstr
        ("   yytext_ptr        : Integer; --  points to start of yytext in buffer"),
      Vstr (""),
      Vstr
        ("   --  yy_ch_buf has to be 2 characters longer than YY_BUF_SIZE because we need"),
      Vstr
        ("   --  to put in 2 end-of-buffer characters (this is explained where it is"),
      Vstr ("   --  done) at the end of yy_ch_buf"), Vstr (""),
      Vstr
        ("   --  ----------------------------------------------------------------------------"),
      Vstr
        ("   --  If the buffer size variable YY_READ_BUF_SIZE is too small, then"),
      Vstr ("   --  big comments won't be parsed and the parser stops."),
      Vstr
        ("   --  YY_READ_BUF_SIZE should be at least as large as the number of ASCII bytes in"),
      Vstr ("   --  comments that need to be parsed."), Vstr (""),
      Vstr ("   YY_READ_BUF_SIZE : constant Integer :=  75_000;"),
      Vstr
        ("   --  ----------------------------------------------------------------------------"),
      Vstr (""),
      Vstr
        ("   YY_BUF_SIZE : constant Integer := YY_READ_BUF_SIZE * 2; --  size of input buffer"),
      Vstr (""),
      Vstr
        ("   type unbounded_character_array is array (Integer range <>) of Character;"),
      Vstr
        ("   subtype ch_buf_type is unbounded_character_array (0 .. YY_BUF_SIZE + 1);"),
      Vstr (""), Vstr ("   yy_ch_buf    : ch_buf_type;"),
      Vstr ("   yy_cp, yy_bp : Integer;"), Vstr (""),
      Vstr
        ("   --  yy_hold_char holds the character lost when yytext is formed"),
      Vstr ("   yy_hold_char : Character;"),
      Vstr
        ("   yy_c_buf_p   : Integer;   --  points to current character in buffer"),
      Vstr (""), Vstr ("   function YYText return String;"),
      Vstr ("   function YYLength return Integer;"),
      Vstr ("   procedure YY_DO_BEFORE_ACTION;"), Vstr (""),
      Vstr ("   subtype yy_state_type is Integer;"), Vstr (""),
      Vstr ("   --  These variables are needed between calls to YYLex."),
      Vstr
        ("   yy_init                 : Boolean := True; --  do we need to initialize YYLex?"),
      Vstr
        ("   yy_start                : Integer := 0; --  current start state number"),
      Vstr ("   yy_last_accepting_state : yy_state_type;"),
      Vstr ("   yy_last_accepting_cpos  : Integer;"), Vstr (""), Vstr ("%%"),

   --  Package Body:

      Vstr (""),
      Vstr ("   --  Nov 2002. Fixed insufficient buffer size bug causing"),
      Vstr ("   --  damage to comments at about the 1000-th character"),
      Vstr (""), Vstr ("   function YYText return String is"),
      Vstr ("      J : Integer := yytext_ptr;"), Vstr ("   begin"),
      Vstr
        ("      while J <= yy_ch_buf'Last and then yy_ch_buf (J) /= ASCII.NUL loop"),
      Vstr ("         J := J + 1;"), Vstr ("      end loop;"), Vstr (""),
      Vstr ("      declare"),
      Vstr ("         subtype Sliding_Type is String (1 .. J - yytext_ptr);"),
      Vstr ("      begin"),
      Vstr ("         return Sliding_Type (yy_ch_buf (yytext_ptr .. J - 1));"),
      Vstr ("      end;"), Vstr ("   end YYText;"), Vstr (""),
      Vstr ("   --  Returns the length of the matched text"), Vstr (""),
      Vstr ("   function YYLength return Integer is"), Vstr ("   begin"),
      Vstr ("      return yy_cp - yy_bp;"), Vstr ("   end YYLength;"),
      Vstr (""),
      Vstr
        ("   --  Done after the current pattern has been matched and before the"),
      Vstr ("   --  corresponding action - sets up yytext"), Vstr (""),
      Vstr ("   procedure YY_DO_BEFORE_ACTION is"), Vstr ("   begin"),
      Vstr ("      yytext_ptr := yy_bp;"),
      Vstr ("      yy_hold_char := yy_ch_buf (yy_cp);"),
      Vstr ("      yy_ch_buf (yy_cp) := ASCII.NUL;"),
      Vstr ("      yy_c_buf_p := yy_cp;"),
      Vstr ("   end YY_DO_BEFORE_ACTION;"), Vstr ("")
--DFA TEMPLATE END
      );

--  VSTR("function YYText return string is"),
--  VSTR("    i : Integer;"),
--  VSTR("    str_loc : Integer := 1;"),
--  VSTR("    buffer : String (1..1024);"),
--  VSTR("    EMPTY_STRING : constant String := """";"),
--  VSTR("begin"),
--  VSTR("   -- find end of buffer"),
--  VSTR("   i := yytext_ptr;"),
--  VSTR("   while yy_ch_buf (i) /= ASCII.NUL loop"),
--  VSTR("      buffer (str_loc) := yy_ch_buf (i);"),
--  VSTR("      i := i + 1;"),
--  VSTR("      str_loc := str_loc + 1;"),
--  VSTR("   end loop;"),
--  VSTR("--    return yy_ch_buf(yytext_ptr.. i - 1);"),
--  VSTR(""),
--  VSTR("   if str_loc < 2 then"),
--  VSTR("      return EMPTY_STRING;"),
--  VSTR("   else"),
--  VSTR("      return buffer (1 .. str_loc - 1);"),
--  VSTR("   end if;"),

   Dfa_Current_Line : Integer := 1;

   Io_Template : constant File_Array :=
     (
   --IO TEMPLATE START
   Vstr ("with Text_IO; use Text_IO;"), Vstr (""), Vstr ("%%"), Vstr (""),
      Vstr ("   user_input_file       : File_Type;"),
      Vstr ("   user_output_file      : File_Type;"),
      Vstr ("   NULL_IN_INPUT         : exception;"),
      Vstr ("   AFLEX_INTERNAL_ERROR  : exception;"),
      Vstr ("   UNEXPECTED_LAST_MATCH : exception;"),
      Vstr ("   PUSHBACK_OVERFLOW     : exception;"),
      Vstr ("   AFLEX_SCANNER_JAMMED  : exception;"),
      Vstr ("   type eob_action_type is (EOB_ACT_RESTART_SCAN,"),
      Vstr ("                            EOB_ACT_END_OF_FILE,"),
      Vstr ("                            EOB_ACT_LAST_MATCH);"),
      Vstr ("   YY_END_OF_BUFFER_CHAR : constant Character := ASCII.NUL;"),
      Vstr
        ("   yy_n_chars            : Integer;       --  number of characters read into yy_ch_buf"),
      Vstr (""),
      Vstr ("   --  true when we've seen an EOF for the current input file"),
      Vstr ("   yy_eof_has_been_seen  : Boolean;"), Vstr (""),
      Vstr ("-- UMASS CODES :"),
      Vstr ("   --   In order to support YY_Get_Token_Line, we need"),
      Vstr ("   --   a variable to hold current line."),
      Vstr ("   type String_Ptr is access String;"),
      Vstr ("   Saved_Tok_Line1 : String_Ptr := Null;"),
      Vstr ("   Line_Number_Of_Saved_Tok_Line1 : Integer := 0;"),
      Vstr ("   Saved_Tok_Line2 : String_Ptr := Null;"),
      Vstr ("   Line_Number_Of_Saved_Tok_Line2 : Integer := 0;"),
      Vstr ("   -- Aflex will try to get next buffer before it processs the"),
      Vstr ("   -- last token. Since now Aflex has been changed to accept"),
      Vstr ("   -- one line by one line, the last token in the buffer is"),
      Vstr ("   -- always end_of_line ( or end_of_buffer ). So before the"),
      Vstr ("   -- end_of_line is processed, next line will be retrieved"),
      Vstr ("   -- into the buffer. So we need to maintain two lines,"),
      Vstr ("   -- which line will be returned in Get_Token_Line is"),
      Vstr ("   -- determined according to the line number. It is the same"),
      Vstr ("   -- reason that we can not reinitialize tok_end_col to 0 in"),
      Vstr ("   -- Yy_Input, but we must do it in yylex after we process the"),
      Vstr ("   -- end_of_line."), Vstr ("   Tok_Begin_Line : Integer := 1;"),
      Vstr ("   Tok_End_Line   : Integer := 1;"),
      Vstr ("   Tok_End_Col    : Integer := 0;"),
      Vstr ("   Tok_Begin_Col  : Integer := 0;"),
      Vstr ("   Token_At_End_Of_Line : Boolean := False;"),
      Vstr
        ("   -- Indicates whether or not last matched token is end_of_line."),
      Vstr ("-- END OF UMASS CODES."), Vstr (""),
      Vstr
        ("   procedure YY_INPUT (buf      : out unbounded_character_array;"),
      Vstr ("                       result   : out Integer;"),
      Vstr ("                       max_size : in Integer);"),
      Vstr ("   function yy_get_next_buffer return eob_action_type;"),
      Vstr ("   procedure yyUnput (c : Character; yy_bp : in out Integer);"),
      Vstr ("   procedure Unput (c : Character);"),
      Vstr ("   function Input return Character;"),
      Vstr ("   procedure Output (c : Character);"),
      Vstr ("   procedure Output_New_Line;"),
      Vstr ("   function Output_Column return Text_IO.Count;"),
      Vstr ("   function yyWrap return Boolean;"),
      Vstr ("   procedure Open_Input (fname : in String);"),
      Vstr ("   procedure Close_Input;"),
      Vstr ("   procedure Create_Output (fname : in String := """");"),
      Vstr ("   procedure Close_Output;"), Vstr (""),
      Vstr ("-- UMASS CODES :"),
      Vstr ("   procedure Yy_Get_Token_Line ( Yy_Line_String : out String;"),
      Vstr
        ("                                 Yy_Line_Length : out Natural );"),
      Vstr
        ("   --  Returnes the entire line in the input, on which the currently"),
      Vstr ("   --  matched token resides."), Vstr (""),
      Vstr ("   function Yy_Line_Number return Natural;"),
      Vstr ("   --  Returns the line number of the currently matched token."),
      Vstr
        ("   --  In case a token spans lines, then the line number of the first line"),
      Vstr ("   --  is returned."), Vstr (""),
      Vstr ("   function Yy_Begin_Column return Natural;"),
      Vstr ("   function Yy_End_Column return Natural;"),
      Vstr ("   --  Returns the beginning and ending column positions of the"),
      Vstr
        ("   --  currently mathched token. If the token spans lines then the"),
      Vstr
        ("   --  begin column number is the column number on the first line"),
      Vstr
        ("   --  and the end columne number is the column number on the last line."),
      Vstr (""), Vstr ("-- END OF UMASS CODES."), Vstr (""), Vstr ("%%"),
      Vstr (""),
      Vstr
        ("   --  gets input and stuffs it into 'buf'.  number of characters read, or YY_NULL,"),
      Vstr ("   --  is returned in 'result'."), Vstr (""),
      Vstr
        ("   procedure YY_INPUT (buf      : out unbounded_character_array;"),
      Vstr ("                       result   : out Integer;"),
      Vstr ("                       max_size : in Integer) is"),
      Vstr ("      c   : Character;"), Vstr ("      i   : Integer := 1;"),
      Vstr ("      loc : Integer := buf'First;"), Vstr ("-- UMASS CODES :"),
      Vstr ("   --    Since buf is an out parameter which is not readable"),
      Vstr ("   --    and saved lines is a string pointer which space must"),
      Vstr ("   --    be allocated after we know the size, we maintain"),
      Vstr ("   --    an extra buffer to collect the input line and"),
      Vstr ("   --    save it into the saved line 2."),
      Vstr ("      Temp_Line : String (1 .. YY_BUF_SIZE + 2);"),
      Vstr ("-- END OF UMASS CODES."), Vstr ("   begin"),
      Vstr ("-- UMASS CODES :"),
      Vstr
        ("      -- buf := ( others => ASCII.NUL ); -- CvdL: does not work in GNAT"),
      Vstr ("      for j in buf'First .. buf'Last loop"),
      Vstr ("         buf (j) := ASCII.NUL;"), Vstr ("      end loop;"),
      Vstr ("      -- Move the saved lines forward."),
      Vstr ("      Saved_Tok_Line1 := Saved_Tok_Line2;"),
      Vstr
        ("      Line_Number_Of_Saved_Tok_Line1 := Line_Number_Of_Saved_Tok_Line2;"),
      Vstr ("-- END OF UMASS CODES."), Vstr (""),
      Vstr ("      if Text_IO.Is_Open (user_input_file) then"),
      Vstr ("         while i <= max_size loop"),
      Vstr ("            --  Ada ate our newline, put it back on the end."),
      Vstr ("            if Text_IO.End_Of_Line (user_input_file) then"),
      Vstr ("               buf (loc) := ASCII.LF;"),
      Vstr ("               Text_IO.Skip_Line (user_input_file, 1);"),
      Vstr ("-- UMASS CODES :"),
      Vstr
        ("               --   We try to get one line by one line. So we return"),
      Vstr ("               --   here because we saw the end_of_line."),
      Vstr ("               result := i;"),
      Vstr ("               Temp_Line (i) := ASCII.LF;"),
      Vstr ("               Saved_Tok_Line2 := new String (1 .. i);"),
      Vstr ("               Saved_Tok_Line2 (1 .. i) := Temp_Line (1 .. i);"),
      Vstr
        ("               Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
      Vstr ("               return;"), Vstr ("-- END OF UMASS CODES."),
      Vstr ("            else"),
      Vstr ("               --  UCI CODES CHANGED:"),
      Vstr
        ("               --    The following codes are modified. Previous codes is commented out."),
      Vstr
        ("               --    The purpose of doing this is to make it possible to set Temp_Line"),
      Vstr
        ("               --    in Ayacc-extension specific codes. Definitely, we can read the character"),
      Vstr
        ("               --    into the Temp_Line and then set the buf. But Temp_Line will only"),
      Vstr
        ("               --    be used in Ayacc-extension specific codes which makes"),
      Vstr ("               --    this approach impossible."),
      Vstr ("               Text_IO.Get (user_input_file, c);"),
      Vstr ("               buf (loc) := c;"),
      Vstr ("--             Text_IO.Get (user_input_file, buf (loc));"),
      Vstr ("-- UMASS CODES :"), Vstr ("               Temp_Line (i) := c;"),
      Vstr ("-- END OF UMASS CODES."), Vstr ("            end if;"), Vstr (""),
      Vstr ("            loc := loc + 1;"), Vstr ("            i := i + 1;"),
      Vstr ("         end loop;"), Vstr ("      else"),
      Vstr ("         while i <= max_size loop"),
      Vstr
        ("            if Text_IO.End_Of_Line then -- Ada ate our newline, put it back on the end."),
      Vstr ("               buf (loc) := ASCII.LF;"),
      Vstr ("               Text_IO.Skip_Line (1);"),
      Vstr ("-- UMASS CODES :"),
      Vstr
        ("               --   We try to get one line by one line. So we return"),
      Vstr ("               --   here because we saw the end_of_line."),
      Vstr ("               result := i;"),
      Vstr ("               Temp_Line (i) := ASCII.LF;"),
      Vstr ("               Saved_Tok_Line2 := new String (1 .. i);"),
      Vstr ("               Saved_Tok_Line2 (1 .. i) := Temp_Line (1 .. i);"),
      Vstr
        ("               Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
      Vstr ("               return;"), Vstr ("-- END OF UMASS CODES."),
      Vstr ("%%"), Vstr (""), Vstr ("            else"),
      Vstr
        ("               --  The following codes are modified. Previous codes is commented out."),
      Vstr
        ("               --  The purpose of doing this is to make it possible to set Temp_Line"),
      Vstr
        ("               --  in Ayacc-extension specific codes. Definitely, we can read the character"),
      Vstr
        ("               --  into the Temp_Line and then set the buf. But Temp_Line will only"),
      Vstr
        ("               --  be used in Ayacc-extension specific codes which makes this approach impossible."),
      Vstr ("               Text_IO.Get (c);"),
      Vstr ("               buf (loc) := c;"),
      Vstr ("               --         get (buf (loc));"),
      Vstr ("-- UMASS CODES :"), Vstr ("               Temp_Line (i) := c;"),
      Vstr ("-- END OF UMASS CODES."), Vstr ("            end if;"), Vstr (""),
      Vstr ("            loc := loc + 1;"), Vstr ("            i := i + 1;"),
      Vstr ("         end loop;"),
      Vstr ("      end if; --  for input file being standard input"),
      Vstr ("      result := i - 1;"), Vstr (""), Vstr ("-- UMASS CODES :"),
      Vstr ("      --  Since we get one line by one line, if we"),
      Vstr ("      --  reach here, it means that current line have"),
      Vstr ("      --  more that max_size characters. So it is"),
      Vstr ("      --  impossible to hold the whole line. We"),
      Vstr ("      --  report the warning message and continue."),
      Vstr ("      buf (loc - 1) := Ascii.LF;"),
      Vstr ("      if Text_IO.Is_Open (user_input_file) then"),
      Vstr ("         Text_IO.Skip_Line (user_input_file, 1);"),
      Vstr ("      else"), Vstr ("         Text_IO.Skip_Line (1);"),
      Vstr ("      end if;"), Vstr ("      Temp_Line (i - 1) := ASCII.LF;"),
      Vstr ("      Saved_Tok_Line2 := new String (1 .. i - 1);"),
      Vstr ("      Saved_Tok_Line2 (1 .. i - 1) := Temp_Line (1 .. i - 1);"),
      Vstr
        ("      Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
      Vstr ("      Put_Line (""Input line """),
      Vstr
        ("                & Integer'Image ( Line_Number_Of_Saved_Tok_Line2 )"),
      Vstr ("                & ""has more than """),
      Vstr ("                & Integer'Image ( max_size )"),
      Vstr ("                & "" characters, ... truncated."" );"),
      Vstr ("-- END OF UMASS CODES."), Vstr ("   exception"),
      Vstr ("      when Text_IO.End_Error =>"),
      Vstr ("         result := i - 1;"),
      Vstr
        ("         --  when we hit EOF we need to set yy_eof_has_been_seen"),
      Vstr ("         yy_eof_has_been_seen := True;"),
      Vstr ("-- UMASS CODES :"),
      Vstr ("         --   Processing incomplete line."),
      Vstr ("         if i /= 1 then"),
      Vstr
        ("            -- Current line is not empty but do not have end_of_line."),
      Vstr
        ("            -- So current line is incomplete line. But we still need"),
      Vstr ("            -- to save it."),
      Vstr ("            Saved_Tok_Line2 := new String (1 .. i - 1);"),
      Vstr
        ("            Saved_Tok_Line2 (1 .. i - 1) := Temp_Line (1 .. i - 1);"),
      Vstr
        ("            Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
      Vstr ("         end if;"), Vstr ("-- END OF UMASS CODES."),
      Vstr ("   end YY_INPUT;"), Vstr (""),
      Vstr ("   --  yy_get_next_buffer - try to read in new buffer"),
      Vstr ("   --"), Vstr ("   --  returns a code representing an action"),
      Vstr ("   --     EOB_ACT_LAST_MATCH -"),
      Vstr ("   --     EOB_ACT_RESTART_SCAN - restart the scanner"),
      Vstr ("   --     EOB_ACT_END_OF_FILE - end of file"), Vstr (""),
      Vstr ("   function yy_get_next_buffer return eob_action_type is"),
      Vstr ("      dest           : Integer := 0;"),
      Vstr
        ("      source         : Integer := yytext_ptr - 1; -- copy prev. char, too"),
      Vstr ("      number_to_move : Integer;"),
      Vstr ("      ret_val        : eob_action_type;"),
      Vstr ("      num_to_read    : Integer;"), Vstr ("   begin"),
      Vstr ("      if yy_c_buf_p > yy_n_chars + 1 then"),
      Vstr ("         raise NULL_IN_INPUT;"), Vstr ("      end if;"),
      Vstr (""), Vstr ("      --  try to read more data"), Vstr (""),
      Vstr ("      --  first move last chars to start of buffer"),
      Vstr ("      number_to_move := yy_c_buf_p - yytext_ptr;"), Vstr (""),
      Vstr ("      for i in 0 .. number_to_move - 1 loop"),
      Vstr ("         yy_ch_buf (dest) := yy_ch_buf (source);"),
      Vstr ("         dest := dest + 1;"),
      Vstr ("         source := source + 1;"), Vstr ("      end loop;"),
      Vstr (""), Vstr ("      if yy_eof_has_been_seen then"),
      Vstr
        ("         --  don't do the read, it's not guaranteed to return an EOF,"),
      Vstr ("         --  just force an EOF"), Vstr (""),
      Vstr ("         yy_n_chars := 0;"), Vstr ("      else"),
      Vstr ("         num_to_read := YY_BUF_SIZE - number_to_move - 1;"),
      Vstr (""), Vstr ("         if num_to_read > YY_READ_BUF_SIZE then"),
      Vstr ("            num_to_read := YY_READ_BUF_SIZE;"),
      Vstr ("         end if;"), Vstr (""),
      Vstr ("         --  read in more data"),
      Vstr
        ("         YY_INPUT (yy_ch_buf (number_to_move .. yy_ch_buf'Last), yy_n_chars, num_to_read);"),
      Vstr ("      end if;"), Vstr ("      if yy_n_chars = 0 then"),
      Vstr ("         if number_to_move = 1 then"),
      Vstr ("            ret_val := EOB_ACT_END_OF_FILE;"),
      Vstr ("         else"),
      Vstr ("            ret_val := EOB_ACT_LAST_MATCH;"),
      Vstr ("         end if;"), Vstr (""),
      Vstr ("         yy_eof_has_been_seen := True;"), Vstr ("      else"),
      Vstr ("         ret_val := EOB_ACT_RESTART_SCAN;"),
      Vstr ("      end if;"), Vstr (""),
      Vstr ("      yy_n_chars := yy_n_chars + number_to_move;"),
      Vstr ("      yy_ch_buf (yy_n_chars) := YY_END_OF_BUFFER_CHAR;"),
      Vstr ("      yy_ch_buf (yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;"),
      Vstr (""), Vstr ("      --  yytext begins at the second character in"),
      Vstr ("      --  yy_ch_buf; the first character is the one which"),
      Vstr ("      --  preceded it before reading in the latest buffer;"),
      Vstr ("      --  it needs to be kept around in case it's a"),
      Vstr ("      --  newline, so yy_get_previous_state() will have"),
      Vstr ("      --  with '^' rules active"), Vstr (""),
      Vstr ("      yytext_ptr := 1;"), Vstr (""),
      Vstr ("      return ret_val;"), Vstr ("   end yy_get_next_buffer;"),
      Vstr (""),
      Vstr ("   procedure yyUnput (c : Character; yy_bp : in out Integer) is"),
      Vstr ("      number_to_move : Integer;"), Vstr ("      dest : Integer;"),
      Vstr ("      source : Integer;"), Vstr ("      tmp_yy_cp : Integer;"),
      Vstr ("   begin"), Vstr ("      tmp_yy_cp := yy_c_buf_p;"),
      Vstr
        ("      yy_ch_buf (tmp_yy_cp) := yy_hold_char; --  undo effects of setting up yytext"),
      Vstr (""), Vstr ("      if tmp_yy_cp < 2 then"),
      Vstr ("         --  need to shift things up to make room"),
      Vstr ("         number_to_move := yy_n_chars + 2; --  +2 for EOB chars"),
      Vstr ("         dest := YY_BUF_SIZE + 2;"),
      Vstr ("         source := number_to_move;"), Vstr (""),
      Vstr ("         while source > 0 loop"),
      Vstr ("            dest := dest - 1;"),
      Vstr ("            source := source - 1;"),
      Vstr ("            yy_ch_buf (dest) := yy_ch_buf (source);"),
      Vstr ("         end loop;"), Vstr (""),
      Vstr ("         tmp_yy_cp := tmp_yy_cp + dest - source;"),
      Vstr ("         yy_bp := yy_bp + dest - source;"),
      Vstr ("         yy_n_chars := YY_BUF_SIZE;"), Vstr (""),
      Vstr ("         if tmp_yy_cp < 2 then"),
      Vstr ("            raise PUSHBACK_OVERFLOW;"), Vstr ("         end if;"),
      Vstr ("      end if;"), Vstr (""),
      Vstr
        ("      if tmp_yy_cp > yy_bp and then yy_ch_buf (tmp_yy_cp - 1) = ASCII.LF then"),
      Vstr ("         yy_ch_buf (tmp_yy_cp - 2) := ASCII.LF;"),
      Vstr ("      end if;"), Vstr (""),
      Vstr ("      tmp_yy_cp := tmp_yy_cp - 1;"),
      Vstr ("      yy_ch_buf (tmp_yy_cp) := c;"), Vstr (""),
      Vstr
        ("      --  Note:  this code is the text of YY_DO_BEFORE_ACTION, only"),
      Vstr ("      --         here we get different yy_cp and yy_bp's"),
      Vstr ("      yytext_ptr := yy_bp;"),
      Vstr ("      yy_hold_char := yy_ch_buf (tmp_yy_cp);"),
      Vstr ("      yy_ch_buf (tmp_yy_cp) := ASCII.NUL;"),
      Vstr ("      yy_c_buf_p := tmp_yy_cp;"), Vstr ("   end yyUnput;"),
      Vstr (""), Vstr ("   procedure Unput (c : Character) is"),
      Vstr ("   begin"), Vstr ("      yyUnput (c, yy_bp);"),
      Vstr ("   end Unput;"), Vstr (""),
      Vstr ("   function Input return Character is"),
      Vstr ("      c : Character;"), Vstr ("   begin"),
      Vstr ("      yy_ch_buf (yy_c_buf_p) := yy_hold_char;"), Vstr (""),
      Vstr ("      if yy_ch_buf (yy_c_buf_p) = YY_END_OF_BUFFER_CHAR then"),
      Vstr ("         --  need more input"),
      Vstr ("         yytext_ptr := yy_c_buf_p;"),
      Vstr ("         yy_c_buf_p := yy_c_buf_p + 1;"), Vstr (""),
      Vstr ("         case yy_get_next_buffer is"),
      Vstr
        ("            --  this code, unfortunately, is somewhat redundant with"),
      Vstr ("            --  that above"), Vstr (""),
      Vstr ("         when EOB_ACT_END_OF_FILE =>"),
      Vstr ("            if yyWrap then"),
      Vstr ("               yy_c_buf_p := yytext_ptr;"),
      Vstr ("               return ASCII.NUL;"), Vstr ("            end if;"),
      Vstr (""), Vstr ("            yy_ch_buf (0) := ASCII.LF;"),
      Vstr ("            yy_n_chars := 1;"),
      Vstr ("            yy_ch_buf (yy_n_chars) := YY_END_OF_BUFFER_CHAR;"),
      Vstr
        ("            yy_ch_buf (yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;"),
      Vstr ("            yy_eof_has_been_seen := False;"),
      Vstr ("            yy_c_buf_p := 1;"),
      Vstr ("            yytext_ptr := yy_c_buf_p;"),
      Vstr ("            yy_hold_char := yy_ch_buf (yy_c_buf_p);"), Vstr (""),
      Vstr ("            return Input;"),
      Vstr ("         when EOB_ACT_RESTART_SCAN =>"),
      Vstr ("            yy_c_buf_p := yytext_ptr;"), Vstr (""),
      Vstr ("         when EOB_ACT_LAST_MATCH =>"),
      Vstr ("            raise UNEXPECTED_LAST_MATCH;"),
      Vstr ("         end case;"), Vstr ("      end if;"), Vstr (""),
      Vstr ("      c := yy_ch_buf (yy_c_buf_p);"),
      Vstr ("      yy_c_buf_p := yy_c_buf_p + 1;"),
      Vstr ("      yy_hold_char := yy_ch_buf (yy_c_buf_p);"), Vstr (""),
      Vstr ("      return c;"), Vstr ("   end Input;"), Vstr (""),
      Vstr ("   procedure Output (c : Character) is"), Vstr ("   begin"),
      Vstr ("      if Is_Open (user_output_file) then"),
      Vstr ("         Text_IO.Put (user_output_file, c);"),
      Vstr ("      else"), Vstr ("         Text_IO.Put (c);"),
      Vstr ("      end if;"), Vstr ("   end Output;"), Vstr (""),
      Vstr ("   procedure Output_New_Line is"), Vstr ("   begin"),
      Vstr ("      if Is_Open (user_output_file) then"),
      Vstr ("         Text_IO.New_Line (user_output_file);"),
      Vstr ("      else"), Vstr ("         Text_IO.New_Line;"),
      Vstr ("      end if;"), Vstr ("   end Output_New_Line;"), Vstr (""),
      Vstr ("   function Output_Column return Text_IO.Count is"),
      Vstr ("   begin"), Vstr ("      if Is_Open (user_output_file) then"),
      Vstr ("         return Text_IO.Col (user_output_file);"),
      Vstr ("      else"), Vstr ("         return Text_IO.Col;"),
      Vstr ("      end if;"), Vstr ("   end Output_Column;"), Vstr (""),
      Vstr ("   --  default yywrap function - always treat EOF as an EOF"),
      Vstr ("   function yyWrap return Boolean is"), Vstr ("   begin"),
      Vstr ("      return True;"), Vstr ("   end yyWrap;"), Vstr (""),
      Vstr ("   procedure Open_Input (fname : in String) is"),
      Vstr ("   begin"), Vstr ("      yy_init := True;"),
      Vstr ("      Open (user_input_file, Text_IO.In_File, fname);"),
      Vstr ("   end Open_Input;"), Vstr (""),
      Vstr ("   procedure Create_Output (fname : in String := """") is"),
      Vstr ("   begin"), Vstr ("      if fname /= """" then"),
      Vstr ("         Create (user_output_file, Text_IO.Out_File, fname);"),
      Vstr ("      end if;"), Vstr ("   end Create_Output;"), Vstr (""),
      Vstr ("   procedure Close_Input is"), Vstr ("   begin"),
      Vstr ("      if Is_Open (user_input_file) then"),
      Vstr ("         Text_IO.Close (user_input_file);"),
      Vstr ("      end if;"), Vstr ("   end Close_Input;"), Vstr (""),
      Vstr ("   procedure Close_Output is"), Vstr ("   begin"),
      Vstr ("      if Is_Open (user_output_file) then"),
      Vstr ("         Text_IO.Close (user_output_file);"),
      Vstr ("      end if;"), Vstr ("   end Close_Output;"), Vstr (""),
      Vstr ("-- UMASS CODES :"),
      Vstr ("   procedure Yy_Get_Token_Line ( Yy_Line_String : out String;"),
      Vstr
        ("                                 Yy_Line_Length : out Natural ) is"),
      Vstr ("   begin"),
      Vstr
        ("      --  Currently processing line is either in saved token line1 or"),
      Vstr ("      --  in saved token line2."),
      Vstr ("      if Yy_Line_Number = Line_Number_Of_Saved_Tok_Line1 then"),
      Vstr ("         Yy_Line_Length := Saved_Tok_Line1.all'length;"),
      Vstr
        ("         Yy_Line_String ( Yy_Line_String'First .. ( Yy_Line_String'First + Saved_Tok_Line1.all'length - 1 ))"),
      Vstr
        ("           := Saved_Tok_Line1 ( 1 .. Saved_Tok_Line1.all'length );"),
      Vstr ("      else"),
      Vstr ("         Yy_Line_Length := Saved_Tok_Line2.all'length;"),
      Vstr
        ("         Yy_Line_String ( Yy_Line_String'First .. ( Yy_Line_String'First + Saved_Tok_Line2.all'length - 1 ))"),
      Vstr
        ("           := Saved_Tok_Line2 ( 1 .. Saved_Tok_Line2.all'length );"),
      Vstr ("      end if;"), Vstr ("   end Yy_Get_Token_Line;"), Vstr (""),
      Vstr ("   function Yy_Line_Number return Natural is"), Vstr ("   begin"),
      Vstr ("      return Tok_Begin_Line;"), Vstr ("   end Yy_Line_Number;"),
      Vstr (""), Vstr ("   function Yy_Begin_Column return Natural is"),
      Vstr ("   begin"), Vstr ("      return Tok_Begin_Col;"),
      Vstr ("   end Yy_Begin_Column;"), Vstr (""),
      Vstr ("   function Yy_End_Column return Natural is"), Vstr ("   begin"),
      Vstr ("      return Tok_End_Col;"), Vstr ("   end Yy_End_Column;"),
      Vstr (""), Vstr ("-- END OF UMASS CODES."), Vstr ("")
--IO TEMPLATE END
      );

   Io_Current_Line : Integer := 1;

   procedure Template_Out
     (Outfile     : in     File_Type; Current_Template : in File_Array;
      Line_Number : in out Integer)
   is
      Buf : Vstring;
-- UMASS CODES :
      Umass_Codes : Boolean := False;
      -- Indicates whether or not current line of the template
      -- is the Umass codes.
-- END OF UMASS CODES.
   begin
      while not (Line_Number > Current_Template'Last) loop
         Buf         := Current_Template (Line_Number);
         Line_Number := Line_Number + 1;
         if
           ((File_String.Len (Buf) >= 2)
            and then ((Char (Buf, 1) = '%') and (Char (Buf, 2) = '%')))
         then
            exit;
         else
-- UMASS CODES :
--   In the template, the codes between "-- UMASS CODES : " and
--   "-- END OF UMASS CODES." are specific to be used by Ayacc-extension.
--   Ayacc-extension has more power in error recovery. So we
--   generate those codes only when Ayacc_Extension_Flag is True.
            if File_String.Str (Buf) = "-- UMASS CODES :" then
               Umass_Codes := True;
            end if;

            if not Umass_Codes or else Ayacc_Extension_Flag then
               File_String.Put_Line (Outfile, Buf);
            end if;

            if File_String.Str (Buf) = "-- END OF UMASS CODES." then
               Umass_Codes := False;
            end if;
-- END OF UMASS CODES.

-- UCI CODES commented out :
--   The following line is commented out because it is done in Umass codes.
--      FILE_STRING.PUT_LINE(OUTFILE,BUF);

         end if;
      end loop;
   end Template_Out;

   procedure Generate_Dfa_File is
      Dfa_Out_File : File_Type;
   begin
      External_File_Manager.Get_Dfa_File (Dfa_Out_File, True);
      --  Text_IO.PUT_LINE(DFA_OUT_FILE, "pragma Style_Checks (Off);");
      Text_Io.Put_Line
        (Dfa_Out_File,
         "--  Warning: This file is automatically generated by AFLEX.");
      Text_Io.Put_Line
        (Dfa_Out_File,
         "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
      if Private_Package then
         Text_Io.Put (Dfa_Out_File, "private ");
      end if;
      Text_Io.Put_Line
        (Dfa_Out_File, "package " & Misc.Package_Name & "_dfa is");
      Text_Io.New_Line (Dfa_Out_File);

      if Ddebug then
         -- make a scanner that output acceptance information
         Text_Io.Put_Line
           (Dfa_Out_File, "   aflex_debug       : Boolean := True;");
      else
         Text_Io.Put_Line
           (Dfa_Out_File, "   aflex_debug       : Boolean := False;");
      end if;
      if Yylineno then
         Text_Io.Put_Line
           (Dfa_Out_File, "   yylineno          : Natural := 0;");
         Text_Io.Put_Line
           (Dfa_Out_File, "   yylinecol         : Natural := 0;");
         Text_Io.Put_Line
           (Dfa_Out_File, "   yy_last_yylineno  : Natural := 0;");
         Text_Io.Put_Line
           (Dfa_Out_File, "   yy_last_yylinecol : Natural := 0;");

      end if;
      Template_Out (Dfa_Out_File, Dfa_Template, Dfa_Current_Line);
      Text_Io.Put_Line (Dfa_Out_File, "end " & Misc.Package_Name & "_dfa;");
      Text_Io.Close (Dfa_Out_File);

      External_File_Manager.Get_Dfa_File (Dfa_Out_File, False);
      Text_Io.Put_Line
        (Dfa_Out_File,
         "--  Warning: This file is automatically generated by AFLEX.");
      Text_Io.Put_Line
        (Dfa_Out_File,
         "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
      Text_Io.New_Line (Dfa_Out_File);
      --  Text_IO.PUT_LINE(DFA_OUT_FILE, "pragma Style_Checks (Off);");
      Text_Io.Put (Dfa_Out_File, "with " & Misc.Package_Name & "_dfa" & "; ");
      Text_Io.Put_Line (Dfa_Out_File, "use " & Misc.Package_Name & "_dfa;");
      Text_Io.Put_Line
        (Dfa_Out_File, "package body " & Misc.Package_Name & "_dfa is");
      Template_Out (Dfa_Out_File, Dfa_Template, Dfa_Current_Line);
      Text_Io.Put_Line (Dfa_Out_File, "end " & Misc.Package_Name & "_dfa;");
   end Generate_Dfa_File;

   procedure Generate_Io_File is
      Io_Out_File : File_Type;
   begin
      External_File_Manager.Get_Io_File (Io_Out_File, True);
      Text_Io.Put_Line
        (Io_Out_File,
         "--  Warning: This file is automatically generated by AFLEX.");
      Text_Io.Put_Line
        (Io_Out_File,
         "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
      --  Text_IO.PUT_LINE(IO_OUT_FILE, "pragma Style_Checks (Off);");
      Text_Io.Put (Io_Out_File, "with " & Misc.Package_Name & "_dfa; ");
      Text_Io.Put_Line (Io_Out_File, "use " & Misc.Package_Name & "_dfa;");
      Template_Out (Io_Out_File, Io_Template, Io_Current_Line);
      if Private_Package then
         Text_Io.Put (Io_Out_File, "private ");
      end if;
      Text_Io.Put_Line
        (Io_Out_File, "package " & Misc.Package_Name & "_io is");
      Template_Out (Io_Out_File, Io_Template, Io_Current_Line);
      Text_Io.Put_Line (Io_Out_File, "end " & Misc.Package_Name & "_io;");
      Text_Io.Close (Io_Out_File);

      External_File_Manager.Get_Io_File (Io_Out_File, False);
      Text_Io.Put_Line
        (Io_Out_File,
         "--  Warning: This file is automatically generated by AFLEX.");
      Text_Io.Put_Line
        (Io_Out_File,
         "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
      --  Text_IO.PUT_LINE(IO_OUT_FILE, "pragma Style_Checks (Off);");
      Text_Io.Put_Line
        (Io_Out_File, "package body " & Misc.Package_Name & "_io is");
      Template_Out (Io_Out_File, Io_Template, Io_Current_Line);
      -- If we're generating a scanner for interactive mode we need to generate
      -- a YY_INPUT that stops at the end of each line
      if Interactive then
         Text_Io.Put_Line
           (Io_Out_File,
            "            i := i + 1; -- update counter, miss end of loop");
         Text_Io.Put_Line
           (Io_Out_File,
            "            exit; -- in interactive mode return at end of line.");
      end if;
      Template_Out (Io_Out_File, Io_Template, Io_Current_Line);
      Text_Io.Put_Line (Io_Out_File, "end " & Misc.Package_Name & "_io;");
   end Generate_Io_File;

end Template_Manager;
