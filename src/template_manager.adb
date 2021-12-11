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

with FILE_STRING, MISC_DEFS, Text_IO, EXTERNAL_FILE_MANAGER, MISC; use
  FILE_STRING, MISC_DEFS, Text_IO;
package body TEMPLATE_MANAGER is

  type FILE_ARRAY is array(POSITIVE range <>) of VSTRING;

  DFA_TEMPLATE     : constant FILE_ARRAY := (
  --DFA TEMPLATE START
VSTR("   yytext_ptr        : Integer; --  points to start of yytext in buffer"),
VSTR(""),
VSTR("   --  yy_ch_buf has to be 2 characters longer than YY_BUF_SIZE because we need"),
VSTR("   --  to put in 2 end-of-buffer characters (this is explained where it is"),
VSTR("   --  done) at the end of yy_ch_buf"),
VSTR(""),
VSTR("   --  ----------------------------------------------------------------------------"),
VSTR("   --  If the buffer size variable YY_READ_BUF_SIZE is too small, then"),
VSTR("   --  big comments won't be parsed and the parser stops."),
VSTR("   --  YY_READ_BUF_SIZE should be at least as large as the number of ASCII bytes in"),
VSTR("   --  comments that need to be parsed."),
VSTR(""),
VSTR("   YY_READ_BUF_SIZE : constant Integer :=  75_000;"),
VSTR("   --  ----------------------------------------------------------------------------"),
VSTR(""),
VSTR("   YY_BUF_SIZE : constant Integer := YY_READ_BUF_SIZE * 2; --  size of input buffer"),
VSTR(""),
VSTR("   type unbounded_character_array is array (Integer range <>) of Character;"),
VSTR("   subtype ch_buf_type is unbounded_character_array (0 .. YY_BUF_SIZE + 1);"),
VSTR(""),
VSTR("   yy_ch_buf    : ch_buf_type;"),
VSTR("   yy_cp, yy_bp : Integer;"),
VSTR(""),
VSTR("   --  yy_hold_char holds the character lost when yytext is formed"),
VSTR("   yy_hold_char : Character;"),
VSTR("   yy_c_buf_p   : Integer;   --  points to current character in buffer"),
VSTR(""),
VSTR("   function YYText return String;"),
VSTR("   function YYLength return Integer;"),
VSTR("   procedure YY_DO_BEFORE_ACTION;"),
VSTR(""),
VSTR("   subtype yy_state_type is Integer;"),
VSTR(""),
VSTR("   --  These variables are needed between calls to YYLex."),
VSTR("   yy_init                 : Boolean := True; --  do we need to initialize YYLex?"),
VSTR("   yy_start                : Integer := 0; --  current start state number"),
VSTR("   yy_last_accepting_state : yy_state_type;"),
VSTR("   yy_last_accepting_cpos  : Integer;"),
VSTR(""),
VSTR("%%"),

   --  Package Body:

VSTR(""),
VSTR("   --  Nov 2002. Fixed insufficient buffer size bug causing"),
VSTR("   --  damage to comments at about the 1000-th character"),
VSTR(""),
VSTR("   function YYText return String is"),
VSTR("      J : Integer := yytext_ptr;"),
VSTR("   begin"),
VSTR("      while J <= yy_ch_buf'Last and then yy_ch_buf (J) /= ASCII.NUL loop"),
VSTR("         J := J + 1;"),
VSTR("      end loop;"),
VSTR(""),
VSTR("      declare"),
VSTR("         subtype Sliding_Type is String (1 .. J - yytext_ptr);"),
VSTR("      begin"),
VSTR("         return Sliding_Type (yy_ch_buf (yytext_ptr .. J - 1));"),
VSTR("      end;"),
VSTR("   end YYText;"),
VSTR(""),
VSTR("   --  Returns the length of the matched text"),
VSTR(""),
VSTR("   function YYLength return Integer is"),
VSTR("   begin"),
VSTR("      return yy_cp - yy_bp;"),
VSTR("   end YYLength;"),
VSTR(""),
VSTR("   --  Done after the current pattern has been matched and before the"),
VSTR("   --  corresponding action - sets up yytext"),
VSTR(""),
VSTR("   procedure YY_DO_BEFORE_ACTION is"),
VSTR("   begin"),
VSTR("      yytext_ptr := yy_bp;"),
VSTR("      yy_hold_char := yy_ch_buf (yy_cp);"),
VSTR("      yy_ch_buf (yy_cp) := ASCII.NUL;"),
VSTR("      yy_c_buf_p := yy_cp;"),
VSTR("   end YY_DO_BEFORE_ACTION;"),
VSTR("")
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


  DFA_CURRENT_LINE : INTEGER := 1;

  IO_TEMPLATE      : constant FILE_ARRAY := (
  --IO TEMPLATE START
VSTR("with Text_IO; use Text_IO;"),
VSTR(""),
VSTR("%%"),
VSTR(""),
VSTR("   user_input_file       : File_Type;"),
VSTR("   user_output_file      : File_Type;"),
VSTR("   NULL_IN_INPUT         : exception;"),
VSTR("   AFLEX_INTERNAL_ERROR  : exception;"),
VSTR("   UNEXPECTED_LAST_MATCH : exception;"),
VSTR("   PUSHBACK_OVERFLOW     : exception;"),
VSTR("   AFLEX_SCANNER_JAMMED  : exception;"),
VSTR("   type eob_action_type is (EOB_ACT_RESTART_SCAN,"),
VSTR("                            EOB_ACT_END_OF_FILE,"),
VSTR("                            EOB_ACT_LAST_MATCH);"),
VSTR("   YY_END_OF_BUFFER_CHAR : constant Character := ASCII.NUL;"),
VSTR("   yy_n_chars            : Integer;       --  number of characters read into yy_ch_buf"),
VSTR(""),
VSTR("   --  true when we've seen an EOF for the current input file"),
VSTR("   yy_eof_has_been_seen  : Boolean;"), VSTR(""),
VSTR("-- UMASS CODES :" ),
VSTR("   --   In order to support YY_Get_Token_Line, we need"),
VSTR("   --   a variable to hold current line."),
VSTR("   type String_Ptr is access String;"),
VSTR("   Saved_Tok_Line1 : String_Ptr := Null;"),
VSTR("   Line_Number_Of_Saved_Tok_Line1 : Integer := 0;"),
VSTR("   Saved_Tok_Line2 : String_Ptr := Null;"),
VSTR("   Line_Number_Of_Saved_Tok_Line2 : Integer := 0;"),
VSTR("   -- Aflex will try to get next buffer before it processs the"),
VSTR("   -- last token. Since now Aflex has been changed to accept"),
VSTR("   -- one line by one line, the last token in the buffer is"),
VSTR("   -- always end_of_line ( or end_of_buffer ). So before the"),
VSTR("   -- end_of_line is processed, next line will be retrieved"),
VSTR("   -- into the buffer. So we need to maintain two lines,"),
VSTR("   -- which line will be returned in Get_Token_Line is"),
VSTR("   -- determined according to the line number. It is the same"),
VSTR("   -- reason that we can not reinitialize tok_end_col to 0 in"),
VSTR("   -- Yy_Input, but we must do it in yylex after we process the"),
VSTR("   -- end_of_line."),
VSTR("   Tok_Begin_Line : Integer := 1;"),
VSTR("   Tok_End_Line   : Integer := 1;"),
VSTR("   Tok_End_Col    : Integer := 0;"),
VSTR("   Tok_Begin_Col  : Integer := 0;"),
VSTR("   Token_At_End_Of_Line : Boolean := False;"),
VSTR("   -- Indicates whether or not last matched token is end_of_line."),
VSTR("-- END OF UMASS CODES."),
VSTR(""),
VSTR("   procedure YY_INPUT (buf      : out unbounded_character_array;"),
VSTR("                       result   : out Integer;"),
VSTR("                       max_size : in Integer);"),
VSTR("   function yy_get_next_buffer return eob_action_type;"),
VSTR("   procedure yyUnput (c : Character; yy_bp : in out Integer);"),
VSTR("   procedure Unput (c : Character);"),
VSTR("   function Input return Character;"),
VSTR("   procedure Output (c : Character);"),
VSTR("   procedure Output_New_Line;"),
VSTR("   function Output_Column return Text_IO.Count;"),
VSTR("   function Input_Line return Text_IO.Count;"),
VSTR("   function yyWrap return Boolean;"),
VSTR("   procedure Open_Input (fname : in String);"),
VSTR("   procedure Close_Input;"),
VSTR("   procedure Create_Output (fname : in String := """");"),
VSTR("   procedure Close_Output;"),
VSTR(""),
VSTR("-- UMASS CODES :"),
VSTR("   procedure Yy_Get_Token_Line ( Yy_Line_String : out String;"),
VSTR("                                 Yy_Line_Length : out Natural );"),
VSTR("   --  Returnes the entire line in the input, on which the currently"),
VSTR("   --  matched token resides."),
VSTR(""),
VSTR("   function Yy_Line_Number return Natural;"),
VSTR("   --  Returns the line number of the currently matched token."),
VSTR("   --  In case a token spans lines, then the line number of the first line"),
VSTR("   --  is returned."),
VSTR(""),
VSTR("   function Yy_Begin_Column return Natural;"),
VSTR("   function Yy_End_Column return Natural;"),
VSTR("   --  Returns the beginning and ending column positions of the"),
VSTR("   --  currently mathched token. If the token spans lines then the"),
VSTR("   --  begin column number is the column number on the first line"),
VSTR("   --  and the end columne number is the column number on the last line."),
VSTR(""),
VSTR("-- END OF UMASS CODES."),
VSTR(""),
VSTR("%%"),
VSTR(""),
VSTR("   --  gets input and stuffs it into 'buf'.  number of characters read, or YY_NULL,"),
VSTR("   --  is returned in 'result'."),
VSTR(""),
VSTR("   procedure YY_INPUT (buf      : out unbounded_character_array;"),
VSTR("                       result   : out Integer;"),
VSTR("                       max_size : in Integer) is"),
VSTR("      c   : Character;"),
VSTR("      i   : Integer := 1;"),
VSTR("      loc : Integer := buf'First;"),
VSTR("-- UMASS CODES :"),
VSTR("   --    Since buf is an out parameter which is not readable"),
VSTR("   --    and saved lines is a string pointer which space must"),
VSTR("   --    be allocated after we know the size, we maintain"),
VSTR("   --    an extra buffer to collect the input line and"),
VSTR("   --    save it into the saved line 2."),
VSTR("      Temp_Line : String (1 .. YY_BUF_SIZE + 2);"),
VSTR("-- END OF UMASS CODES."),
VSTR("   begin"),
VSTR("-- UMASS CODES :"),
VSTR("      -- buf := ( others => ASCII.NUL ); -- CvdL: does not work in GNAT"),
VSTR("      for j in buf'First .. buf'Last loop"),
VSTR("         buf (j) := ASCII.NUL;"),
VSTR("      end loop;"),
VSTR("      -- Move the saved lines forward."),
VSTR("      Saved_Tok_Line1 := Saved_Tok_Line2;"),
VSTR("      Line_Number_Of_Saved_Tok_Line1 := Line_Number_Of_Saved_Tok_Line2;"),
VSTR("-- END OF UMASS CODES."),
VSTR(""),
VSTR("      if Text_IO.Is_Open (user_input_file) then"),
VSTR("         while i <= max_size loop"),
VSTR("            --  Ada ate our newline, put it back on the end."),
VSTR("            if Text_IO.End_Of_Line (user_input_file) then"),
VSTR("               buf (loc) := ASCII.LF;"),
VSTR("               Text_IO.Skip_Line (user_input_file, 1);"),
VSTR("-- UMASS CODES :"),
VSTR("               --   We try to get one line by one line. So we return"),
VSTR("               --   here because we saw the end_of_line."),
VSTR("               result := i;"),
VSTR("               Temp_Line (i) := ASCII.LF;"),
VSTR("               Saved_Tok_Line2 := new String (1 .. i);"),
VSTR("               Saved_Tok_Line2 (1 .. i) := Temp_Line (1 .. i);"),
VSTR("               Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
VSTR("               return;"),
VSTR("-- END OF UMASS CODES."),
VSTR("            else"),
VSTR("               --  UCI CODES CHANGED:"),
VSTR("               --    The following codes are modified. Previous codes is commented out."),
VSTR("               --    The purpose of doing this is to make it possible to set Temp_Line"),
VSTR("               --    in Ayacc-extension specific codes. Definitely, we can read the character"),
VSTR("               --    into the Temp_Line and then set the buf. But Temp_Line will only"),
VSTR("               --    be used in Ayacc-extension specific codes which makes"),
VSTR("               --    this approach impossible."),
VSTR("               Text_IO.Get (user_input_file, c);"),
VSTR("               buf (loc) := c;"),
VSTR("--             Text_IO.Get (user_input_file, buf (loc));"),
VSTR("-- UMASS CODES :"),
VSTR("               Temp_Line (i) := c;"),
VSTR("-- END OF UMASS CODES."),
VSTR("            end if;"),
VSTR(""),
VSTR("            loc := loc + 1;"),
VSTR("            i := i + 1;"),
VSTR("         end loop;"),
VSTR("      else"),
VSTR("         while i <= max_size loop"),
VSTR("            if Text_IO.End_Of_Line then -- Ada ate our newline, put it back on the end."),
VSTR("               buf (loc) := ASCII.LF;"),
VSTR("               Text_IO.Skip_Line (1);"),
VSTR("-- UMASS CODES :"),
VSTR("               --   We try to get one line by one line. So we return"),
VSTR("               --   here because we saw the end_of_line."),
VSTR("               result := i;"),
VSTR("               Temp_Line (i) := ASCII.LF;"),
VSTR("               Saved_Tok_Line2 := new String (1 .. i);"),
VSTR("               Saved_Tok_Line2 (1 .. i) := Temp_Line (1 .. i);"),
VSTR("               Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
VSTR("               return;"),
VSTR("-- END OF UMASS CODES."),
VSTR("%%"),
VSTR(""),
VSTR("            else"),
VSTR("               --  The following codes are modified. Previous codes is commented out."),
VSTR("               --  The purpose of doing this is to make it possible to set Temp_Line"),
VSTR("               --  in Ayacc-extension specific codes. Definitely, we can read the character"),
VSTR("               --  into the Temp_Line and then set the buf. But Temp_Line will only"),
VSTR("               --  be used in Ayacc-extension specific codes which makes this approach impossible."),
VSTR("               Text_IO.Get (c);"),
VSTR("               buf (loc) := c;"),
VSTR("               --         get (buf (loc));"),
VSTR("-- UMASS CODES :"),
VSTR("               Temp_Line (i) := c;"),
VSTR("-- END OF UMASS CODES."),
VSTR("            end if;"),
VSTR(""),
VSTR("            loc := loc + 1;"),
VSTR("            i := i + 1;"),
VSTR("         end loop;"),
VSTR("      end if; --  for input file being standard input"),
VSTR("      result := i - 1;"),
VSTR(""),
VSTR("-- UMASS CODES :"),
VSTR("      --  Since we get one line by one line, if we"),
VSTR("      --  reach here, it means that current line have"),
VSTR("      --  more that max_size characters. So it is"),
VSTR("      --  impossible to hold the whole line. We"),
VSTR("      --  report the warning message and continue."),
VSTR("      buf (loc - 1) := Ascii.LF;"),
VSTR("      if Text_IO.Is_Open (user_input_file) then"),
VSTR("         Text_IO.Skip_Line (user_input_file, 1);"),
VSTR("      else"),
VSTR("         Text_IO.Skip_Line (1);"),
VSTR("      end if;"),
VSTR("      Temp_Line (i - 1) := ASCII.LF;"),
VSTR("      Saved_Tok_Line2 := new String (1 .. i - 1);"),
VSTR("      Saved_Tok_Line2 (1 .. i - 1) := Temp_Line (1 .. i - 1);"),
VSTR("      Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
VSTR("      Put_Line (""Input line """),
VSTR("                & Integer'Image ( Line_Number_Of_Saved_Tok_Line2 )"),
VSTR("                & ""has more than """),
VSTR("                & Integer'Image ( max_size )"),
VSTR("                & "" characters, ... truncated."" );"),
VSTR("-- END OF UMASS CODES."),
VSTR("   exception"),
VSTR("      when Text_IO.End_Error =>"),
VSTR("         result := i - 1;"),
VSTR("         --  when we hit EOF we need to set yy_eof_has_been_seen"),
VSTR("         yy_eof_has_been_seen := True;"),
VSTR("-- UMASS CODES :"),
VSTR("         --   Processing incomplete line."),
VSTR("         if i /= 1 then"),
VSTR("            -- Current line is not empty but do not have end_of_line."),
VSTR("            -- So current line is incomplete line. But we still need"),
VSTR("            -- to save it."),
VSTR("            Saved_Tok_Line2 := new String (1 .. i - 1);"),
VSTR("            Saved_Tok_Line2 (1 .. i - 1) := Temp_Line (1 .. i - 1);"),
VSTR("            Line_Number_Of_Saved_Tok_Line2 := Line_Number_Of_Saved_Tok_Line1 + 1;"),
VSTR("         end if;"),
VSTR("-- END OF UMASS CODES."),
VSTR("   end YY_INPUT;"),
VSTR(""),
VSTR("   --  yy_get_next_buffer - try to read in new buffer"),
VSTR("   --"),
VSTR("   --  returns a code representing an action"),
VSTR("   --     EOB_ACT_LAST_MATCH -"),
VSTR("   --     EOB_ACT_RESTART_SCAN - restart the scanner"),
VSTR("   --     EOB_ACT_END_OF_FILE - end of file"),
VSTR(""),
VSTR("   function yy_get_next_buffer return eob_action_type is"),
VSTR("      dest           : Integer := 0;"),
VSTR("      source         : Integer := yytext_ptr - 1; -- copy prev. char, too"),
VSTR("      number_to_move : Integer;"),
VSTR("      ret_val        : eob_action_type;"),
VSTR("      num_to_read    : Integer;"),
VSTR("   begin"),
VSTR("      if yy_c_buf_p > yy_n_chars + 1 then"),
VSTR("         raise NULL_IN_INPUT;"),
VSTR("      end if;"),
VSTR(""),
VSTR("      --  try to read more data"),
VSTR(""),
VSTR("      --  first move last chars to start of buffer"),
VSTR("      number_to_move := yy_c_buf_p - yytext_ptr;"),
VSTR(""),
VSTR("      for i in 0 .. number_to_move - 1 loop"),
VSTR("         yy_ch_buf (dest) := yy_ch_buf (source);"),
VSTR("         dest := dest + 1;"),
VSTR("         source := source + 1;"),
VSTR("      end loop;"),
VSTR(""),
VSTR("      if yy_eof_has_been_seen then"),
VSTR("         --  don't do the read, it's not guaranteed to return an EOF,"),
VSTR("         --  just force an EOF"),
VSTR(""),
VSTR("         yy_n_chars := 0;"),
VSTR("      else"),
VSTR("         num_to_read := YY_BUF_SIZE - number_to_move - 1;"),
VSTR(""),
VSTR("         if num_to_read > YY_READ_BUF_SIZE then"),
VSTR("            num_to_read := YY_READ_BUF_SIZE;"),
VSTR("         end if;"),
VSTR(""),
VSTR("         --  read in more data"),
VSTR("         YY_INPUT (yy_ch_buf (number_to_move .. yy_ch_buf'Last), yy_n_chars, num_to_read);"),
VSTR("      end if;"),
VSTR("      if yy_n_chars = 0 then"),
VSTR("         if number_to_move = 1 then"),
VSTR("            ret_val := EOB_ACT_END_OF_FILE;"),
VSTR("         else"),
VSTR("            ret_val := EOB_ACT_LAST_MATCH;"),
VSTR("         end if;"),
VSTR(""),
VSTR("         yy_eof_has_been_seen := True;"),
VSTR("      else"),
VSTR("         ret_val := EOB_ACT_RESTART_SCAN;"),
VSTR("      end if;"),
VSTR(""),
VSTR("      yy_n_chars := yy_n_chars + number_to_move;"),
VSTR("      yy_ch_buf (yy_n_chars) := YY_END_OF_BUFFER_CHAR;"),
VSTR("      yy_ch_buf (yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;"),
VSTR(""),
VSTR("      --  yytext begins at the second character in"),
VSTR("      --  yy_ch_buf; the first character is the one which"),
VSTR("      --  preceded it before reading in the latest buffer;"),
VSTR("      --  it needs to be kept around in case it's a"),
VSTR("      --  newline, so yy_get_previous_state() will have"),
VSTR("      --  with '^' rules active"),
VSTR(""),
VSTR("      yytext_ptr := 1;"),
VSTR(""),
VSTR("      return ret_val;"),
VSTR("   end yy_get_next_buffer;"),
VSTR(""),
VSTR("   procedure yyUnput (c : Character; yy_bp : in out Integer) is"),
VSTR("      number_to_move : Integer;"),
VSTR("      dest : Integer;"),
VSTR("      source : Integer;"),
VSTR("      tmp_yy_cp : Integer;"),
VSTR("   begin"),
VSTR("      tmp_yy_cp := yy_c_buf_p;"),
VSTR("      yy_ch_buf (tmp_yy_cp) := yy_hold_char; --  undo effects of setting up yytext"),
VSTR(""),
VSTR("      if tmp_yy_cp < 2 then"),
VSTR("         --  need to shift things up to make room"),
VSTR("         number_to_move := yy_n_chars + 2; --  +2 for EOB chars"),
VSTR("         dest := YY_BUF_SIZE + 2;"),
VSTR("         source := number_to_move;"),
VSTR(""),
VSTR("         while source > 0 loop"),
VSTR("            dest := dest - 1;"),
VSTR("            source := source - 1;"),
VSTR("            yy_ch_buf (dest) := yy_ch_buf (source);"),
VSTR("         end loop;"),
VSTR(""),
VSTR("         tmp_yy_cp := tmp_yy_cp + dest - source;"),
VSTR("         yy_bp := yy_bp + dest - source;"),
VSTR("         yy_n_chars := YY_BUF_SIZE;"),
VSTR(""),
VSTR("         if tmp_yy_cp < 2 then"),
VSTR("            raise PUSHBACK_OVERFLOW;"),
VSTR("         end if;"),
VSTR("      end if;"),
VSTR(""),
VSTR("      if tmp_yy_cp > yy_bp and then yy_ch_buf (tmp_yy_cp - 1) = ASCII.LF then"),
VSTR("         yy_ch_buf (tmp_yy_cp - 2) := ASCII.LF;"),
VSTR("      end if;"),
VSTR(""),
VSTR("      tmp_yy_cp := tmp_yy_cp - 1;"),
VSTR("      yy_ch_buf (tmp_yy_cp) := c;"),
VSTR(""),
VSTR("      --  Note:  this code is the text of YY_DO_BEFORE_ACTION, only"),
VSTR("      --         here we get different yy_cp and yy_bp's"),
VSTR("      yytext_ptr := yy_bp;"),
VSTR("      yy_hold_char := yy_ch_buf (tmp_yy_cp);"),
VSTR("      yy_ch_buf (tmp_yy_cp) := ASCII.NUL;"),
VSTR("      yy_c_buf_p := tmp_yy_cp;"),
VSTR("   end yyUnput;"),
VSTR(""),
VSTR("   procedure Unput (c : Character) is"),
VSTR("   begin"),
VSTR("      yyUnput (c, yy_bp);"),
VSTR("   end Unput;"),
VSTR(""),
VSTR("   function Input return Character is"),
VSTR("      c : Character;"),
VSTR("   begin"),
VSTR("      yy_ch_buf (yy_c_buf_p) := yy_hold_char;"),
VSTR(""),
VSTR("      if yy_ch_buf (yy_c_buf_p) = YY_END_OF_BUFFER_CHAR then"),
VSTR("         --  need more input"),
VSTR("         yytext_ptr := yy_c_buf_p;"),
VSTR("         yy_c_buf_p := yy_c_buf_p + 1;"),
VSTR(""),
VSTR("         case yy_get_next_buffer is"),
VSTR("            --  this code, unfortunately, is somewhat redundant with"),
VSTR("            --  that above"),
VSTR(""),
VSTR("         when EOB_ACT_END_OF_FILE =>"),
VSTR("            if yyWrap then"),
VSTR("               yy_c_buf_p := yytext_ptr;"),
VSTR("               return ASCII.NUL;"),
VSTR("            end if;"),
VSTR(""),
VSTR("            yy_ch_buf (0) := ASCII.LF;"),
VSTR("            yy_n_chars := 1;"),
VSTR("            yy_ch_buf (yy_n_chars) := YY_END_OF_BUFFER_CHAR;"),
VSTR("            yy_ch_buf (yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;"),
VSTR("            yy_eof_has_been_seen := False;"),
VSTR("            yy_c_buf_p := 1;"),
VSTR("            yytext_ptr := yy_c_buf_p;"),
VSTR("            yy_hold_char := yy_ch_buf (yy_c_buf_p);"),
VSTR(""),
VSTR("            return Input;"),
VSTR("         when EOB_ACT_RESTART_SCAN =>"),
VSTR("            yy_c_buf_p := yytext_ptr;"),
VSTR(""),
VSTR("         when EOB_ACT_LAST_MATCH =>"),
VSTR("            raise UNEXPECTED_LAST_MATCH;"),
VSTR("         end case;"),
VSTR("      end if;"),
VSTR(""),
VSTR("      c := yy_ch_buf (yy_c_buf_p);"),
VSTR("      yy_c_buf_p := yy_c_buf_p + 1;"),
VSTR("      yy_hold_char := yy_ch_buf (yy_c_buf_p);"),
VSTR(""),
VSTR("      return c;"),
VSTR("   end Input;"),
VSTR(""),
VSTR("   procedure Output (c : Character) is"),
VSTR("   begin"),
VSTR("      if Is_Open (user_output_file) then"),
VSTR("         Text_IO.Put (user_output_file, c);"),
VSTR("      else"),
VSTR("         Text_IO.Put (c);"),
VSTR("      end if;"),
VSTR("   end Output;"),
VSTR(""),
VSTR("   procedure Output_New_Line is"),
VSTR("   begin"),
VSTR("      if Is_Open (user_output_file) then"),
VSTR("         Text_IO.New_Line (user_output_file);"),
VSTR("      else"),
VSTR("         Text_IO.New_Line;"),
VSTR("      end if;"),
VSTR("   end Output_New_Line;"),
VSTR(""),
VSTR("   function Output_Column return Text_IO.Count is"),
VSTR("   begin"),
VSTR("      if Is_Open (user_output_file) then"),
VSTR("         return Text_IO.Col (user_output_file);"),
VSTR("      else"),
VSTR("         return Text_IO.Col;"),
VSTR("      end if;"),
VSTR("   end Output_Column;"),
VSTR(""),
VSTR("   function Input_Line return Text_IO.Count is"),
VSTR("      l : Text_IO.Count := 1;"),
VSTR("   begin"),
VSTR("-- UMASS CODES :"),
VSTR("      l:= Text_IO.Count(Line_Number_Of_Saved_Tok_Line2);"), -- Tok_Begin_Line is fuzzy
VSTR("-- END OF UMASS CODES."),
VSTR("      return l; -- from file, always 1"),
VSTR("      --  if is_open(user_input_file) then"),
VSTR("      --    return Text_IO.Line(user_input_file);"),
VSTR("      --  else"),
VSTR("      --    return Text_IO.Line;"),
VSTR("      --  end if;"),
VSTR("   end Input_Line;"),
VSTR(""),
VSTR("   --  default yywrap function - always treat EOF as an EOF"),
VSTR("   function yyWrap return Boolean is"),
VSTR("   begin"),
VSTR("      return True;"),
VSTR("   end yyWrap;"),
VSTR(""),
VSTR("   procedure Open_Input (fname : in String) is"),
VSTR("   begin"),
VSTR("      yy_init := True;"),
VSTR("      Open (user_input_file, Text_IO.In_File, fname);"),
VSTR("   end Open_Input;"),
VSTR(""),
VSTR("   procedure Create_Output (fname : in String := """") is"),
VSTR("   begin"),
VSTR("      if fname /= """" then"),
VSTR("         Create (user_output_file, Text_IO.Out_File, fname);"),
VSTR("      end if;"),
VSTR("   end Create_Output;"),
VSTR(""),
VSTR("   procedure Close_Input is"),
VSTR("   begin"),
VSTR("      if Is_Open (user_input_file) then"),
VSTR("         Text_IO.Close (user_input_file);"),
VSTR("      end if;"),
VSTR("   end Close_Input;"),
VSTR(""),
VSTR("   procedure Close_Output is"),
VSTR("   begin"),
VSTR("      if Is_Open (user_output_file) then"),
VSTR("         Text_IO.Close (user_output_file);"),
VSTR("      end if;"),
VSTR("   end Close_Output;"),
VSTR(""),
VSTR("-- UMASS CODES :"),
VSTR("   procedure Yy_Get_Token_Line ( Yy_Line_String : out String;"),
VSTR("                                 Yy_Line_Length : out Natural ) is"),
VSTR("   begin"),
VSTR("      --  Currently processing line is either in saved token line1 or"),
VSTR("      --  in saved token line2."),
VSTR("      if Yy_Line_Number = Line_Number_Of_Saved_Tok_Line1 then"),
VSTR("         Yy_Line_Length := Saved_Tok_Line1.all'length;"),
VSTR("         Yy_Line_String ( Yy_Line_String'First .. ( Yy_Line_String'First + Saved_Tok_Line1.all'length - 1 ))"),
VSTR("           := Saved_Tok_Line1 ( 1 .. Saved_Tok_Line1.all'length );"),
VSTR("      else"),
VSTR("         Yy_Line_Length := Saved_Tok_Line2.all'length;"),
VSTR("         Yy_Line_String ( Yy_Line_String'First .. ( Yy_Line_String'First + Saved_Tok_Line2.all'length - 1 ))"),
VSTR("           := Saved_Tok_Line2 ( 1 .. Saved_Tok_Line2.all'length );"),
VSTR("      end if;"),
VSTR("   end Yy_Get_Token_Line;"),
VSTR(""),
VSTR("   function Yy_Line_Number return Natural is"),
VSTR("   begin"),
VSTR("      return Tok_Begin_Line;"),
VSTR("   end Yy_Line_Number;"),
VSTR(""),
VSTR("   function Yy_Begin_Column return Natural is"),
VSTR("   begin"),
VSTR("      return Tok_Begin_Col;"),
VSTR("   end Yy_Begin_Column;"),
VSTR(""),
VSTR("   function Yy_End_Column return Natural is"),
VSTR("   begin"),
VSTR("      return Tok_End_Col;"),
VSTR("   end Yy_End_Column;"),
VSTR(""),
VSTR("-- END OF UMASS CODES."),
VSTR("")
--IO TEMPLATE END
);

  IO_CURRENT_LINE  : INTEGER := 1;

  procedure TEMPLATE_OUT(OUTFILE          : in FILE_TYPE;
                         CURRENT_TEMPLATE : in FILE_ARRAY;
                         LINE_NUMBER      : in out INTEGER) is
    BUF : VSTRING;
-- UMASS CODES :
    Umass_Codes : Boolean := False;
    -- Indicates whether or not current line of the template
    -- is the Umass codes.
-- END OF UMASS CODES.
  begin
    while not (LINE_NUMBER > CURRENT_TEMPLATE'LAST) loop
      BUF := CURRENT_TEMPLATE(LINE_NUMBER);
      LINE_NUMBER := LINE_NUMBER + 1;
      if ((FILE_STRING.LEN(BUF) >= 2) and then ((CHAR(BUF, 1) = '%') and (CHAR(
        BUF, 2) = '%'))) then
        exit;
      else
-- UMASS CODES :
--   In the template, the codes between "-- UMASS CODES : " and
--   "-- END OF UMASS CODES." are specific to be used by Ayacc-extension.
--   Ayacc-extension has more power in error recovery. So we
--   generate those codes only when Ayacc_Extension_Flag is True.
        if FILE_STRING.STR(BUF) = "-- UMASS CODES :" then
          Umass_Codes := True;
        end if;

        if not Umass_Codes or else
           Ayacc_Extension_Flag then
          FILE_STRING.PUT_LINE(OUTFILE,BUF);
        end if;

        if FILE_STRING.STR(BUF) = "-- END OF UMASS CODES." then
          Umass_Codes := False;
        end if;
-- END OF UMASS CODES.

-- UCI CODES commented out :
--   The following line is commented out because it is done in Umass codes.
--      FILE_STRING.PUT_LINE(OUTFILE,BUF);

      end if;
    end loop;
  end TEMPLATE_OUT;

  procedure GENERATE_DFA_FILE is
    DFA_OUT_FILE : FILE_TYPE;
  begin
      EXTERNAL_FILE_MANAGER.GET_DFA_FILE(DFA_OUT_FILE, True);
      --  Text_IO.PUT_LINE(DFA_OUT_FILE, "pragma Style_Checks (Off);");
      Text_Io.PUT_LINE(DFA_OUT_FILE, "--  Warning: This file is automatically generated by AFLEX.");
      Text_Io.PUT_LINE(DFA_OUT_FILE, "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
      Text_IO.PUT_LINE(DFA_OUT_FILE, "package " & MISC.PACKAGE_NAME & "_dfa is");
      Text_IO.NEW_LINE(DFA_OUT_FILE);

      if DDEBUG then
         -- make a scanner that output acceptance information
         Text_IO.PUT_LINE(DFA_OUT_FILE, "   aflex_debug       : Boolean := True;");
      else
         Text_IO.PUT_LINE(DFA_OUT_FILE, "   aflex_debug       : Boolean := False;");
      end if;
      if YYLINENO then
         Text_IO.PUT_LINE(DFA_OUT_FILE, "   yylineno          : Natural := 0;");
         Text_IO.PUT_LINE(DFA_OUT_FILE, "   yylinecol         : Natural := 0;");
         Text_IO.PUT_LINE(DFA_OUT_FILE, "   yy_last_yylineno  : Natural := 0;");
         Text_IO.PUT_LINE(DFA_OUT_FILE, "   yy_last_yylinecol : Natural := 0;");

      end if;
      TEMPLATE_OUT(DFA_OUT_FILE, DFA_TEMPLATE, DFA_CURRENT_LINE);
      Text_IO.PUT_LINE(DFA_OUT_FILE, "end " & MISC.PACKAGE_NAME & "_dfa;");
      Text_IO.Close(DFA_OUT_FILE);

      EXTERNAL_FILE_MANAGER.GET_DFA_FILE(DFA_OUT_FILE, False);
      Text_Io.PUT_LINE(DFA_OUT_FILE, "--  Warning: This file is automatically generated by AFLEX.");
      Text_Io.PUT_LINE(DFA_OUT_FILE, "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
      Text_IO.NEW_LINE(DFA_OUT_FILE);
      --  Text_IO.PUT_LINE(DFA_OUT_FILE, "pragma Style_Checks (Off);");
      Text_IO.PUT(DFA_OUT_FILE, "with " & MISC.PACKAGE_NAME & "_dfa" & "; ");
      Text_IO.PUT_LINE(DFA_OUT_FILE, "use " & MISC.PACKAGE_NAME & "_dfa;");
      Text_IO.PUT_LINE(DFA_OUT_FILE, "package body " & MISC.PACKAGE_NAME & "_dfa is");
      TEMPLATE_OUT(DFA_OUT_FILE, DFA_TEMPLATE, DFA_CURRENT_LINE);
      Text_IO.PUT_LINE(DFA_OUT_FILE, "end " & MISC.PACKAGE_NAME & "_dfa;");
  end GENERATE_DFA_FILE;

  procedure GENERATE_IO_FILE is
    IO_OUT_FILE : FILE_TYPE;
  begin
    EXTERNAL_FILE_MANAGER.GET_IO_FILE(IO_OUT_FILE, True);
    Text_Io.PUT_LINE(IO_OUT_FILE, "--  Warning: This file is automatically generated by AFLEX.");
    Text_Io.PUT_LINE(IO_OUT_FILE, "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
    --  Text_IO.PUT_LINE(IO_OUT_FILE, "pragma Style_Checks (Off);");
    Text_IO.PUT(IO_OUT_FILE, "with " & MISC.PACKAGE_NAME & "_dfa; ");
    Text_IO.PUT_LINE(IO_OUT_FILE, "use " & MISC.PACKAGE_NAME & "_dfa;");
    TEMPLATE_OUT(IO_OUT_FILE, IO_TEMPLATE, IO_CURRENT_LINE);
    Text_IO.PUT_LINE(IO_OUT_FILE, "package " & MISC.PACKAGE_NAME &
      "_io is");
    TEMPLATE_OUT(IO_OUT_FILE, IO_TEMPLATE, IO_CURRENT_LINE);
    Text_IO.PUT_LINE(IO_OUT_FILE, "end " & MISC.PACKAGE_NAME & "_io;")
      ;
    Text_IO.Close(IO_OUT_FILE);

    EXTERNAL_FILE_MANAGER.GET_IO_FILE(IO_OUT_FILE, False);
    Text_Io.PUT_LINE(IO_OUT_FILE, "--  Warning: This file is automatically generated by AFLEX.");
    Text_Io.PUT_LINE(IO_OUT_FILE, "--           It is useless to modify it. Change the "".Y"" & "".L"" files instead.");
    --  Text_IO.PUT_LINE(IO_OUT_FILE, "pragma Style_Checks (Off);");
    Text_IO.PUT_LINE(IO_OUT_FILE, "package body " & MISC.PACKAGE_NAME
      & "_io is");
    TEMPLATE_OUT(IO_OUT_FILE, IO_TEMPLATE, IO_CURRENT_LINE);
    -- If we're generating a scanner for interactive mode we need to generate
    -- a YY_INPUT that stops at the end of each line
    if INTERACTIVE then
        Text_IO.PUT_LINE(IO_OUT_FILE,
        "            i := i + 1; -- update counter, miss end of loop");
    Text_IO.PUT_LINE(IO_OUT_FILE,
        "            exit; -- in interactive mode return at end of line.");
    end if;
    TEMPLATE_OUT(IO_OUT_FILE, IO_TEMPLATE, IO_CURRENT_LINE);
    Text_IO.PUT_LINE(IO_OUT_FILE, "end " & MISC.PACKAGE_NAME & "_io;")
      ;
  end GENERATE_IO_FILE;

end TEMPLATE_MANAGER;
