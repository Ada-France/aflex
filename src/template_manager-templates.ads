--  Advanced Resource Embedder 1.3.0
package Template_Manager.Templates is

   body_dfa : aliased constant Content_Array;
   body_io : aliased constant Content_Array;
   body_lex : aliased constant Content_Array;
   body_reentrant_dfa : aliased constant Content_Array;
   body_reentrant_io : aliased constant Content_Array;
   body_reentrant_lex : aliased constant Content_Array;
   spec_dfa : aliased constant Content_Array;
   spec_io : aliased constant Content_Array;
   spec_reentrant_dfa : aliased constant Content_Array;
   spec_reentrant_io : aliased constant Content_Array;

private

   L_1   : aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_2   : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_3   : aliased constant String := "package body ${NAME}_DFA is";
   L_4   : aliased constant String := "";
   L_5   : aliased constant String := "   --  Nov 2002. Fixed insufficient buffe"
       & "r size bug causing";
   L_6   : aliased constant String := "   --  damage to comments at about the 10"
       & "00-th character";
   L_7   : aliased constant String := "";
   L_8   : aliased constant String := "   function YYText return String is";
   L_9   : aliased constant String := "      J : Integer := yytext_ptr;";
   L_10  : aliased constant String := "   begin";
   L_11  : aliased constant String := "      while J <= yy_ch_buf'Last and then "
       & "yy_ch_buf (J) /= ASCII.NUL loop";
   L_12  : aliased constant String := "         J := J + 1;";
   L_13  : aliased constant String := "      end loop;";
   L_14  : aliased constant String := "";
   L_15  : aliased constant String := "      declare";
   L_16  : aliased constant String := "         subtype Sliding_Type is String ("
       & "1 .. J - yytext_ptr);";
   L_17  : aliased constant String := "      begin";
   L_18  : aliased constant String := "         return Sliding_Type (yy_ch_buf ("
       & "yytext_ptr .. J - 1));";
   L_19  : aliased constant String := "      end;";
   L_20  : aliased constant String := "   end YYText;";
   L_21  : aliased constant String := "";
   L_22  : aliased constant String := "   --  Returns the length of the matched "
       & "text";
   L_23  : aliased constant String := "";
   L_24  : aliased constant String := "   function YYLength return Integer is";
   L_25  : aliased constant String := "   begin";
   L_26  : aliased constant String := "      return yy_cp - yy_bp;";
   L_27  : aliased constant String := "   end YYLength;";
   L_28  : aliased constant String := "";
   L_29  : aliased constant String := "   --  Done after the current pattern has"
       & " been matched and before the";
   L_30  : aliased constant String := "   --  corresponding action - sets up yyt"
       & "ext";
   L_31  : aliased constant String := "";
   L_32  : aliased constant String := "   procedure YY_DO_BEFORE_ACTION is";
   L_33  : aliased constant String := "   begin";
   L_34  : aliased constant String := "      yytext_ptr := yy_bp;";
   L_35  : aliased constant String := "      yy_hold_char := yy_ch_buf (yy_cp);";
   L_36  : aliased constant String := "      yy_ch_buf (yy_cp) := ASCII.NUL;";
   L_37  : aliased constant String := "      yy_c_buf_p := yy_cp;";
   L_38  : aliased constant String := "   end YY_DO_BEFORE_ACTION;";
   L_39  : aliased constant String := "";
   L_40  : aliased constant String := "end ${NAME}_DFA;";
   body_dfa : aliased constant Content_Array :=
     (L_1'Access,
      L_2'Access,
      L_3'Access,
      L_4'Access,
      L_5'Access,
      L_6'Access,
      L_7'Access,
      L_8'Access,
      L_9'Access,
      L_10'Access,
      L_11'Access,
      L_12'Access,
      L_13'Access,
      L_14'Access,
      L_15'Access,
      L_16'Access,
      L_17'Access,
      L_18'Access,
      L_19'Access,
      L_20'Access,
      L_21'Access,
      L_22'Access,
      L_23'Access,
      L_24'Access,
      L_25'Access,
      L_26'Access,
      L_27'Access,
      L_28'Access,
      L_29'Access,
      L_30'Access,
      L_31'Access,
      L_32'Access,
      L_33'Access,
      L_34'Access,
      L_35'Access,
      L_36'Access,
      L_37'Access,
      L_38'Access,
      L_39'Access,
      L_40'Access);

   L_41  : aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_42  : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_43  : aliased constant String := "--  Template: templates/body-io.adb";
   L_44  : aliased constant String := "package body ${NAME}_IO is";
   L_45  : aliased constant String := "";
   L_46  : aliased constant String := "   --  gets input and stuffs it into 'buf"
       & "'.  number of characters read, or YY_NULL,";
   L_47  : aliased constant String := "   --  is returned in 'result'.";
   L_48  : aliased constant String := "";
   L_49  : aliased constant String := "   procedure YY_INPUT (buf      : out unb"
       & "ounded_character_array;";
   L_50  : aliased constant String := "                       result   : out Int"
       & "eger;";
   L_51  : aliased constant String := "                       max_size : in Inte"
       & "ger) is";
   L_52  : aliased constant String := "      c   : Character;";
   L_53  : aliased constant String := "      i   : Integer := 1;";
   L_54  : aliased constant String := "      loc : Integer := buf'First;";
   L_55  : aliased constant String := "%if error";
   L_56  : aliased constant String := "   --    Since buf is an out parameter wh"
       & "ich is not readable";
   L_57  : aliased constant String := "   --    and saved lines is a string poin"
       & "ter which space must";
   L_58  : aliased constant String := "   --    be allocated after we know the s"
       & "ize, we maintain";
   L_59  : aliased constant String := "   --    an extra buffer to collect the i"
       & "nput line and";
   L_60  : aliased constant String := "   --    save it into the saved line 2.";
   L_61  : aliased constant String := "      Temp_Line : String (1 .. YY_BUF_SIZ"
       & "E + 2);";
   L_62  : aliased constant String := "%end";
   L_63  : aliased constant String := "   begin";
   L_64  : aliased constant String := "%if error";
   L_65  : aliased constant String := "      -- buf := ( others => ASCII.NUL ); "
       & "-- CvdL: does not work in GNAT";
   L_66  : aliased constant String := "      for j in buf'First .. buf'Last loop";
   L_67  : aliased constant String := "         buf (j) := ASCII.NUL;";
   L_68  : aliased constant String := "      end loop;";
   L_69  : aliased constant String := "      -- Move the saved lines forward.";
   L_70  : aliased constant String := "      Saved_Tok_Line1 := Saved_Tok_Line2;";
   L_71  : aliased constant String := "      Line_Number_Of_Saved_Tok_Line1 := L"
       & "ine_Number_Of_Saved_Tok_Line2;";
   L_72  : aliased constant String := "";
   L_73  : aliased constant String := "%end";
   L_74  : aliased constant String := "      if Ada.Text_IO.Is_Open (user_input_"
       & "file) then";
   L_75  : aliased constant String := "         while i <= max_size loop";
   L_76  : aliased constant String := "            --  Ada ate our newline, put "
       & "it back on the end.";
   L_77  : aliased constant String := "            if Ada.Text_IO.End_Of_Line (u"
       & "ser_input_file) then";
   L_78  : aliased constant String := "               buf (loc) := ASCII.LF;";
   L_79  : aliased constant String := "               Ada.Text_IO.Skip_Line (use"
       & "r_input_file, 1);";
   L_80  : aliased constant String := "%if error";
   L_81  : aliased constant String := "               --   We try to get one lin"
       & "e by one line. So we return";
   L_82  : aliased constant String := "               --   here because we saw t"
       & "he end_of_line.";
   L_83  : aliased constant String := "               result := i;";
   L_84  : aliased constant String := "               Temp_Line (i) := ASCII.LF;";
   L_85  : aliased constant String := "               Saved_Tok_Line2 := new Str"
       & "ing (1 .. i);";
   L_86  : aliased constant String := "               Saved_Tok_Line2 (1 .. i) :"
       & "= Temp_Line (1 .. i);";
   L_87  : aliased constant String := "               Line_Number_Of_Saved_Tok_L"
       & "ine2 := Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_88  : aliased constant String := "               return;";
   L_89  : aliased constant String := "%end";
   L_90  : aliased constant String := "%if interactive";
   L_91  : aliased constant String := "               i := i + 1; --  update cou"
       & "nter, miss end of loop";
   L_92  : aliased constant String := "               exit; --  in interactive m"
       & "ode return at end of line.";
   L_93  : aliased constant String := "%end";
   L_94  : aliased constant String := "            else";
   L_95  : aliased constant String := "               --  UCI CODES CHANGED:";
   L_96  : aliased constant String := "               --    The following codes "
       & "are modified. Previous codes is commented out.";
   L_97  : aliased constant String := "               --    The purpose of doing"
       & " this is to make it possible to set Temp_Line";
   L_98  : aliased constant String := "               --    in Ayacc-extension s"
       & "pecific codes. Definitely, we can read the character";
   L_99  : aliased constant String := "               --    into the Temp_Line a"
       & "nd then set the buf. But Temp_Line will only";
   L_100 : aliased constant String := "               --    be used in Ayacc-ext"
       & "ension specific codes which makes";
   L_101 : aliased constant String := "               --    this approach imposs"
       & "ible.";
   L_102 : aliased constant String := "               Ada.Text_IO.Get (user_inpu"
       & "t_file, c);";
   L_103 : aliased constant String := "               buf (loc) := c;";
   L_104 : aliased constant String := "--             Ada.Text_IO.Get (user_inpu"
       & "t_file, buf (loc));";
   L_105 : aliased constant String := "%if error";
   L_106 : aliased constant String := "               Temp_Line (i) := c;";
   L_107 : aliased constant String := "%end";
   L_108 : aliased constant String := "            end if;";
   L_109 : aliased constant String := "";
   L_110 : aliased constant String := "            loc := loc + 1;";
   L_111 : aliased constant String := "            i := i + 1;";
   L_112 : aliased constant String := "         end loop;";
   L_113 : aliased constant String := "      else";
   L_114 : aliased constant String := "         while i <= max_size loop";
   L_115 : aliased constant String := "            if Ada.Text_IO.End_Of_Line th"
       & "en -- Ada ate our newline, put it back on the end.";
   L_116 : aliased constant String := "               buf (loc) := ASCII.LF;";
   L_117 : aliased constant String := "               Ada.Text_IO.Skip_Line (1);";
   L_118 : aliased constant String := "%if error";
   L_119 : aliased constant String := "               --   We try to get one lin"
       & "e by one line. So we return";
   L_120 : aliased constant String := "               --   here because we saw t"
       & "he end_of_line.";
   L_121 : aliased constant String := "               result := i;";
   L_122 : aliased constant String := "               Temp_Line (i) := ASCII.LF;";
   L_123 : aliased constant String := "               Saved_Tok_Line2 := new Str"
       & "ing (1 .. i);";
   L_124 : aliased constant String := "               Saved_Tok_Line2 (1 .. i) :"
       & "= Temp_Line (1 .. i);";
   L_125 : aliased constant String := "               Line_Number_Of_Saved_Tok_L"
       & "ine2 := Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_126 : aliased constant String := "               return;";
   L_127 : aliased constant String := "%end";
   L_128 : aliased constant String := "";
   L_129 : aliased constant String := "            else";
   L_130 : aliased constant String := "               --  The following codes ar"
       & "e modified. Previous codes is commented out.";
   L_131 : aliased constant String := "               --  The purpose of doing t"
       & "his is to make it possible to set Temp_Line";
   L_132 : aliased constant String := "               --  in Ayacc-extension spe"
       & "cific codes. Definitely, we can read the character";
   L_133 : aliased constant String := "               --  into the Temp_Line and"
       & " then set the buf. But Temp_Line will only";
   L_134 : aliased constant String := "               --  be used in Ayacc-exten"
       & "sion specific codes which makes this approach impossible.";
   L_135 : aliased constant String := "               Ada.Text_IO.Get (c);";
   L_136 : aliased constant String := "               buf (loc) := c;";
   L_137 : aliased constant String := "               --         get (buf (loc))"
       & ";";
   L_138 : aliased constant String := "%if error";
   L_139 : aliased constant String := "               Temp_Line (i) := c;";
   L_140 : aliased constant String := "%end";
   L_141 : aliased constant String := "            end if;";
   L_142 : aliased constant String := "";
   L_143 : aliased constant String := "            loc := loc + 1;";
   L_144 : aliased constant String := "            i := i + 1;";
   L_145 : aliased constant String := "         end loop;";
   L_146 : aliased constant String := "      end if; --  for input file being st"
       & "andard input";
   L_147 : aliased constant String := "      result := i - 1;";
   L_148 : aliased constant String := "";
   L_149 : aliased constant String := "%if error";
   L_150 : aliased constant String := "      --  Since we get one line by one li"
       & "ne, if we";
   L_151 : aliased constant String := "      --  reach here, it means that curre"
       & "nt line have";
   L_152 : aliased constant String := "      --  more that max_size characters. "
       & "So it is";
   L_153 : aliased constant String := "      --  impossible to hold the whole li"
       & "ne. We";
   L_154 : aliased constant String := "      --  report the warning message and "
       & "continue.";
   L_155 : aliased constant String := "      buf (loc - 1) := Ascii.LF;";
   L_156 : aliased constant String := "      if Ada.Text_IO.Is_Open (user_input_"
       & "file) then";
   L_157 : aliased constant String := "         Ada.Text_IO.Skip_Line (user_inpu"
       & "t_file, 1);";
   L_158 : aliased constant String := "      else";
   L_159 : aliased constant String := "         Ada.Text_IO.Skip_Line (1);";
   L_160 : aliased constant String := "      end if;";
   L_161 : aliased constant String := "      Temp_Line (i - 1) := ASCII.LF;";
   L_162 : aliased constant String := "      Saved_Tok_Line2 := new String (1 .."
       & " i - 1);";
   L_163 : aliased constant String := "      Saved_Tok_Line2 (1 .. i - 1) := Tem"
       & "p_Line (1 .. i - 1);";
   L_164 : aliased constant String := "      Line_Number_Of_Saved_Tok_Line2 := L"
       & "ine_Number_Of_Saved_Tok_Line1 + 1;";
   L_165 : aliased constant String := "      Put_Line (""Input line """;
   L_166 : aliased constant String := "                & Integer'Image ( Line_Nu"
       & "mber_Of_Saved_Tok_Line2 )";
   L_167 : aliased constant String := "                & ""has more than """;
   L_168 : aliased constant String := "                & Integer'Image ( max_siz"
       & "e )";
   L_169 : aliased constant String := "                & "" characters, ... trun"
       & "cated."" );";
   L_170 : aliased constant String := "%end";
   L_171 : aliased constant String := "   exception";
   L_172 : aliased constant String := "      when Ada.Text_IO.End_Error =>";
   L_173 : aliased constant String := "         result := i - 1;";
   L_174 : aliased constant String := "         --  when we hit EOF we need to s"
       & "et yy_eof_has_been_seen";
   L_175 : aliased constant String := "         yy_eof_has_been_seen := True;";
   L_176 : aliased constant String := "%if error";
   L_177 : aliased constant String := "         --   Processing incomplete line.";
   L_178 : aliased constant String := "         if i /= 1 then";
   L_179 : aliased constant String := "            -- Current line is not empty "
       & "but do not have end_of_line.";
   L_180 : aliased constant String := "            -- So current line is incompl"
       & "ete line. But we still need";
   L_181 : aliased constant String := "            -- to save it.";
   L_182 : aliased constant String := "            Saved_Tok_Line2 := new String"
       & " (1 .. i - 1);";
   L_183 : aliased constant String := "            Saved_Tok_Line2 (1 .. i - 1) "
       & ":= Temp_Line (1 .. i - 1);";
   L_184 : aliased constant String := "            Line_Number_Of_Saved_Tok_Line"
       & "2 := Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_185 : aliased constant String := "         end if;";
   L_186 : aliased constant String := "%end";
   L_187 : aliased constant String := "";
   L_188 : aliased constant String := "   end YY_INPUT;";
   L_189 : aliased constant String := "";
   L_190 : aliased constant String := "   --  yy_get_next_buffer - try to read i"
       & "n new buffer";
   L_191 : aliased constant String := "   --";
   L_192 : aliased constant String := "   --  returns a code representing an act"
       & "ion";
   L_193 : aliased constant String := "   --     EOB_ACT_LAST_MATCH -";
   L_194 : aliased constant String := "   --     EOB_ACT_RESTART_SCAN - restart "
       & "the scanner";
   L_195 : aliased constant String := "   --     EOB_ACT_END_OF_FILE - end of fi"
       & "le";
   L_196 : aliased constant String := "";
   L_197 : aliased constant String := "   function yy_get_next_buffer return eob"
       & "_action_type is";
   L_198 : aliased constant String := "      dest           : Integer := 0;";
   L_199 : aliased constant String := "      source         : Integer := yytext_"
       & "ptr - 1; -- copy prev. char, too";
   L_200 : aliased constant String := "      number_to_move : Integer;";
   L_201 : aliased constant String := "      ret_val        : eob_action_type;";
   L_202 : aliased constant String := "      num_to_read    : Integer;";
   L_203 : aliased constant String := "   begin";
   L_204 : aliased constant String := "      if yy_c_buf_p > yy_n_chars + 1 then";
   L_205 : aliased constant String := "         raise NULL_IN_INPUT;";
   L_206 : aliased constant String := "      end if;";
   L_207 : aliased constant String := "";
   L_208 : aliased constant String := "      --  try to read more data";
   L_209 : aliased constant String := "";
   L_210 : aliased constant String := "      --  first move last chars to start "
       & "of buffer";
   L_211 : aliased constant String := "      number_to_move := yy_c_buf_p - yyte"
       & "xt_ptr;";
   L_212 : aliased constant String := "";
   L_213 : aliased constant String := "      for i in 0 .. number_to_move - 1 lo"
       & "op";
   L_214 : aliased constant String := "         yy_ch_buf (dest) := yy_ch_buf (s"
       & "ource);";
   L_215 : aliased constant String := "         dest := dest + 1;";
   L_216 : aliased constant String := "         source := source + 1;";
   L_217 : aliased constant String := "      end loop;";
   L_218 : aliased constant String := "";
   L_219 : aliased constant String := "      if yy_eof_has_been_seen then";
   L_220 : aliased constant String := "         --  don't do the read, it's not "
       & "guaranteed to return an EOF,";
   L_221 : aliased constant String := "         --  just force an EOF";
   L_222 : aliased constant String := "";
   L_223 : aliased constant String := "         yy_n_chars := 0;";
   L_224 : aliased constant String := "      else";
   L_225 : aliased constant String := "         num_to_read := YY_BUF_SIZE - num"
       & "ber_to_move - 1;";
   L_226 : aliased constant String := "";
   L_227 : aliased constant String := "         if num_to_read > YY_READ_BUF_SIZ"
       & "E then";
   L_228 : aliased constant String := "            num_to_read := YY_READ_BUF_SI"
       & "ZE;";
   L_229 : aliased constant String := "         end if;";
   L_230 : aliased constant String := "";
   L_231 : aliased constant String := "         --  read in more data";
   L_232 : aliased constant String := "         YY_INPUT (yy_ch_buf (number_to_m"
       & "ove .. yy_ch_buf'Last), yy_n_chars, num_to_read);";
   L_233 : aliased constant String := "      end if;";
   L_234 : aliased constant String := "      if yy_n_chars = 0 then";
   L_235 : aliased constant String := "         if number_to_move = 1 then";
   L_236 : aliased constant String := "            ret_val := EOB_ACT_END_OF_FIL"
       & "E;";
   L_237 : aliased constant String := "         else";
   L_238 : aliased constant String := "            ret_val := EOB_ACT_LAST_MATCH"
       & ";";
   L_239 : aliased constant String := "         end if;";
   L_240 : aliased constant String := "";
   L_241 : aliased constant String := "         yy_eof_has_been_seen := True;";
   L_242 : aliased constant String := "      else";
   L_243 : aliased constant String := "         ret_val := EOB_ACT_RESTART_SCAN;";
   L_244 : aliased constant String := "      end if;";
   L_245 : aliased constant String := "";
   L_246 : aliased constant String := "      yy_n_chars := yy_n_chars + number_t"
       & "o_move;";
   L_247 : aliased constant String := "      yy_ch_buf (yy_n_chars) := YY_END_OF"
       & "_BUFFER_CHAR;";
   L_248 : aliased constant String := "      yy_ch_buf (yy_n_chars + 1) := YY_EN"
       & "D_OF_BUFFER_CHAR;";
   L_249 : aliased constant String := "";
   L_250 : aliased constant String := "      --  yytext begins at the second cha"
       & "racter in";
   L_251 : aliased constant String := "      --  yy_ch_buf; the first character "
       & "is the one which";
   L_252 : aliased constant String := "      --  preceded it before reading in t"
       & "he latest buffer;";
   L_253 : aliased constant String := "      --  it needs to be kept around in c"
       & "ase it's a";
   L_254 : aliased constant String := "      --  newline, so yy_get_previous_sta"
       & "te() will have";
   L_255 : aliased constant String := "      --  with '^' rules active";
   L_256 : aliased constant String := "";
   L_257 : aliased constant String := "      yytext_ptr := 1;";
   L_258 : aliased constant String := "";
   L_259 : aliased constant String := "      return ret_val;";
   L_260 : aliased constant String := "   end yy_get_next_buffer;";
   L_261 : aliased constant String := "";
   L_262 : aliased constant String := "%if unput";
   L_263 : aliased constant String := "   procedure yyUnput (c : Character; yy_b"
       & "p : in out Integer) is";
   L_264 : aliased constant String := "      number_to_move : Integer;";
   L_265 : aliased constant String := "      dest : Integer;";
   L_266 : aliased constant String := "      source : Integer;";
   L_267 : aliased constant String := "      tmp_yy_cp : Integer;";
   L_268 : aliased constant String := "   begin";
   L_269 : aliased constant String := "      tmp_yy_cp := yy_c_buf_p;";
   L_270 : aliased constant String := "      yy_ch_buf (tmp_yy_cp) := yy_hold_ch"
       & "ar; --  undo effects of setting up yytext";
   L_271 : aliased constant String := "";
   L_272 : aliased constant String := "      if tmp_yy_cp < 2 then";
   L_273 : aliased constant String := "         --  need to shift things up to m"
       & "ake room";
   L_274 : aliased constant String := "         number_to_move := yy_n_chars + 2"
       & "; --  +2 for EOB chars";
   L_275 : aliased constant String := "         dest := YY_BUF_SIZE + 2;";
   L_276 : aliased constant String := "         source := number_to_move;";
   L_277 : aliased constant String := "";
   L_278 : aliased constant String := "         while source > 0 loop";
   L_279 : aliased constant String := "            dest := dest - 1;";
   L_280 : aliased constant String := "            source := source - 1;";
   L_281 : aliased constant String := "            yy_ch_buf (dest) := yy_ch_buf"
       & " (source);";
   L_282 : aliased constant String := "         end loop;";
   L_283 : aliased constant String := "";
   L_284 : aliased constant String := "         tmp_yy_cp := tmp_yy_cp + dest - "
       & "source;";
   L_285 : aliased constant String := "         yy_bp := yy_bp + dest - source;";
   L_286 : aliased constant String := "         yy_n_chars := YY_BUF_SIZE;";
   L_287 : aliased constant String := "";
   L_288 : aliased constant String := "         if tmp_yy_cp < 2 then";
   L_289 : aliased constant String := "            raise PUSHBACK_OVERFLOW;";
   L_290 : aliased constant String := "         end if;";
   L_291 : aliased constant String := "      end if;";
   L_292 : aliased constant String := "";
   L_293 : aliased constant String := "      if tmp_yy_cp > yy_bp and then yy_ch"
       & "_buf (tmp_yy_cp - 1) = ASCII.LF then";
   L_294 : aliased constant String := "         yy_ch_buf (tmp_yy_cp - 2) := ASC"
       & "II.LF;";
   L_295 : aliased constant String := "      end if;";
   L_296 : aliased constant String := "";
   L_297 : aliased constant String := "      tmp_yy_cp := tmp_yy_cp - 1;";
   L_298 : aliased constant String := "      yy_ch_buf (tmp_yy_cp) := c;";
   L_299 : aliased constant String := "";
   L_300 : aliased constant String := "      --  Note:  this code is the text of"
       & " YY_DO_BEFORE_ACTION, only";
   L_301 : aliased constant String := "      --         here we get different yy"
       & "_cp and yy_bp's";
   L_302 : aliased constant String := "      yytext_ptr := yy_bp;";
   L_303 : aliased constant String := "      yy_hold_char := yy_ch_buf (tmp_yy_c"
       & "p);";
   L_304 : aliased constant String := "      yy_ch_buf (tmp_yy_cp) := ASCII.NUL;";
   L_305 : aliased constant String := "      yy_c_buf_p := tmp_yy_cp;";
   L_306 : aliased constant String := "   end yyUnput;";
   L_307 : aliased constant String := "";
   L_308 : aliased constant String := "   procedure Unput (c : Character) is";
   L_309 : aliased constant String := "   begin";
   L_310 : aliased constant String := "      yyUnput (c, yy_bp);";
   L_311 : aliased constant String := "   end Unput;";
   L_312 : aliased constant String := "";
   L_313 : aliased constant String := "%end";
   L_314 : aliased constant String := "%if input";
   L_315 : aliased constant String := "   function Input return Character is";
   L_316 : aliased constant String := "      c : Character;";
   L_317 : aliased constant String := "   begin";
   L_318 : aliased constant String := "      yy_ch_buf (yy_c_buf_p) := yy_hold_c"
       & "har;";
   L_319 : aliased constant String := "";
   L_320 : aliased constant String := "      if yy_ch_buf (yy_c_buf_p) = YY_END_"
       & "OF_BUFFER_CHAR then";
   L_321 : aliased constant String := "         --  need more input";
   L_322 : aliased constant String := "         yytext_ptr := yy_c_buf_p;";
   L_323 : aliased constant String := "         yy_c_buf_p := yy_c_buf_p + 1;";
   L_324 : aliased constant String := "";
   L_325 : aliased constant String := "         case yy_get_next_buffer is";
   L_326 : aliased constant String := "            --  this code, unfortunately,"
       & " is somewhat redundant with";
   L_327 : aliased constant String := "            --  that above";
   L_328 : aliased constant String := "";
   L_329 : aliased constant String := "         when EOB_ACT_END_OF_FILE =>";
   L_330 : aliased constant String := "%if yywrap";
   L_331 : aliased constant String := "            if yyWrap then";
   L_332 : aliased constant String := "               yy_c_buf_p := yytext_ptr;";
   L_333 : aliased constant String := "               return ASCII.NUL;";
   L_334 : aliased constant String := "            end if;";
   L_335 : aliased constant String := "";
   L_336 : aliased constant String := "            yy_ch_buf (0) := ASCII.LF;";
   L_337 : aliased constant String := "            yy_n_chars := 1;";
   L_338 : aliased constant String := "            yy_ch_buf (yy_n_chars) := YY_"
       & "END_OF_BUFFER_CHAR;";
   L_339 : aliased constant String := "            yy_ch_buf (yy_n_chars + 1) :="
       & " YY_END_OF_BUFFER_CHAR;";
   L_340 : aliased constant String := "            yy_eof_has_been_seen := False"
       & ";";
   L_341 : aliased constant String := "            yy_c_buf_p := 1;";
   L_342 : aliased constant String := "            yytext_ptr := yy_c_buf_p;";
   L_343 : aliased constant String := "            yy_hold_char := yy_ch_buf (yy"
       & "_c_buf_p);";
   L_344 : aliased constant String := "";
   L_345 : aliased constant String := "            return Input;";
   L_346 : aliased constant String := "%else";
   L_347 : aliased constant String := "            yy_c_buf_p := yytext_ptr;";
   L_348 : aliased constant String := "            return ASCII.NUL;";
   L_349 : aliased constant String := "%end";
   L_350 : aliased constant String := "         when EOB_ACT_RESTART_SCAN =>";
   L_351 : aliased constant String := "            yy_c_buf_p := yytext_ptr;";
   L_352 : aliased constant String := "";
   L_353 : aliased constant String := "         when EOB_ACT_LAST_MATCH =>";
   L_354 : aliased constant String := "            raise UNEXPECTED_LAST_MATCH;";
   L_355 : aliased constant String := "         end case;";
   L_356 : aliased constant String := "      end if;";
   L_357 : aliased constant String := "";
   L_358 : aliased constant String := "      c := yy_ch_buf (yy_c_buf_p);";
   L_359 : aliased constant String := "      yy_c_buf_p := yy_c_buf_p + 1;";
   L_360 : aliased constant String := "      yy_hold_char := yy_ch_buf (yy_c_buf"
       & "_p);";
   L_361 : aliased constant String := "";
   L_362 : aliased constant String := "      return c;";
   L_363 : aliased constant String := "   end Input;";
   L_364 : aliased constant String := "";
   L_365 : aliased constant String := "%end";
   L_366 : aliased constant String := "%if output";
   L_367 : aliased constant String := "   procedure Output (c : Character) is";
   L_368 : aliased constant String := "   begin";
   L_369 : aliased constant String := "      if Ada.Text_IO.Is_Open (user_output"
       & "_file) then";
   L_370 : aliased constant String := "         Ada.Text_IO.Put (user_output_fil"
       & "e, c);";
   L_371 : aliased constant String := "      else";
   L_372 : aliased constant String := "         Ada.Text_IO.Put (c);";
   L_373 : aliased constant String := "      end if;";
   L_374 : aliased constant String := "   end Output;";
   L_375 : aliased constant String := "";
   L_376 : aliased constant String := "   procedure Output_New_Line is";
   L_377 : aliased constant String := "   begin";
   L_378 : aliased constant String := "      if Ada.Text_IO.Is_Open (user_output"
       & "_file) then";
   L_379 : aliased constant String := "         Ada.Text_IO.New_Line (user_outpu"
       & "t_file);";
   L_380 : aliased constant String := "      else";
   L_381 : aliased constant String := "         Ada.Text_IO.New_Line;";
   L_382 : aliased constant String := "      end if;";
   L_383 : aliased constant String := "   end Output_New_Line;";
   L_384 : aliased constant String := "";
   L_385 : aliased constant String := "   function Output_Column return Ada.Text"
       & "_IO.Count is";
   L_386 : aliased constant String := "   begin";
   L_387 : aliased constant String := "      if Ada.Text_IO.Is_Open (user_output"
       & "_file) then";
   L_388 : aliased constant String := "         return Ada.Text_IO.Col (user_out"
       & "put_file);";
   L_389 : aliased constant String := "      else";
   L_390 : aliased constant String := "         return Ada.Text_IO.Col;";
   L_391 : aliased constant String := "      end if;";
   L_392 : aliased constant String := "   end Output_Column;";
   L_393 : aliased constant String := "";
   L_394 : aliased constant String := "%end";
   L_395 : aliased constant String := "%if error";
   L_396 : aliased constant String := "   function Input_Line return Ada.Text_IO"
       & ".Count is";
   L_397 : aliased constant String := "   begin";
   L_398 : aliased constant String := "      return Ada.Text_IO.Count (Line_Numb"
       & "er_Of_Saved_Tok_Line2);";
   L_399 : aliased constant String := "   end Input_Line;";
   L_400 : aliased constant String := "";
   L_401 : aliased constant String := "%end";
   L_402 : aliased constant String := "%if yywrap";
   L_403 : aliased constant String := "   --  default yywrap function - always t"
       & "reat EOF as an EOF";
   L_404 : aliased constant String := "   function yyWrap return Boolean is";
   L_405 : aliased constant String := "   begin";
   L_406 : aliased constant String := "%if yywrapcode";
   L_407 : aliased constant String := "%yywrap";
   L_408 : aliased constant String := "%else";
   L_409 : aliased constant String := "      return True;";
   L_410 : aliased constant String := "%end";
   L_411 : aliased constant String := "   end yyWrap;";
   L_412 : aliased constant String := "";
   L_413 : aliased constant String := "%end";
   L_414 : aliased constant String := "   procedure Open_Input (fname : in Strin"
       & "g) is";
   L_415 : aliased constant String := "   begin";
   L_416 : aliased constant String := "      yy_init := True;";
   L_417 : aliased constant String := "      Ada.Text_IO.Open (user_input_file, "
       & "Ada.Text_IO.In_File, fname);";
   L_418 : aliased constant String := "%if yylineno";
   L_419 : aliased constant String := "      yylineno  := 1;";
   L_420 : aliased constant String := "%end";
   L_421 : aliased constant String := "   end Open_Input;";
   L_422 : aliased constant String := "";
   L_423 : aliased constant String := "%if output";
   L_424 : aliased constant String := "   procedure Create_Output (fname : in St"
       & "ring := """") is";
   L_425 : aliased constant String := "   begin";
   L_426 : aliased constant String := "      if fname /= """" then";
   L_427 : aliased constant String := "         Ada.Text_IO.Create (user_output_"
       & "file, Ada.Text_IO.Out_File, fname);";
   L_428 : aliased constant String := "      end if;";
   L_429 : aliased constant String := "   end Create_Output;";
   L_430 : aliased constant String := "";
   L_431 : aliased constant String := "%end";
   L_432 : aliased constant String := "   procedure Close_Input is";
   L_433 : aliased constant String := "   begin";
   L_434 : aliased constant String := "      if Ada.Text_IO.Is_Open (user_input_"
       & "file) then";
   L_435 : aliased constant String := "         Ada.Text_IO.Close (user_input_fi"
       & "le);";
   L_436 : aliased constant String := "      end if;";
   L_437 : aliased constant String := "   end Close_Input;";
   L_438 : aliased constant String := "";
   L_439 : aliased constant String := "%if output";
   L_440 : aliased constant String := "   procedure Close_Output is";
   L_441 : aliased constant String := "   begin";
   L_442 : aliased constant String := "      if Ada.Text_IO.Is_Open (user_output"
       & "_file) then";
   L_443 : aliased constant String := "         Ada.Text_IO.Close (user_output_f"
       & "ile);";
   L_444 : aliased constant String := "      end if;";
   L_445 : aliased constant String := "   end Close_Output;";
   L_446 : aliased constant String := "";
   L_447 : aliased constant String := "%end";
   L_448 : aliased constant String := "%if error";
   L_449 : aliased constant String := "   procedure Yy_Get_Token_Line ( Yy_Line_"
       & "String : out String;";
   L_450 : aliased constant String := "                                 Yy_Line_"
       & "Length : out Natural ) is";
   L_451 : aliased constant String := "   begin";
   L_452 : aliased constant String := "      --  Currently processing line is ei"
       & "ther in saved token line1 or";
   L_453 : aliased constant String := "      --  in saved token line2.";
   L_454 : aliased constant String := "      if Yy_Line_Number = Line_Number_Of_"
       & "Saved_Tok_Line1 then";
   L_455 : aliased constant String := "         Yy_Line_Length := Saved_Tok_Line"
       & "1.all'length;";
   L_456 : aliased constant String := "         Yy_Line_String ( Yy_Line_String'"
       & "First .. ( Yy_Line_String'First + Saved_Tok_Line1.all'length - 1 ))";
   L_457 : aliased constant String := "           := Saved_Tok_Line1 ( 1 .. Save"
       & "d_Tok_Line1.all'length );";
   L_458 : aliased constant String := "      else";
   L_459 : aliased constant String := "         Yy_Line_Length := Saved_Tok_Line"
       & "2.all'length;";
   L_460 : aliased constant String := "         Yy_Line_String ( Yy_Line_String'"
       & "First .. ( Yy_Line_String'First + Saved_Tok_Line2.all'length - 1 ))";
   L_461 : aliased constant String := "           := Saved_Tok_Line2 ( 1 .. Save"
       & "d_Tok_Line2.all'length );";
   L_462 : aliased constant String := "      end if;";
   L_463 : aliased constant String := "   end Yy_Get_Token_Line;";
   L_464 : aliased constant String := "";
   L_465 : aliased constant String := "   function Yy_Line_Number return Natural"
       & " is";
   L_466 : aliased constant String := "   begin";
   L_467 : aliased constant String := "      return Tok_Begin_Line;";
   L_468 : aliased constant String := "   end Yy_Line_Number;";
   L_469 : aliased constant String := "";
   L_470 : aliased constant String := "   function Yy_Begin_Column return Natura"
       & "l is";
   L_471 : aliased constant String := "   begin";
   L_472 : aliased constant String := "      return Tok_Begin_Col;";
   L_473 : aliased constant String := "   end Yy_Begin_Column;";
   L_474 : aliased constant String := "";
   L_475 : aliased constant String := "   function Yy_End_Column return Natural "
       & "is";
   L_476 : aliased constant String := "   begin";
   L_477 : aliased constant String := "      return Tok_End_Col;";
   L_478 : aliased constant String := "   end Yy_End_Column;";
   L_479 : aliased constant String := "";
   L_480 : aliased constant String := "%end";
   L_481 : aliased constant String := "end ${NAME}_IO;";
   body_io : aliased constant Content_Array :=
     (L_41'Access,
      L_42'Access,
      L_43'Access,
      L_44'Access,
      L_45'Access,
      L_46'Access,
      L_47'Access,
      L_48'Access,
      L_49'Access,
      L_50'Access,
      L_51'Access,
      L_52'Access,
      L_53'Access,
      L_54'Access,
      L_55'Access,
      L_56'Access,
      L_57'Access,
      L_58'Access,
      L_59'Access,
      L_60'Access,
      L_61'Access,
      L_62'Access,
      L_63'Access,
      L_64'Access,
      L_65'Access,
      L_66'Access,
      L_67'Access,
      L_68'Access,
      L_69'Access,
      L_70'Access,
      L_71'Access,
      L_72'Access,
      L_73'Access,
      L_74'Access,
      L_75'Access,
      L_76'Access,
      L_77'Access,
      L_78'Access,
      L_79'Access,
      L_80'Access,
      L_81'Access,
      L_82'Access,
      L_83'Access,
      L_84'Access,
      L_85'Access,
      L_86'Access,
      L_87'Access,
      L_88'Access,
      L_89'Access,
      L_90'Access,
      L_91'Access,
      L_92'Access,
      L_93'Access,
      L_94'Access,
      L_95'Access,
      L_96'Access,
      L_97'Access,
      L_98'Access,
      L_99'Access,
      L_100'Access,
      L_101'Access,
      L_102'Access,
      L_103'Access,
      L_104'Access,
      L_105'Access,
      L_106'Access,
      L_107'Access,
      L_108'Access,
      L_109'Access,
      L_110'Access,
      L_111'Access,
      L_112'Access,
      L_113'Access,
      L_114'Access,
      L_115'Access,
      L_116'Access,
      L_117'Access,
      L_118'Access,
      L_119'Access,
      L_120'Access,
      L_121'Access,
      L_122'Access,
      L_123'Access,
      L_124'Access,
      L_125'Access,
      L_126'Access,
      L_127'Access,
      L_128'Access,
      L_129'Access,
      L_130'Access,
      L_131'Access,
      L_132'Access,
      L_133'Access,
      L_134'Access,
      L_135'Access,
      L_136'Access,
      L_137'Access,
      L_138'Access,
      L_139'Access,
      L_140'Access,
      L_141'Access,
      L_142'Access,
      L_143'Access,
      L_144'Access,
      L_145'Access,
      L_146'Access,
      L_147'Access,
      L_148'Access,
      L_149'Access,
      L_150'Access,
      L_151'Access,
      L_152'Access,
      L_153'Access,
      L_154'Access,
      L_155'Access,
      L_156'Access,
      L_157'Access,
      L_158'Access,
      L_159'Access,
      L_160'Access,
      L_161'Access,
      L_162'Access,
      L_163'Access,
      L_164'Access,
      L_165'Access,
      L_166'Access,
      L_167'Access,
      L_168'Access,
      L_169'Access,
      L_170'Access,
      L_171'Access,
      L_172'Access,
      L_173'Access,
      L_174'Access,
      L_175'Access,
      L_176'Access,
      L_177'Access,
      L_178'Access,
      L_179'Access,
      L_180'Access,
      L_181'Access,
      L_182'Access,
      L_183'Access,
      L_184'Access,
      L_185'Access,
      L_186'Access,
      L_187'Access,
      L_188'Access,
      L_189'Access,
      L_190'Access,
      L_191'Access,
      L_192'Access,
      L_193'Access,
      L_194'Access,
      L_195'Access,
      L_196'Access,
      L_197'Access,
      L_198'Access,
      L_199'Access,
      L_200'Access,
      L_201'Access,
      L_202'Access,
      L_203'Access,
      L_204'Access,
      L_205'Access,
      L_206'Access,
      L_207'Access,
      L_208'Access,
      L_209'Access,
      L_210'Access,
      L_211'Access,
      L_212'Access,
      L_213'Access,
      L_214'Access,
      L_215'Access,
      L_216'Access,
      L_217'Access,
      L_218'Access,
      L_219'Access,
      L_220'Access,
      L_221'Access,
      L_222'Access,
      L_223'Access,
      L_224'Access,
      L_225'Access,
      L_226'Access,
      L_227'Access,
      L_228'Access,
      L_229'Access,
      L_230'Access,
      L_231'Access,
      L_232'Access,
      L_233'Access,
      L_234'Access,
      L_235'Access,
      L_236'Access,
      L_237'Access,
      L_238'Access,
      L_239'Access,
      L_240'Access,
      L_241'Access,
      L_242'Access,
      L_243'Access,
      L_244'Access,
      L_245'Access,
      L_246'Access,
      L_247'Access,
      L_248'Access,
      L_249'Access,
      L_250'Access,
      L_251'Access,
      L_252'Access,
      L_253'Access,
      L_254'Access,
      L_255'Access,
      L_256'Access,
      L_257'Access,
      L_258'Access,
      L_259'Access,
      L_260'Access,
      L_261'Access,
      L_262'Access,
      L_263'Access,
      L_264'Access,
      L_265'Access,
      L_266'Access,
      L_267'Access,
      L_268'Access,
      L_269'Access,
      L_270'Access,
      L_271'Access,
      L_272'Access,
      L_273'Access,
      L_274'Access,
      L_275'Access,
      L_276'Access,
      L_277'Access,
      L_278'Access,
      L_279'Access,
      L_280'Access,
      L_281'Access,
      L_282'Access,
      L_283'Access,
      L_284'Access,
      L_285'Access,
      L_286'Access,
      L_287'Access,
      L_288'Access,
      L_289'Access,
      L_290'Access,
      L_291'Access,
      L_292'Access,
      L_293'Access,
      L_294'Access,
      L_295'Access,
      L_296'Access,
      L_297'Access,
      L_298'Access,
      L_299'Access,
      L_300'Access,
      L_301'Access,
      L_302'Access,
      L_303'Access,
      L_304'Access,
      L_305'Access,
      L_306'Access,
      L_307'Access,
      L_308'Access,
      L_309'Access,
      L_310'Access,
      L_311'Access,
      L_312'Access,
      L_313'Access,
      L_314'Access,
      L_315'Access,
      L_316'Access,
      L_317'Access,
      L_318'Access,
      L_319'Access,
      L_320'Access,
      L_321'Access,
      L_322'Access,
      L_323'Access,
      L_324'Access,
      L_325'Access,
      L_326'Access,
      L_327'Access,
      L_328'Access,
      L_329'Access,
      L_330'Access,
      L_331'Access,
      L_332'Access,
      L_333'Access,
      L_334'Access,
      L_335'Access,
      L_336'Access,
      L_337'Access,
      L_338'Access,
      L_339'Access,
      L_340'Access,
      L_341'Access,
      L_342'Access,
      L_343'Access,
      L_344'Access,
      L_345'Access,
      L_346'Access,
      L_347'Access,
      L_348'Access,
      L_349'Access,
      L_350'Access,
      L_351'Access,
      L_352'Access,
      L_353'Access,
      L_354'Access,
      L_355'Access,
      L_356'Access,
      L_357'Access,
      L_358'Access,
      L_359'Access,
      L_360'Access,
      L_361'Access,
      L_362'Access,
      L_363'Access,
      L_364'Access,
      L_365'Access,
      L_366'Access,
      L_367'Access,
      L_368'Access,
      L_369'Access,
      L_370'Access,
      L_371'Access,
      L_372'Access,
      L_373'Access,
      L_374'Access,
      L_375'Access,
      L_376'Access,
      L_377'Access,
      L_378'Access,
      L_379'Access,
      L_380'Access,
      L_381'Access,
      L_382'Access,
      L_383'Access,
      L_384'Access,
      L_385'Access,
      L_386'Access,
      L_387'Access,
      L_388'Access,
      L_389'Access,
      L_390'Access,
      L_391'Access,
      L_392'Access,
      L_393'Access,
      L_394'Access,
      L_395'Access,
      L_396'Access,
      L_397'Access,
      L_398'Access,
      L_399'Access,
      L_400'Access,
      L_401'Access,
      L_402'Access,
      L_403'Access,
      L_404'Access,
      L_405'Access,
      L_406'Access,
      L_407'Access,
      L_408'Access,
      L_409'Access,
      L_410'Access,
      L_411'Access,
      L_412'Access,
      L_413'Access,
      L_414'Access,
      L_415'Access,
      L_416'Access,
      L_417'Access,
      L_418'Access,
      L_419'Access,
      L_420'Access,
      L_421'Access,
      L_422'Access,
      L_423'Access,
      L_424'Access,
      L_425'Access,
      L_426'Access,
      L_427'Access,
      L_428'Access,
      L_429'Access,
      L_430'Access,
      L_431'Access,
      L_432'Access,
      L_433'Access,
      L_434'Access,
      L_435'Access,
      L_436'Access,
      L_437'Access,
      L_438'Access,
      L_439'Access,
      L_440'Access,
      L_441'Access,
      L_442'Access,
      L_443'Access,
      L_444'Access,
      L_445'Access,
      L_446'Access,
      L_447'Access,
      L_448'Access,
      L_449'Access,
      L_450'Access,
      L_451'Access,
      L_452'Access,
      L_453'Access,
      L_454'Access,
      L_455'Access,
      L_456'Access,
      L_457'Access,
      L_458'Access,
      L_459'Access,
      L_460'Access,
      L_461'Access,
      L_462'Access,
      L_463'Access,
      L_464'Access,
      L_465'Access,
      L_466'Access,
      L_467'Access,
      L_468'Access,
      L_469'Access,
      L_470'Access,
      L_471'Access,
      L_472'Access,
      L_473'Access,
      L_474'Access,
      L_475'Access,
      L_476'Access,
      L_477'Access,
      L_478'Access,
      L_479'Access,
      L_480'Access,
      L_481'Access);

   L_482 : aliased constant String := "--  Warning: This lexical scanner is auto"
       & "matically generated by AFLEX.";
   L_483 : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_484 : aliased constant String := "--  Template: templates/body-lex.adb";
   L_485 : aliased constant String := "%if minimalist";
   L_486 : aliased constant String := "%else";
   L_487 : aliased constant String := "with Ada.Text_IO; use Ada.Text_IO;";
   L_488 : aliased constant String := "%end";
   L_489 : aliased constant String := "%%1 user";
   L_490 : aliased constant String := "";
   L_491 : aliased constant String := "%yydecl";
   L_492 : aliased constant String := "      subtype Short is Integer range -327"
       & "68 .. 32767;";
   L_493 : aliased constant String := "";
   L_494 : aliased constant String := "      --  returned upon end-of-file";
   L_495 : aliased constant String := "      YY_END_TOK : constant Integer := 0;";
   L_496 : aliased constant String := "      subtype yy_state_type is Integer;";
   L_497 : aliased constant String := "%%2 tables";
   L_498 : aliased constant String := "      yy_act : Integer;";
   L_499 : aliased constant String := "      yy_c   : Short;";
   L_500 : aliased constant String := "      yy_current_state : yy_state_type;";
   L_501 : aliased constant String := "";
   L_502 : aliased constant String := "      --  copy whatever the last rule mat"
       & "ched to the standard output";
   L_503 : aliased constant String := "%if echo";
   L_504 : aliased constant String := "      procedure ECHO is";
   L_505 : aliased constant String := "      begin";
   L_506 : aliased constant String := "         if Ada.Text_IO.Is_Open (user_out"
       & "put_file) then";
   L_507 : aliased constant String := "            Ada.Text_IO.Put (user_output_"
       & "file, YYText);";
   L_508 : aliased constant String := "         else";
   L_509 : aliased constant String := "            Ada.Text_IO.Put (YYText);";
   L_510 : aliased constant String := "         end if;";
   L_511 : aliased constant String := "      end ECHO;";
   L_512 : aliased constant String := "%end";
   L_513 : aliased constant String := "";
   L_514 : aliased constant String := "      --  enter a start condition.";
   L_515 : aliased constant String := "      --  Using procedure requires a () a"
       & "fter the ENTER, but makes everything";
   L_516 : aliased constant String := "      --  much neater.";
   L_517 : aliased constant String := "";
   L_518 : aliased constant String := "      procedure ENTER (state : Integer) i"
       & "s";
   L_519 : aliased constant String := "      begin";
   L_520 : aliased constant String := "         yy_start := 1 + 2 * state;";
   L_521 : aliased constant String := "      end ENTER;";
   L_522 : aliased constant String := "";
   L_523 : aliased constant String := "      --  action number for EOF rule of a"
       & " given start state";
   L_524 : aliased constant String := "      function YY_STATE_EOF (state : Inte"
       & "ger) return Integer is";
   L_525 : aliased constant String := "      begin";
   L_526 : aliased constant String := "         return YY_END_OF_BUFFER + state "
       & "+ 1;";
   L_527 : aliased constant String := "      end YY_STATE_EOF;";
   L_528 : aliased constant String := "";
   L_529 : aliased constant String := "      --  return all but the first 'n' ma"
       & "tched characters back to the input stream";
   L_530 : aliased constant String := "      procedure yyless (n : Integer) is";
   L_531 : aliased constant String := "      begin";
   L_532 : aliased constant String := "         yy_ch_buf (yy_cp) := yy_hold_cha"
       & "r; --  undo effects of setting up yytext";
   L_533 : aliased constant String := "         yy_cp := yy_bp + n;";
   L_534 : aliased constant String := "         yy_c_buf_p := yy_cp;";
   L_535 : aliased constant String := "         YY_DO_BEFORE_ACTION; -- set up y"
       & "ytext again";
   L_536 : aliased constant String := "      end yyless;";
   L_537 : aliased constant String := "";
   L_538 : aliased constant String := "%if yyaction";
   L_539 : aliased constant String := "      --  redefine this if you have somet"
       & "hing you want each time.";
   L_540 : aliased constant String := "      procedure YY_USER_ACTION is";
   L_541 : aliased constant String := "      begin";
   L_542 : aliased constant String := "%yyaction";
   L_543 : aliased constant String := "      end YY_USER_ACTION;";
   L_544 : aliased constant String := "%end";
   L_545 : aliased constant String := "      --  yy_get_previous_state - get the"
       & " state just before the EOB char was reached";
   L_546 : aliased constant String := "";
   L_547 : aliased constant String := "      function yy_get_previous_state retu"
       & "rn yy_state_type is";
   L_548 : aliased constant String := "         yy_current_state : yy_state_type"
       & ";";
   L_549 : aliased constant String := "         yy_c : Short;";
   L_550 : aliased constant String := "%%3 ybp";
   L_551 : aliased constant String := "      begin";
   L_552 : aliased constant String := "%%3 startstate";
   L_553 : aliased constant String := "";
   L_554 : aliased constant String := "         for yy_cp in yytext_ptr .. yy_c_"
       & "buf_p - 1 loop";
   L_555 : aliased constant String := "%%4 nextstate";
   L_556 : aliased constant String := "         end loop;";
   L_557 : aliased constant String := "";
   L_558 : aliased constant String := "         return yy_current_state;";
   L_559 : aliased constant String := "      end yy_get_previous_state;";
   L_560 : aliased constant String := "";
   L_561 : aliased constant String := "      procedure yyrestart (input_file : F"
       & "ile_Type) is";
   L_562 : aliased constant String := "      begin";
   L_563 : aliased constant String := "         Open_Input (Ada.Text_IO.Name (in"
       & "put_file));";
   L_564 : aliased constant String := "      end yyrestart;";
   L_565 : aliased constant String := "";
   L_566 : aliased constant String := "   begin -- of ${YYLEX}";
   L_567 : aliased constant String := "      <<new_file>>";
   L_568 : aliased constant String := "      --  this is where we enter upon enc"
       & "ountering an end-of-file and";
   L_569 : aliased constant String := "      --  yyWrap () indicating that we sh"
       & "ould continue processing";
   L_570 : aliased constant String := "";
   L_571 : aliased constant String := "      if yy_init then";
   L_572 : aliased constant String := "%yyinit";
   L_573 : aliased constant String := "         if yy_start = 0 then";
   L_574 : aliased constant String := "            yy_start := 1;      -- first "
       & "start state";
   L_575 : aliased constant String := "         end if;";
   L_576 : aliased constant String := "";
   L_577 : aliased constant String := "         --  we put in the '\n' and start"
       & " reading from [1] so that an";
   L_578 : aliased constant String := "         --  initial match-at-newline wil"
       & "l be true.";
   L_579 : aliased constant String := "";
   L_580 : aliased constant String := "         yy_ch_buf (0) := ASCII.LF;";
   L_581 : aliased constant String := "         yy_n_chars := 1;";
   L_582 : aliased constant String := "";
   L_583 : aliased constant String := "         --  we always need two end-of-bu"
       & "ffer characters. The first causes";
   L_584 : aliased constant String := "         --  a transition to the end-of-b"
       & "uffer state. The second causes";
   L_585 : aliased constant String := "         --  a jam in that state.";
   L_586 : aliased constant String := "";
   L_587 : aliased constant String := "         yy_ch_buf (yy_n_chars) := YY_END"
       & "_OF_BUFFER_CHAR;";
   L_588 : aliased constant String := "         yy_ch_buf (yy_n_chars + 1) := YY"
       & "_END_OF_BUFFER_CHAR;";
   L_589 : aliased constant String := "";
   L_590 : aliased constant String := "         yy_eof_has_been_seen := False;";
   L_591 : aliased constant String := "";
   L_592 : aliased constant String := "         yytext_ptr := 1;";
   L_593 : aliased constant String := "         yy_c_buf_p := yytext_ptr;";
   L_594 : aliased constant String := "         yy_hold_char := yy_ch_buf (yy_c_"
       & "buf_p);";
   L_595 : aliased constant String := "         yy_init := False;";
   L_596 : aliased constant String := "%if error";
   L_597 : aliased constant String := "         --   Initialization";
   L_598 : aliased constant String := "         tok_begin_line := 1;";
   L_599 : aliased constant String := "         tok_end_line := 1;";
   L_600 : aliased constant String := "         tok_begin_col := 0;";
   L_601 : aliased constant String := "         tok_end_col := 0;";
   L_602 : aliased constant String := "         token_at_end_of_line := False;";
   L_603 : aliased constant String := "         line_number_of_saved_tok_line1 :"
       & "= 0;";
   L_604 : aliased constant String := "         line_number_of_saved_tok_line2 :"
       & "= 0;";
   L_605 : aliased constant String := "%end";
   L_606 : aliased constant String := "      end if; -- yy_init";
   L_607 : aliased constant String := "";
   L_608 : aliased constant String := "      loop                -- loops until "
       & "end-of-file is reached";
   L_609 : aliased constant String := "%if error";
   L_610 : aliased constant String := "         --    if last matched token is e"
       & "nd_of_line, we must";
   L_611 : aliased constant String := "         --    update the token_end_line "
       & "and reset tok_end_col.";
   L_612 : aliased constant String := "         if Token_At_End_Of_Line then";
   L_613 : aliased constant String := "            Tok_End_Line := Tok_End_Line "
       & "+ 1;";
   L_614 : aliased constant String := "            Tok_End_Col := 0;";
   L_615 : aliased constant String := "            Token_At_End_Of_Line := False"
       & ";";
   L_616 : aliased constant String := "         end if;";
   L_617 : aliased constant String := "%end";
   L_618 : aliased constant String := "";
   L_619 : aliased constant String := "         yy_cp := yy_c_buf_p;";
   L_620 : aliased constant String := "";
   L_621 : aliased constant String := "         --  support of yytext";
   L_622 : aliased constant String := "         yy_ch_buf (yy_cp) := yy_hold_cha"
       & "r;";
   L_623 : aliased constant String := "";
   L_624 : aliased constant String := "         --  yy_bp points to the position"
       & " in yy_ch_buf of the start of the";
   L_625 : aliased constant String := "         --  current run.";
   L_626 : aliased constant String := "%%5 action";
   L_627 : aliased constant String := "";
   L_628 : aliased constant String := "   <<next_action>>";
   L_629 : aliased constant String := "%%6 action";
   L_630 : aliased constant String := "         YY_DO_BEFORE_ACTION;";
   L_631 : aliased constant String := "%if yyaction";
   L_632 : aliased constant String := "         YY_USER_ACTION;";
   L_633 : aliased constant String := "%end";
   L_634 : aliased constant String := "";
   L_635 : aliased constant String := "         if aflex_debug then  -- output a"
       & "cceptance info. for (-d) debug mode";
   L_636 : aliased constant String := "            Ada.Text_IO.Put (Standard_Err"
       & "or, ""  -- Aflex.YYLex accept rule #"");";
   L_637 : aliased constant String := "            Ada.Text_IO.Put (Standard_Err"
       & "or, Integer'Image (yy_act));";
   L_638 : aliased constant String := "            Ada.Text_IO.Put_Line (Standar"
       & "d_Error, ""("""""" & YYText & """""")"");";
   L_639 : aliased constant String := "         end if;";
   L_640 : aliased constant String := "%if error";
   L_641 : aliased constant String := "         --   Update tok_begin_line, tok_"
       & "end_line, tok_begin_col and tok_end_col";
   L_642 : aliased constant String := "         --   after matching the token.";
   L_643 : aliased constant String := "         if yy_act /= YY_END_OF_BUFFER an"
       & "d then yy_act /= 0 then";
   L_644 : aliased constant String := "            -- Token are matched only whe"
       & "n yy_act is not yy_end_of_buffer or 0.";
   L_645 : aliased constant String := "            Tok_Begin_Line := Tok_End_Lin"
       & "e;";
   L_646 : aliased constant String := "            Tok_Begin_Col := Tok_End_Col "
       & "+ 1;";
   L_647 : aliased constant String := "            Tok_End_Col := Tok_Begin_Col "
       & "+ yy_cp - yy_bp - 1;";
   L_648 : aliased constant String := "            if yy_ch_buf ( yy_bp ) = ASCI"
       & "I.LF then";
   L_649 : aliased constant String := "               Token_At_End_Of_Line := Tr"
       & "ue;";
   L_650 : aliased constant String := "            end if;";
   L_651 : aliased constant String := "         end if;";
   L_652 : aliased constant String := "%end";
   L_653 : aliased constant String := "";
   L_654 : aliased constant String := "   <<do_action>>   -- this label is used "
       & "only to access EOF actions";
   L_655 : aliased constant String := "         case yy_act is";
   L_656 : aliased constant String := "";
   L_657 : aliased constant String := "%%7 action";
   L_658 : aliased constant String := "";
   L_659 : aliased constant String := "         when YY_END_OF_BUFFER =>";
   L_660 : aliased constant String := "            --  undo the effects of YY_DO"
       & "_BEFORE_ACTION";
   L_661 : aliased constant String := "            yy_ch_buf (yy_cp) := yy_hold_"
       & "char;";
   L_662 : aliased constant String := "";
   L_663 : aliased constant String := "            yytext_ptr := yy_bp;";
   L_664 : aliased constant String := "";
   L_665 : aliased constant String := "            case yy_get_next_buffer is";
   L_666 : aliased constant String := "               when EOB_ACT_END_OF_FILE ="
       & ">";
   L_667 : aliased constant String := "                  if yyWrap then";
   L_668 : aliased constant String := "                     --  note: because we"
       & "'ve taken care in";
   L_669 : aliased constant String := "                     --  yy_get_next_buff"
       & "er() to have set up yytext,";
   L_670 : aliased constant String := "                     --  we can now set u"
       & "p yy_c_buf_p so that if some";
   L_671 : aliased constant String := "                     --  total hoser (lik"
       & "e aflex itself) wants";
   L_672 : aliased constant String := "                     --  to call the scan"
       & "ner after we return the";
   L_673 : aliased constant String := "                     --  End_Of_Input, it"
       & "'ll still work - another";
   L_674 : aliased constant String := "                     --  End_Of_Input wil"
       & "l get returned.";
   L_675 : aliased constant String := "";
   L_676 : aliased constant String := "                     yy_c_buf_p := yytext"
       & "_ptr;";
   L_677 : aliased constant String := "";
   L_678 : aliased constant String := "                     yy_act := YY_STATE_E"
       & "OF ((yy_start - 1) / 2);";
   L_679 : aliased constant String := "";
   L_680 : aliased constant String := "                     goto do_action;";
   L_681 : aliased constant String := "                  else";
   L_682 : aliased constant String := "                     --  start processing"
       & " a new file";
   L_683 : aliased constant String := "                     yy_init := True;";
   L_684 : aliased constant String := "                     goto new_file;";
   L_685 : aliased constant String := "                  end if;";
   L_686 : aliased constant String := "";
   L_687 : aliased constant String := "               when EOB_ACT_RESTART_SCAN "
       & "=>";
   L_688 : aliased constant String := "                  yy_c_buf_p := yytext_pt"
       & "r;";
   L_689 : aliased constant String := "                  yy_hold_char := yy_ch_b"
       & "uf (yy_c_buf_p);";
   L_690 : aliased constant String := "";
   L_691 : aliased constant String := "               when EOB_ACT_LAST_MATCH =>";
   L_692 : aliased constant String := "                  yy_c_buf_p := yy_n_char"
       & "s;";
   L_693 : aliased constant String := "                  yy_current_state := yy_"
       & "get_previous_state;";
   L_694 : aliased constant String := "                  yy_cp := yy_c_buf_p;";
   L_695 : aliased constant String := "                  yy_bp := yytext_ptr;";
   L_696 : aliased constant String := "                  goto next_action;";
   L_697 : aliased constant String := "            end case; --  case yy_get_nex"
       & "t_buffer()";
   L_698 : aliased constant String := "";
   L_699 : aliased constant String := "         when others =>";
   L_700 : aliased constant String := "            Ada.Text_IO.Put (""action # """
       & ");";
   L_701 : aliased constant String := "            Ada.Text_IO.Put (Integer'Imag"
       & "e (yy_act));";
   L_702 : aliased constant String := "            Ada.Text_IO.New_Line;";
   L_703 : aliased constant String := "            raise AFLEX_INTERNAL_ERROR;";
   L_704 : aliased constant String := "         end case; --  case (yy_act)";
   L_705 : aliased constant String := "      end loop; --  end of loop waiting f"
       & "or end of file";
   L_706 : aliased constant String := "   end ${YYLEX};";
   L_707 : aliased constant String := "";
   L_708 : aliased constant String := "%%8 user";
   body_lex : aliased constant Content_Array :=
     (L_482'Access,
      L_483'Access,
      L_484'Access,
      L_485'Access,
      L_486'Access,
      L_487'Access,
      L_488'Access,
      L_489'Access,
      L_490'Access,
      L_491'Access,
      L_492'Access,
      L_493'Access,
      L_494'Access,
      L_495'Access,
      L_496'Access,
      L_497'Access,
      L_498'Access,
      L_499'Access,
      L_500'Access,
      L_501'Access,
      L_502'Access,
      L_503'Access,
      L_504'Access,
      L_505'Access,
      L_506'Access,
      L_507'Access,
      L_508'Access,
      L_509'Access,
      L_510'Access,
      L_511'Access,
      L_512'Access,
      L_513'Access,
      L_514'Access,
      L_515'Access,
      L_516'Access,
      L_517'Access,
      L_518'Access,
      L_519'Access,
      L_520'Access,
      L_521'Access,
      L_522'Access,
      L_523'Access,
      L_524'Access,
      L_525'Access,
      L_526'Access,
      L_527'Access,
      L_528'Access,
      L_529'Access,
      L_530'Access,
      L_531'Access,
      L_532'Access,
      L_533'Access,
      L_534'Access,
      L_535'Access,
      L_536'Access,
      L_537'Access,
      L_538'Access,
      L_539'Access,
      L_540'Access,
      L_541'Access,
      L_542'Access,
      L_543'Access,
      L_544'Access,
      L_545'Access,
      L_546'Access,
      L_547'Access,
      L_548'Access,
      L_549'Access,
      L_550'Access,
      L_551'Access,
      L_552'Access,
      L_553'Access,
      L_554'Access,
      L_555'Access,
      L_556'Access,
      L_557'Access,
      L_558'Access,
      L_559'Access,
      L_560'Access,
      L_561'Access,
      L_562'Access,
      L_563'Access,
      L_564'Access,
      L_565'Access,
      L_566'Access,
      L_567'Access,
      L_568'Access,
      L_569'Access,
      L_570'Access,
      L_571'Access,
      L_572'Access,
      L_573'Access,
      L_574'Access,
      L_575'Access,
      L_576'Access,
      L_577'Access,
      L_578'Access,
      L_579'Access,
      L_580'Access,
      L_581'Access,
      L_582'Access,
      L_583'Access,
      L_584'Access,
      L_585'Access,
      L_586'Access,
      L_587'Access,
      L_588'Access,
      L_589'Access,
      L_590'Access,
      L_591'Access,
      L_592'Access,
      L_593'Access,
      L_594'Access,
      L_595'Access,
      L_596'Access,
      L_597'Access,
      L_598'Access,
      L_599'Access,
      L_600'Access,
      L_601'Access,
      L_602'Access,
      L_603'Access,
      L_604'Access,
      L_605'Access,
      L_606'Access,
      L_607'Access,
      L_608'Access,
      L_609'Access,
      L_610'Access,
      L_611'Access,
      L_612'Access,
      L_613'Access,
      L_614'Access,
      L_615'Access,
      L_616'Access,
      L_617'Access,
      L_618'Access,
      L_619'Access,
      L_620'Access,
      L_621'Access,
      L_622'Access,
      L_623'Access,
      L_624'Access,
      L_625'Access,
      L_626'Access,
      L_627'Access,
      L_628'Access,
      L_629'Access,
      L_630'Access,
      L_631'Access,
      L_632'Access,
      L_633'Access,
      L_634'Access,
      L_635'Access,
      L_636'Access,
      L_637'Access,
      L_638'Access,
      L_639'Access,
      L_640'Access,
      L_641'Access,
      L_642'Access,
      L_643'Access,
      L_644'Access,
      L_645'Access,
      L_646'Access,
      L_647'Access,
      L_648'Access,
      L_649'Access,
      L_650'Access,
      L_651'Access,
      L_652'Access,
      L_653'Access,
      L_654'Access,
      L_655'Access,
      L_656'Access,
      L_657'Access,
      L_658'Access,
      L_659'Access,
      L_660'Access,
      L_661'Access,
      L_662'Access,
      L_663'Access,
      L_664'Access,
      L_665'Access,
      L_666'Access,
      L_667'Access,
      L_668'Access,
      L_669'Access,
      L_670'Access,
      L_671'Access,
      L_672'Access,
      L_673'Access,
      L_674'Access,
      L_675'Access,
      L_676'Access,
      L_677'Access,
      L_678'Access,
      L_679'Access,
      L_680'Access,
      L_681'Access,
      L_682'Access,
      L_683'Access,
      L_684'Access,
      L_685'Access,
      L_686'Access,
      L_687'Access,
      L_688'Access,
      L_689'Access,
      L_690'Access,
      L_691'Access,
      L_692'Access,
      L_693'Access,
      L_694'Access,
      L_695'Access,
      L_696'Access,
      L_697'Access,
      L_698'Access,
      L_699'Access,
      L_700'Access,
      L_701'Access,
      L_702'Access,
      L_703'Access,
      L_704'Access,
      L_705'Access,
      L_706'Access,
      L_707'Access,
      L_708'Access);

   L_709 : aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_710 : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_711 : aliased constant String := "--  Template: templates/body-reentrant-df"
       & "a.adb";
   L_712 : aliased constant String := "package body ${NAME}_DFA is";
   L_713 : aliased constant String := "";
   L_714 : aliased constant String := "   --  Nov 2002. Fixed insufficient buffe"
       & "r size bug causing";
   L_715 : aliased constant String := "   --  damage to comments at about the 10"
       & "00-th character";
   L_716 : aliased constant String := "";
   L_717 : aliased constant String := "   function YYText (Context : in Context_"
       & "Type) return String is";
   L_718 : aliased constant String := "      J : Integer := Context.yytext_ptr;";
   L_719 : aliased constant String := "   begin";
   L_720 : aliased constant String := "      while J <= Context.yy_ch_buf'Last a"
       & "nd then Context.yy_ch_buf (J) /= ASCII.NUL loop";
   L_721 : aliased constant String := "         J := J + 1;";
   L_722 : aliased constant String := "      end loop;";
   L_723 : aliased constant String := "";
   L_724 : aliased constant String := "      declare";
   L_725 : aliased constant String := "         subtype Sliding_Type is String ("
       & "1 .. J - Context.yytext_ptr);";
   L_726 : aliased constant String := "      begin";
   L_727 : aliased constant String := "         return Sliding_Type (Context.yy_"
       & "ch_buf (Context.yytext_ptr .. J - 1));";
   L_728 : aliased constant String := "      end;";
   L_729 : aliased constant String := "   end YYText;";
   L_730 : aliased constant String := "";
   L_731 : aliased constant String := "   --  Returns the length of the matched "
       & "text";
   L_732 : aliased constant String := "";
   L_733 : aliased constant String := "   function YYLength (Context : in Contex"
       & "t_Type) return Integer is";
   L_734 : aliased constant String := "   begin";
   L_735 : aliased constant String := "      return Context.yy_cp - Context.yy_b"
       & "p;";
   L_736 : aliased constant String := "   end YYLength;";
   L_737 : aliased constant String := "";
   L_738 : aliased constant String := "   --  Done after the current pattern has"
       & " been matched and before the";
   L_739 : aliased constant String := "   --  corresponding action - sets up yyt"
       & "ext";
   L_740 : aliased constant String := "";
   L_741 : aliased constant String := "   procedure YY_DO_BEFORE_ACTION (Context"
       & " : in out Context_Type) is";
   L_742 : aliased constant String := "   begin";
   L_743 : aliased constant String := "      Context.yytext_ptr := Context.yy_bp"
       & ";";
   L_744 : aliased constant String := "      Context.yy_hold_char := Context.yy_"
       & "ch_buf (Context.yy_cp);";
   L_745 : aliased constant String := "      Context.yy_ch_buf (Context.yy_cp) :"
       & "= ASCII.NUL;";
   L_746 : aliased constant String := "      Context.yy_c_buf_p := Context.yy_cp"
       & ";";
   L_747 : aliased constant String := "   end YY_DO_BEFORE_ACTION;";
   L_748 : aliased constant String := "";
   L_749 : aliased constant String := "end ${NAME}_DFA;";
   body_reentrant_dfa : aliased constant Content_Array :=
     (L_709'Access,
      L_710'Access,
      L_711'Access,
      L_712'Access,
      L_713'Access,
      L_714'Access,
      L_715'Access,
      L_716'Access,
      L_717'Access,
      L_718'Access,
      L_719'Access,
      L_720'Access,
      L_721'Access,
      L_722'Access,
      L_723'Access,
      L_724'Access,
      L_725'Access,
      L_726'Access,
      L_727'Access,
      L_728'Access,
      L_729'Access,
      L_730'Access,
      L_731'Access,
      L_732'Access,
      L_733'Access,
      L_734'Access,
      L_735'Access,
      L_736'Access,
      L_737'Access,
      L_738'Access,
      L_739'Access,
      L_740'Access,
      L_741'Access,
      L_742'Access,
      L_743'Access,
      L_744'Access,
      L_745'Access,
      L_746'Access,
      L_747'Access,
      L_748'Access,
      L_749'Access);

   L_750 : aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_751 : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_752 : aliased constant String := "--  Template: templates/body-reentrant-io"
       & ".adb";
   L_753 : aliased constant String := "package body ${NAME}_IO is";
   L_754 : aliased constant String := "";
   L_755 : aliased constant String := "   --  gets input and stuffs it into 'buf"
       & "'.  number of characters read, or YY_NULL,";
   L_756 : aliased constant String := "   --  is returned in 'result'.";
   L_757 : aliased constant String := "";
   L_758 : aliased constant String := "   procedure YY_INPUT (Context  : in out "
       & "Context_Type;";
   L_759 : aliased constant String := "                       buf      : out unb"
       & "ounded_character_array;";
   L_760 : aliased constant String := "                       result   : out Int"
       & "eger;";
   L_761 : aliased constant String := "                       max_size : in Inte"
       & "ger) is";
   L_762 : aliased constant String := "      c   : Character;";
   L_763 : aliased constant String := "      i   : Integer := 1;";
   L_764 : aliased constant String := "      loc : Integer := buf'First;";
   L_765 : aliased constant String := "%if error";
   L_766 : aliased constant String := "   --    Since buf is an out parameter wh"
       & "ich is not readable";
   L_767 : aliased constant String := "   --    and saved lines is a string poin"
       & "ter which space must";
   L_768 : aliased constant String := "   --    be allocated after we know the s"
       & "ize, we maintain";
   L_769 : aliased constant String := "   --    an extra buffer to collect the i"
       & "nput line and";
   L_770 : aliased constant String := "   --    save it into the saved line 2.";
   L_771 : aliased constant String := "      Temp_Line : String (1 .. YY_BUF_SIZ"
       & "E + 2);";
   L_772 : aliased constant String := "%end";
   L_773 : aliased constant String := "   begin";
   L_774 : aliased constant String := "%if error";
   L_775 : aliased constant String := "      -- buf := ( others => ASCII.NUL ); "
       & "-- CvdL: does not work in GNAT";
   L_776 : aliased constant String := "      for j in buf'First .. buf'Last loop";
   L_777 : aliased constant String := "         buf (j) := ASCII.NUL;";
   L_778 : aliased constant String := "      end loop;";
   L_779 : aliased constant String := "      -- Move the saved lines forward.";
   L_780 : aliased constant String := "      Context.Saved_Tok_Line1 := Context."
       & "Saved_Tok_Line2;";
   L_781 : aliased constant String := "      Context.Line_Number_Of_Saved_Tok_Li"
       & "ne1 := Context.Line_Number_Of_Saved_Tok_Line2;";
   L_782 : aliased constant String := "";
   L_783 : aliased constant String := "%end";
   L_784 : aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_input_file) then";
   L_785 : aliased constant String := "         while i <= max_size loop";
   L_786 : aliased constant String := "            --  Ada ate our newline, put "
       & "it back on the end.";
   L_787 : aliased constant String := "            if Ada.Text_IO.End_Of_Line (C"
       & "ontext.user_input_file) then";
   L_788 : aliased constant String := "               buf (loc) := ASCII.LF;";
   L_789 : aliased constant String := "               Ada.Text_IO.Skip_Line (Con"
       & "text.user_input_file, 1);";
   L_790 : aliased constant String := "%if error";
   L_791 : aliased constant String := "               --   We try to get one lin"
       & "e by one line. So we return";
   L_792 : aliased constant String := "               --   here because we saw t"
       & "he end_of_line.";
   L_793 : aliased constant String := "               result := i;";
   L_794 : aliased constant String := "               Temp_Line (i) := ASCII.LF;";
   L_795 : aliased constant String := "               Context.Saved_Tok_Line2 :="
       & " new String (1 .. i);";
   L_796 : aliased constant String := "               Context.Saved_Tok_Line2 (1"
       & " .. i) := Temp_Line (1 .. i);";
   L_797 : aliased constant String := "               Context.Line_Number_Of_Sav"
       & "ed_Tok_Line2 := Context.Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_798 : aliased constant String := "               return;";
   L_799 : aliased constant String := "%end";
   L_800 : aliased constant String := "%if interactive";
   L_801 : aliased constant String := "               i := i + 1; --  update cou"
       & "nter, miss end of loop";
   L_802 : aliased constant String := "               exit; --  in interactive m"
       & "ode return at end of line.";
   L_803 : aliased constant String := "%end";
   L_804 : aliased constant String := "            else";
   L_805 : aliased constant String := "               --  UCI CODES CHANGED:";
   L_806 : aliased constant String := "               --    The following codes "
       & "are modified. Previous codes is commented out.";
   L_807 : aliased constant String := "               --    The purpose of doing"
       & " this is to make it possible to set Temp_Line";
   L_808 : aliased constant String := "               --    in Ayacc-extension s"
       & "pecific codes. Definitely, we can read the character";
   L_809 : aliased constant String := "               --    into the Temp_Line a"
       & "nd then set the buf. But Temp_Line will only";
   L_810 : aliased constant String := "               --    be used in Ayacc-ext"
       & "ension specific codes which makes";
   L_811 : aliased constant String := "               --    this approach imposs"
       & "ible.";
   L_812 : aliased constant String := "               Ada.Text_IO.Get (Context.u"
       & "ser_input_file, c);";
   L_813 : aliased constant String := "               buf (loc) := c;";
   L_814 : aliased constant String := "--             Ada.Text_IO.Get (Context.u"
       & "ser_input_file, buf (loc));";
   L_815 : aliased constant String := "%if error";
   L_816 : aliased constant String := "               Temp_Line (i) := c;";
   L_817 : aliased constant String := "%end";
   L_818 : aliased constant String := "            end if;";
   L_819 : aliased constant String := "";
   L_820 : aliased constant String := "            loc := loc + 1;";
   L_821 : aliased constant String := "            i := i + 1;";
   L_822 : aliased constant String := "         end loop;";
   L_823 : aliased constant String := "      else";
   L_824 : aliased constant String := "         while i <= max_size loop";
   L_825 : aliased constant String := "            if Ada.Text_IO.End_Of_Line th"
       & "en -- Ada ate our newline, put it back on the end.";
   L_826 : aliased constant String := "               buf (loc) := ASCII.LF;";
   L_827 : aliased constant String := "               Ada.Text_IO.Skip_Line (1);";
   L_828 : aliased constant String := "%if error";
   L_829 : aliased constant String := "               --   We try to get one lin"
       & "e by one line. So we return";
   L_830 : aliased constant String := "               --   here because we saw t"
       & "he end_of_line.";
   L_831 : aliased constant String := "               result := i;";
   L_832 : aliased constant String := "               Temp_Line (i) := ASCII.LF;";
   L_833 : aliased constant String := "               Context.Saved_Tok_Line2 :="
       & " new String (1 .. i);";
   L_834 : aliased constant String := "               Context.Saved_Tok_Line2 (1"
       & " .. i) := Temp_Line (1 .. i);";
   L_835 : aliased constant String := "               Context.Line_Number_Of_Sav"
       & "ed_Tok_Line2 := Context.Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_836 : aliased constant String := "               return;";
   L_837 : aliased constant String := "%end";
   L_838 : aliased constant String := "";
   L_839 : aliased constant String := "            else";
   L_840 : aliased constant String := "               --  The following codes ar"
       & "e modified. Previous codes is commented out.";
   L_841 : aliased constant String := "               --  The purpose of doing t"
       & "his is to make it possible to set Temp_Line";
   L_842 : aliased constant String := "               --  in Ayacc-extension spe"
       & "cific codes. Definitely, we can read the character";
   L_843 : aliased constant String := "               --  into the Temp_Line and"
       & " then set the buf. But Temp_Line will only";
   L_844 : aliased constant String := "               --  be used in Ayacc-exten"
       & "sion specific codes which makes this approach impossible.";
   L_845 : aliased constant String := "               Ada.Text_IO.Get (c);";
   L_846 : aliased constant String := "               buf (loc) := c;";
   L_847 : aliased constant String := "%if error";
   L_848 : aliased constant String := "               Temp_Line (i) := c;";
   L_849 : aliased constant String := "%end";
   L_850 : aliased constant String := "            end if;";
   L_851 : aliased constant String := "";
   L_852 : aliased constant String := "            loc := loc + 1;";
   L_853 : aliased constant String := "            i := i + 1;";
   L_854 : aliased constant String := "         end loop;";
   L_855 : aliased constant String := "      end if; --  for input file being st"
       & "andard input";
   L_856 : aliased constant String := "      result := i - 1;";
   L_857 : aliased constant String := "";
   L_858 : aliased constant String := "%if error";
   L_859 : aliased constant String := "      --  Since we get one line by one li"
       & "ne, if we";
   L_860 : aliased constant String := "      --  reach here, it means that curre"
       & "nt line have";
   L_861 : aliased constant String := "      --  more that max_size characters. "
       & "So it is";
   L_862 : aliased constant String := "      --  impossible to hold the whole li"
       & "ne. We";
   L_863 : aliased constant String := "      --  report the warning message and "
       & "continue.";
   L_864 : aliased constant String := "      buf (loc - 1) := Ascii.LF;";
   L_865 : aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_input_file) then";
   L_866 : aliased constant String := "         Ada.Text_IO.Skip_Line (Context.u"
       & "ser_input_file, 1);";
   L_867 : aliased constant String := "      else";
   L_868 : aliased constant String := "         Ada.Text_IO.Skip_Line (1);";
   L_869 : aliased constant String := "      end if;";
   L_870 : aliased constant String := "      Temp_Line (i - 1) := ASCII.LF;";
   L_871 : aliased constant String := "      Context.Saved_Tok_Line2 := new Stri"
       & "ng (1 .. i - 1);";
   L_872 : aliased constant String := "      Context.Saved_Tok_Line2 (1 .. i - 1"
       & ") := Temp_Line (1 .. i - 1);";
   L_873 : aliased constant String := "      Context.Line_Number_Of_Saved_Tok_Li"
       & "ne2 := Context.Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_874 : aliased constant String := "      Put_Line (""Input line """;
   L_875 : aliased constant String := "                & Integer'Image ( Context"
       & ".Line_Number_Of_Saved_Tok_Line2 )";
   L_876 : aliased constant String := "                & ""has more than """;
   L_877 : aliased constant String := "                & Integer'Image ( max_siz"
       & "e )";
   L_878 : aliased constant String := "                & "" characters, ... trun"
       & "cated."" );";
   L_879 : aliased constant String := "%end";
   L_880 : aliased constant String := "   exception";
   L_881 : aliased constant String := "      when Ada.Text_IO.End_Error =>";
   L_882 : aliased constant String := "         result := i - 1;";
   L_883 : aliased constant String := "         --  when we hit EOF we need to s"
       & "et yy_eof_has_been_seen";
   L_884 : aliased constant String := "         Context.yy_eof_has_been_seen := "
       & "True;";
   L_885 : aliased constant String := "%if error";
   L_886 : aliased constant String := "         --   Processing incomplete line.";
   L_887 : aliased constant String := "         if i /= 1 then";
   L_888 : aliased constant String := "            -- Current line is not empty "
       & "but do not have end_of_line.";
   L_889 : aliased constant String := "            -- So current line is incompl"
       & "ete line. But we still need";
   L_890 : aliased constant String := "            -- to save it.";
   L_891 : aliased constant String := "            Context.Saved_Tok_Line2 := ne"
       & "w String (1 .. i - 1);";
   L_892 : aliased constant String := "            Context.Saved_Tok_Line2 (1 .."
       & " i - 1) := Temp_Line (1 .. i - 1);";
   L_893 : aliased constant String := "            Context.Line_Number_Of_Saved_"
       & "Tok_Line2 := Context.Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_894 : aliased constant String := "         end if;";
   L_895 : aliased constant String := "%end";
   L_896 : aliased constant String := "   end YY_INPUT;";
   L_897 : aliased constant String := "";
   L_898 : aliased constant String := "   --  yy_get_next_buffer - try to read i"
       & "n new buffer";
   L_899 : aliased constant String := "   --";
   L_900 : aliased constant String := "   --  returns a code representing an act"
       & "ion";
   L_901 : aliased constant String := "   --     EOB_ACT_LAST_MATCH -";
   L_902 : aliased constant String := "   --     EOB_ACT_RESTART_SCAN - restart "
       & "the scanner";
   L_903 : aliased constant String := "   --     EOB_ACT_END_OF_FILE - end of fi"
       & "le";
   L_904 : aliased constant String := "";
   L_905 : aliased constant String := "   function yy_get_next_buffer (Context :"
       & " in out Context_Type) return eob_action_type is";
   L_906 : aliased constant String := "      dest           : Integer := 0;";
   L_907 : aliased constant String := "      source         : Integer := Context"
       & ".dfa.yytext_ptr - 1; -- copy prev. char, too";
   L_908 : aliased constant String := "      number_to_move : Integer;";
   L_909 : aliased constant String := "      ret_val        : eob_action_type;";
   L_910 : aliased constant String := "      num_to_read    : Integer;";
   L_911 : aliased constant String := "   begin";
   L_912 : aliased constant String := "      if Context.dfa.yy_c_buf_p > Context"
       & ".yy_n_chars + 1 then";
   L_913 : aliased constant String := "         raise NULL_IN_INPUT;";
   L_914 : aliased constant String := "      end if;";
   L_915 : aliased constant String := "";
   L_916 : aliased constant String := "      --  try to read more data";
   L_917 : aliased constant String := "";
   L_918 : aliased constant String := "      --  first move last chars to start "
       & "of buffer";
   L_919 : aliased constant String := "      number_to_move := Context.dfa.yy_c_"
       & "buf_p - Context.dfa.yytext_ptr;";
   L_920 : aliased constant String := "";
   L_921 : aliased constant String := "      for i in 0 .. number_to_move - 1 lo"
       & "op";
   L_922 : aliased constant String := "         Context.dfa.yy_ch_buf (dest) := "
       & "Context.dfa.yy_ch_buf (source);";
   L_923 : aliased constant String := "         dest := dest + 1;";
   L_924 : aliased constant String := "         source := source + 1;";
   L_925 : aliased constant String := "      end loop;";
   L_926 : aliased constant String := "";
   L_927 : aliased constant String := "      if Context.yy_eof_has_been_seen the"
       & "n";
   L_928 : aliased constant String := "         --  don't do the read, it's not "
       & "guaranteed to return an EOF,";
   L_929 : aliased constant String := "         --  just force an EOF";
   L_930 : aliased constant String := "";
   L_931 : aliased constant String := "         Context.yy_n_chars := 0;";
   L_932 : aliased constant String := "      else";
   L_933 : aliased constant String := "         num_to_read := YY_BUF_SIZE - num"
       & "ber_to_move - 1;";
   L_934 : aliased constant String := "";
   L_935 : aliased constant String := "         if num_to_read > YY_READ_BUF_SIZ"
       & "E then";
   L_936 : aliased constant String := "            num_to_read := YY_READ_BUF_SI"
       & "ZE;";
   L_937 : aliased constant String := "         end if;";
   L_938 : aliased constant String := "";
   L_939 : aliased constant String := "         --  read in more data";
   L_940 : aliased constant String := "         YY_INPUT (Context,";
   L_941 : aliased constant String := "                   Context.dfa.yy_ch_buf "
       & "(number_to_move .. Context.dfa.yy_ch_buf'Last),";
   L_942 : aliased constant String := "                   Context.yy_n_chars, nu"
       & "m_to_read);";
   L_943 : aliased constant String := "      end if;";
   L_944 : aliased constant String := "      if Context.yy_n_chars = 0 then";
   L_945 : aliased constant String := "         if number_to_move = 1 then";
   L_946 : aliased constant String := "            ret_val := EOB_ACT_END_OF_FIL"
       & "E;";
   L_947 : aliased constant String := "         else";
   L_948 : aliased constant String := "            ret_val := EOB_ACT_LAST_MATCH"
       & ";";
   L_949 : aliased constant String := "         end if;";
   L_950 : aliased constant String := "";
   L_951 : aliased constant String := "         Context.yy_eof_has_been_seen := "
       & "True;";
   L_952 : aliased constant String := "      else";
   L_953 : aliased constant String := "         ret_val := EOB_ACT_RESTART_SCAN;";
   L_954 : aliased constant String := "      end if;";
   L_955 : aliased constant String := "";
   L_956 : aliased constant String := "      Context.yy_n_chars := Context.yy_n_"
       & "chars + number_to_move;";
   L_957 : aliased constant String := "      Context.dfa.yy_ch_buf (Context.yy_n"
       & "_chars) := YY_END_OF_BUFFER_CHAR;";
   L_958 : aliased constant String := "      Context.dfa.yy_ch_buf (Context.yy_n"
       & "_chars + 1) := YY_END_OF_BUFFER_CHAR;";
   L_959 : aliased constant String := "";
   L_960 : aliased constant String := "      --  yytext begins at the second cha"
       & "racter in";
   L_961 : aliased constant String := "      --  yy_ch_buf; the first character "
       & "is the one which";
   L_962 : aliased constant String := "      --  preceded it before reading in t"
       & "he latest buffer;";
   L_963 : aliased constant String := "      --  it needs to be kept around in c"
       & "ase it's a";
   L_964 : aliased constant String := "      --  newline, so yy_get_previous_sta"
       & "te() will have";
   L_965 : aliased constant String := "      --  with '^' rules active";
   L_966 : aliased constant String := "";
   L_967 : aliased constant String := "      Context.dfa.yytext_ptr := 1;";
   L_968 : aliased constant String := "";
   L_969 : aliased constant String := "      return ret_val;";
   L_970 : aliased constant String := "   end yy_get_next_buffer;";
   L_971 : aliased constant String := "";
   L_972 : aliased constant String := "%if unput";
   L_973 : aliased constant String := "   procedure yyUnput (Context : in out Co"
       & "ntext_Type;";
   L_974 : aliased constant String := "                      c : Character; yy_b"
       & "p : in out Integer) is";
   L_975 : aliased constant String := "      number_to_move : Integer;";
   L_976 : aliased constant String := "      dest : Integer;";
   L_977 : aliased constant String := "      source : Integer;";
   L_978 : aliased constant String := "      tmp_yy_cp : Integer;";
   L_979 : aliased constant String := "   begin";
   L_980 : aliased constant String := "      tmp_yy_cp := Context.dfa.yy_c_buf_p"
       & ";";
   L_981 : aliased constant String := "      --  undo effects of setting up yyte"
       & "xt";
   L_982 : aliased constant String := "      Context.dfa.yy_ch_buf (tmp_yy_cp) :"
       & "= Context.dfa.yy_hold_char;";
   L_983 : aliased constant String := "";
   L_984 : aliased constant String := "      if tmp_yy_cp < 2 then";
   L_985 : aliased constant String := "         --  need to shift things up to m"
       & "ake room";
   L_986 : aliased constant String := "         number_to_move := Context.yy_n_c"
       & "hars + 2; --  +2 for EOB chars";
   L_987 : aliased constant String := "         dest := YY_BUF_SIZE + 2;";
   L_988 : aliased constant String := "         source := number_to_move;";
   L_989 : aliased constant String := "";
   L_990 : aliased constant String := "         while source > 0 loop";
   L_991 : aliased constant String := "            dest := dest - 1;";
   L_992 : aliased constant String := "            source := source - 1;";
   L_993 : aliased constant String := "            Context.dfa.yy_ch_buf (dest) "
       & ":= Context.dfa.yy_ch_buf (source);";
   L_994 : aliased constant String := "         end loop;";
   L_995 : aliased constant String := "";
   L_996 : aliased constant String := "         tmp_yy_cp := tmp_yy_cp + dest - "
       & "source;";
   L_997 : aliased constant String := "         Context.dfa.yy_bp := Context.dfa"
       & ".yy_bp + dest - source;";
   L_998 : aliased constant String := "         Context.yy_n_chars := YY_BUF_SIZ"
       & "E;";
   L_999 : aliased constant String := "";
   L_1000: aliased constant String := "         if tmp_yy_cp < 2 then";
   L_1001: aliased constant String := "            raise PUSHBACK_OVERFLOW;";
   L_1002: aliased constant String := "         end if;";
   L_1003: aliased constant String := "      end if;";
   L_1004: aliased constant String := "";
   L_1005: aliased constant String := "      if tmp_yy_cp > yy_bp";
   L_1006: aliased constant String := "        and then Context.dfa.yy_ch_buf (t"
       & "mp_yy_cp - 1) = ASCII.LF";
   L_1007: aliased constant String := "      then";
   L_1008: aliased constant String := "         Context.dfa.yy_ch_buf (tmp_yy_cp"
       & " - 2) := ASCII.LF;";
   L_1009: aliased constant String := "      end if;";
   L_1010: aliased constant String := "";
   L_1011: aliased constant String := "      tmp_yy_cp := tmp_yy_cp - 1;";
   L_1012: aliased constant String := "      Context.dfa.yy_ch_buf (tmp_yy_cp) :"
       & "= c;";
   L_1013: aliased constant String := "";
   L_1014: aliased constant String := "      --  Note:  this code is the text of"
       & " YY_DO_BEFORE_ACTION, only";
   L_1015: aliased constant String := "      --         here we get different yy"
       & "_cp and yy_bp's";
   L_1016: aliased constant String := "      Context.dfa.yytext_ptr := Context.d"
       & "fa.yy_bp;";
   L_1017: aliased constant String := "      Context.dfa.yy_hold_char := Context"
       & ".dfa.yy_ch_buf (tmp_yy_cp);";
   L_1018: aliased constant String := "      Context.dfa.yy_ch_buf (tmp_yy_cp) :"
       & "= ASCII.NUL;";
   L_1019: aliased constant String := "      Context.dfa.yy_c_buf_p := tmp_yy_cp"
       & ";";
   L_1020: aliased constant String := "   end yyUnput;";
   L_1021: aliased constant String := "";
   L_1022: aliased constant String := "   procedure Unput (Context : in out Cont"
       & "ext_Type; c : Character) is";
   L_1023: aliased constant String := "   begin";
   L_1024: aliased constant String := "      yyUnput (Context, c, Context.dfa.yy"
       & "_bp);";
   L_1025: aliased constant String := "   end Unput;";
   L_1026: aliased constant String := "";
   L_1027: aliased constant String := "%end";
   L_1028: aliased constant String := "%if input";
   L_1029: aliased constant String := "   function Input (Context : in out Conte"
       & "xt_Type) return Character is";
   L_1030: aliased constant String := "      c : Character;";
   L_1031: aliased constant String := "   begin";
   L_1032: aliased constant String := "      Context.dfa.yy_ch_buf (Context.dfa."
       & "yy_c_buf_p) := Context.dfa.yy_hold_char;";
   L_1033: aliased constant String := "";
   L_1034: aliased constant String := "      if Context.dfa.yy_ch_buf (Context.d"
       & "fa.yy_c_buf_p) = YY_END_OF_BUFFER_CHAR then";
   L_1035: aliased constant String := "         --  need more input";
   L_1036: aliased constant String := "         Context.dfa.yytext_ptr := Contex"
       & "t.dfa.yy_c_buf_p;";
   L_1037: aliased constant String := "         Context.dfa.yy_c_buf_p := Contex"
       & "t.dfa.yy_c_buf_p + 1;";
   L_1038: aliased constant String := "";
   L_1039: aliased constant String := "         case yy_get_next_buffer (Context"
       & ") is";
   L_1040: aliased constant String := "            --  this code, unfortunately,"
       & " is somewhat redundant with";
   L_1041: aliased constant String := "            --  that above";
   L_1042: aliased constant String := "";
   L_1043: aliased constant String := "         when EOB_ACT_END_OF_FILE =>";
   L_1044: aliased constant String := "%if yywrap";
   L_1045: aliased constant String := "            if yyWrap (Context) then";
   L_1046: aliased constant String := "               Context.dfa.yy_c_buf_p := "
       & "Context.dfa.yytext_ptr;";
   L_1047: aliased constant String := "               return ASCII.NUL;";
   L_1048: aliased constant String := "            end if;";
   L_1049: aliased constant String := "";
   L_1050: aliased constant String := "            Context.dfa.yy_ch_buf (0) := "
       & "ASCII.LF;";
   L_1051: aliased constant String := "            Context.yy_n_chars := 1;";
   L_1052: aliased constant String := "            Context.dfa.yy_ch_buf (Contex"
       & "t.yy_n_chars) := YY_END_OF_BUFFER_CHAR;";
   L_1053: aliased constant String := "            Context.dfa.yy_ch_buf (Contex"
       & "t.yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;";
   L_1054: aliased constant String := "            Context.yy_eof_has_been_seen "
       & ":= False;";
   L_1055: aliased constant String := "            Context.yy_c_buf_p := 1;";
   L_1056: aliased constant String := "            Context.dfa.yytext_ptr := Con"
       & "text.dfa.yy_c_buf_p;";
   L_1057: aliased constant String := "            Context.dfa.yy_hold_char := C"
       & "ontext.dfa.yy_ch_buf (Context.yy_c_buf_p);";
   L_1058: aliased constant String := "";
   L_1059: aliased constant String := "            return Input;";
   L_1060: aliased constant String := "%else";
   L_1061: aliased constant String := "            Context.dfa.yy_c_buf_p := Con"
       & "text.dfa.yytext_ptr;";
   L_1062: aliased constant String := "            return ASCII.NUL;";
   L_1063: aliased constant String := "%end";
   L_1064: aliased constant String := "         when EOB_ACT_RESTART_SCAN =>";
   L_1065: aliased constant String := "            Context.dfa.yy_c_buf_p := Con"
       & "text.dfa.yytext_ptr;";
   L_1066: aliased constant String := "";
   L_1067: aliased constant String := "         when EOB_ACT_LAST_MATCH =>";
   L_1068: aliased constant String := "            raise UNEXPECTED_LAST_MATCH;";
   L_1069: aliased constant String := "         end case;";
   L_1070: aliased constant String := "      end if;";
   L_1071: aliased constant String := "";
   L_1072: aliased constant String := "      c := Context.dfa.yy_ch_buf (Context"
       & ".dfa.yy_c_buf_p);";
   L_1073: aliased constant String := "      Context.dfa.yy_c_buf_p := Context.d"
       & "fa.yy_c_buf_p + 1;";
   L_1074: aliased constant String := "      Context.dfa.yy_hold_char := Context"
       & ".dfa.yy_ch_buf (Context.dfa.yy_c_buf_p);";
   L_1075: aliased constant String := "";
   L_1076: aliased constant String := "      return c;";
   L_1077: aliased constant String := "   end Input;";
   L_1078: aliased constant String := "";
   L_1079: aliased constant String := "%end";
   L_1080: aliased constant String := "%if output";
   L_1081: aliased constant String := "   procedure Output (Context : in out Con"
       & "text_Type; c : Character) is";
   L_1082: aliased constant String := "   begin";
   L_1083: aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_output_file) then";
   L_1084: aliased constant String := "         Ada.Text_IO.Put (Context.user_ou"
       & "tput_file, c);";
   L_1085: aliased constant String := "      else";
   L_1086: aliased constant String := "         Ada.Text_IO.Put (c);";
   L_1087: aliased constant String := "      end if;";
   L_1088: aliased constant String := "   end Output;";
   L_1089: aliased constant String := "";
   L_1090: aliased constant String := "   procedure Output_New_Line (Context : i"
       & "n out Context_Type) is";
   L_1091: aliased constant String := "   begin";
   L_1092: aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_output_file) then";
   L_1093: aliased constant String := "         Ada.Text_IO.New_Line (Context.us"
       & "er_output_file);";
   L_1094: aliased constant String := "      else";
   L_1095: aliased constant String := "         Ada.Text_IO.New_Line;";
   L_1096: aliased constant String := "      end if;";
   L_1097: aliased constant String := "   end Output_New_Line;";
   L_1098: aliased constant String := "";
   L_1099: aliased constant String := "   function Output_Column (Context : in C"
       & "ontext_Type) return Ada.Text_IO.Count is";
   L_1100: aliased constant String := "   begin";
   L_1101: aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_output_file) then";
   L_1102: aliased constant String := "         return Ada.Text_IO.Col (Context."
       & "user_output_file);";
   L_1103: aliased constant String := "      else";
   L_1104: aliased constant String := "         return Ada.Text_IO.Col;";
   L_1105: aliased constant String := "      end if;";
   L_1106: aliased constant String := "   end Output_Column;";
   L_1107: aliased constant String := "";
   L_1108: aliased constant String := "%end";
   L_1109: aliased constant String := "%if error";
   L_1110: aliased constant String := "   function Input_Line (Context : in Cont"
       & "ext_Type) return Ada.Text_IO.Count is";
   L_1111: aliased constant String := "   begin";
   L_1112: aliased constant String := "      return Ada.Text_IO.Count (Context.L"
       & "ine_Number_Of_Saved_Tok_Line2);";
   L_1113: aliased constant String := "   end Input_Line;";
   L_1114: aliased constant String := "";
   L_1115: aliased constant String := "%end";
   L_1116: aliased constant String := "%if yywrap";
   L_1117: aliased constant String := "   --  default yywrap function - always t"
       & "reat EOF as an EOF";
   L_1118: aliased constant String := "   function yyWrap (Context : in Context_"
       & "Type) return Boolean is";
   L_1119: aliased constant String := "   begin";
   L_1120: aliased constant String := "%if yywrapcode";
   L_1121: aliased constant String := "%yywrap";
   L_1122: aliased constant String := "%else";
   L_1123: aliased constant String := "      return True;";
   L_1124: aliased constant String := "%end";
   L_1125: aliased constant String := "   end yyWrap;";
   L_1126: aliased constant String := "";
   L_1127: aliased constant String := "%end";
   L_1128: aliased constant String := "   procedure Open_Input (Context : in out"
       & " Context_Type; fname : in String) is";
   L_1129: aliased constant String := "   begin";
   L_1130: aliased constant String := "      Context.dfa.yy_init := True;";
   L_1131: aliased constant String := "      Ada.Text_IO.Open (Context.user_inpu"
       & "t_file, Ada.Text_IO.In_File, fname);";
   L_1132: aliased constant String := "%if yylineno";
   L_1133: aliased constant String := "      Context.dfa.yylineno  := 1;";
   L_1134: aliased constant String := "      Context.dfa.yylinecol := 0;";
   L_1135: aliased constant String := "%end";
   L_1136: aliased constant String := "   end Open_Input;";
   L_1137: aliased constant String := "";
   L_1138: aliased constant String := "%if output";
   L_1139: aliased constant String := "   procedure Create_Output (Context : in "
       & "out Context_Type; fname : in String := """") is";
   L_1140: aliased constant String := "   begin";
   L_1141: aliased constant String := "      if fname /= """" then";
   L_1142: aliased constant String := "         Ada.Text_IO.Create (Context.user"
       & "_output_file, Ada.Text_IO.Out_File, fname);";
   L_1143: aliased constant String := "      end if;";
   L_1144: aliased constant String := "   end Create_Output;";
   L_1145: aliased constant String := "";
   L_1146: aliased constant String := "%end";
   L_1147: aliased constant String := "   procedure Close_Input (Context : in ou"
       & "t Context_Type) is";
   L_1148: aliased constant String := "   begin";
   L_1149: aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_input_file) then";
   L_1150: aliased constant String := "         Ada.Text_IO.Close (Context.user_"
       & "input_file);";
   L_1151: aliased constant String := "      end if;";
   L_1152: aliased constant String := "   end Close_Input;";
   L_1153: aliased constant String := "";
   L_1154: aliased constant String := "%if output";
   L_1155: aliased constant String := "   procedure Close_Output (Context : in o"
       & "ut Context_Type) is";
   L_1156: aliased constant String := "   begin";
   L_1157: aliased constant String := "      if Ada.Text_IO.Is_Open (Context.use"
       & "r_output_file) then";
   L_1158: aliased constant String := "         Ada.Text_IO.Close (Context.user_"
       & "output_file);";
   L_1159: aliased constant String := "      end if;";
   L_1160: aliased constant String := "   end Close_Output;";
   L_1161: aliased constant String := "";
   L_1162: aliased constant String := "%end";
   L_1163: aliased constant String := "%if error";
   L_1164: aliased constant String := "   procedure Yy_Get_Token_Line (Context :"
       & " in out Context_Type;";
   L_1165: aliased constant String := "                                Yy_Line_S"
       & "tring : out String;";
   L_1166: aliased constant String := "                                Yy_Line_L"
       & "ength : out Natural ) is";
   L_1167: aliased constant String := "   begin";
   L_1168: aliased constant String := "      --  Currently processing line is ei"
       & "ther in saved token line1 or";
   L_1169: aliased constant String := "      --  in saved token line2.";
   L_1170: aliased constant String := "      if Context.Yy_Line_Number = Context"
       & ".Line_Number_Of_Saved_Tok_Line1 then";
   L_1171: aliased constant String := "         Context.Yy_Line_Length := Contex"
       & "t.Saved_Tok_Line1.all'length;";
   L_1172: aliased constant String := "         Context.Yy_Line_String ( Context"
       & ".Yy_Line_String'First .. ( Context.Yy_Line_String'First + Context.Saved_"
       & "Tok_Line1.all'length - 1 ))";
   L_1173: aliased constant String := "           := Context.Saved_Tok_Line1 ( 1"
       & " .. Context.Saved_Tok_Line1.all'length );";
   L_1174: aliased constant String := "      else";
   L_1175: aliased constant String := "         Context.Yy_Line_Length := Contex"
       & "t.Saved_Tok_Line2.all'length;";
   L_1176: aliased constant String := "         Context.Yy_Line_String ( Context"
       & ".Yy_Line_String'First .. ( Context.Yy_Line_String'First + Context.Saved_"
       & "Tok_Line2.all'length - 1 ))";
   L_1177: aliased constant String := "           := Context.Saved_Tok_Line2 ( 1"
       & " .. Context.Saved_Tok_Line2.all'length );";
   L_1178: aliased constant String := "      end if;";
   L_1179: aliased constant String := "   end Yy_Get_Token_Line;";
   L_1180: aliased constant String := "";
   L_1181: aliased constant String := "   function Yy_Line_Number (Context : in "
       & "Context_Type) return Natural is";
   L_1182: aliased constant String := "   begin";
   L_1183: aliased constant String := "      return Context.dfa.Tok_Begin_Line;";
   L_1184: aliased constant String := "   end Yy_Line_Number;";
   L_1185: aliased constant String := "";
   L_1186: aliased constant String := "   function Yy_Begin_Column (Context : in"
       & " Context_Type) return Natural is";
   L_1187: aliased constant String := "   begin";
   L_1188: aliased constant String := "      return Context.dfa.Tok_Begin_Col;";
   L_1189: aliased constant String := "   end Yy_Begin_Column;";
   L_1190: aliased constant String := "";
   L_1191: aliased constant String := "   function Yy_End_Column (Context : in C"
       & "ontext_Type) return Natural is";
   L_1192: aliased constant String := "   begin";
   L_1193: aliased constant String := "      return Context.dfa.Tok_End_Col;";
   L_1194: aliased constant String := "   end Yy_End_Column;";
   L_1195: aliased constant String := "";
   L_1196: aliased constant String := "%end";
   L_1197: aliased constant String := "end ${NAME}_IO;";
   body_reentrant_io : aliased constant Content_Array :=
     (L_750'Access,
      L_751'Access,
      L_752'Access,
      L_753'Access,
      L_754'Access,
      L_755'Access,
      L_756'Access,
      L_757'Access,
      L_758'Access,
      L_759'Access,
      L_760'Access,
      L_761'Access,
      L_762'Access,
      L_763'Access,
      L_764'Access,
      L_765'Access,
      L_766'Access,
      L_767'Access,
      L_768'Access,
      L_769'Access,
      L_770'Access,
      L_771'Access,
      L_772'Access,
      L_773'Access,
      L_774'Access,
      L_775'Access,
      L_776'Access,
      L_777'Access,
      L_778'Access,
      L_779'Access,
      L_780'Access,
      L_781'Access,
      L_782'Access,
      L_783'Access,
      L_784'Access,
      L_785'Access,
      L_786'Access,
      L_787'Access,
      L_788'Access,
      L_789'Access,
      L_790'Access,
      L_791'Access,
      L_792'Access,
      L_793'Access,
      L_794'Access,
      L_795'Access,
      L_796'Access,
      L_797'Access,
      L_798'Access,
      L_799'Access,
      L_800'Access,
      L_801'Access,
      L_802'Access,
      L_803'Access,
      L_804'Access,
      L_805'Access,
      L_806'Access,
      L_807'Access,
      L_808'Access,
      L_809'Access,
      L_810'Access,
      L_811'Access,
      L_812'Access,
      L_813'Access,
      L_814'Access,
      L_815'Access,
      L_816'Access,
      L_817'Access,
      L_818'Access,
      L_819'Access,
      L_820'Access,
      L_821'Access,
      L_822'Access,
      L_823'Access,
      L_824'Access,
      L_825'Access,
      L_826'Access,
      L_827'Access,
      L_828'Access,
      L_829'Access,
      L_830'Access,
      L_831'Access,
      L_832'Access,
      L_833'Access,
      L_834'Access,
      L_835'Access,
      L_836'Access,
      L_837'Access,
      L_838'Access,
      L_839'Access,
      L_840'Access,
      L_841'Access,
      L_842'Access,
      L_843'Access,
      L_844'Access,
      L_845'Access,
      L_846'Access,
      L_847'Access,
      L_848'Access,
      L_849'Access,
      L_850'Access,
      L_851'Access,
      L_852'Access,
      L_853'Access,
      L_854'Access,
      L_855'Access,
      L_856'Access,
      L_857'Access,
      L_858'Access,
      L_859'Access,
      L_860'Access,
      L_861'Access,
      L_862'Access,
      L_863'Access,
      L_864'Access,
      L_865'Access,
      L_866'Access,
      L_867'Access,
      L_868'Access,
      L_869'Access,
      L_870'Access,
      L_871'Access,
      L_872'Access,
      L_873'Access,
      L_874'Access,
      L_875'Access,
      L_876'Access,
      L_877'Access,
      L_878'Access,
      L_879'Access,
      L_880'Access,
      L_881'Access,
      L_882'Access,
      L_883'Access,
      L_884'Access,
      L_885'Access,
      L_886'Access,
      L_887'Access,
      L_888'Access,
      L_889'Access,
      L_890'Access,
      L_891'Access,
      L_892'Access,
      L_893'Access,
      L_894'Access,
      L_895'Access,
      L_896'Access,
      L_897'Access,
      L_898'Access,
      L_899'Access,
      L_900'Access,
      L_901'Access,
      L_902'Access,
      L_903'Access,
      L_904'Access,
      L_905'Access,
      L_906'Access,
      L_907'Access,
      L_908'Access,
      L_909'Access,
      L_910'Access,
      L_911'Access,
      L_912'Access,
      L_913'Access,
      L_914'Access,
      L_915'Access,
      L_916'Access,
      L_917'Access,
      L_918'Access,
      L_919'Access,
      L_920'Access,
      L_921'Access,
      L_922'Access,
      L_923'Access,
      L_924'Access,
      L_925'Access,
      L_926'Access,
      L_927'Access,
      L_928'Access,
      L_929'Access,
      L_930'Access,
      L_931'Access,
      L_932'Access,
      L_933'Access,
      L_934'Access,
      L_935'Access,
      L_936'Access,
      L_937'Access,
      L_938'Access,
      L_939'Access,
      L_940'Access,
      L_941'Access,
      L_942'Access,
      L_943'Access,
      L_944'Access,
      L_945'Access,
      L_946'Access,
      L_947'Access,
      L_948'Access,
      L_949'Access,
      L_950'Access,
      L_951'Access,
      L_952'Access,
      L_953'Access,
      L_954'Access,
      L_955'Access,
      L_956'Access,
      L_957'Access,
      L_958'Access,
      L_959'Access,
      L_960'Access,
      L_961'Access,
      L_962'Access,
      L_963'Access,
      L_964'Access,
      L_965'Access,
      L_966'Access,
      L_967'Access,
      L_968'Access,
      L_969'Access,
      L_970'Access,
      L_971'Access,
      L_972'Access,
      L_973'Access,
      L_974'Access,
      L_975'Access,
      L_976'Access,
      L_977'Access,
      L_978'Access,
      L_979'Access,
      L_980'Access,
      L_981'Access,
      L_982'Access,
      L_983'Access,
      L_984'Access,
      L_985'Access,
      L_986'Access,
      L_987'Access,
      L_988'Access,
      L_989'Access,
      L_990'Access,
      L_991'Access,
      L_992'Access,
      L_993'Access,
      L_994'Access,
      L_995'Access,
      L_996'Access,
      L_997'Access,
      L_998'Access,
      L_999'Access,
      L_1000'Access,
      L_1001'Access,
      L_1002'Access,
      L_1003'Access,
      L_1004'Access,
      L_1005'Access,
      L_1006'Access,
      L_1007'Access,
      L_1008'Access,
      L_1009'Access,
      L_1010'Access,
      L_1011'Access,
      L_1012'Access,
      L_1013'Access,
      L_1014'Access,
      L_1015'Access,
      L_1016'Access,
      L_1017'Access,
      L_1018'Access,
      L_1019'Access,
      L_1020'Access,
      L_1021'Access,
      L_1022'Access,
      L_1023'Access,
      L_1024'Access,
      L_1025'Access,
      L_1026'Access,
      L_1027'Access,
      L_1028'Access,
      L_1029'Access,
      L_1030'Access,
      L_1031'Access,
      L_1032'Access,
      L_1033'Access,
      L_1034'Access,
      L_1035'Access,
      L_1036'Access,
      L_1037'Access,
      L_1038'Access,
      L_1039'Access,
      L_1040'Access,
      L_1041'Access,
      L_1042'Access,
      L_1043'Access,
      L_1044'Access,
      L_1045'Access,
      L_1046'Access,
      L_1047'Access,
      L_1048'Access,
      L_1049'Access,
      L_1050'Access,
      L_1051'Access,
      L_1052'Access,
      L_1053'Access,
      L_1054'Access,
      L_1055'Access,
      L_1056'Access,
      L_1057'Access,
      L_1058'Access,
      L_1059'Access,
      L_1060'Access,
      L_1061'Access,
      L_1062'Access,
      L_1063'Access,
      L_1064'Access,
      L_1065'Access,
      L_1066'Access,
      L_1067'Access,
      L_1068'Access,
      L_1069'Access,
      L_1070'Access,
      L_1071'Access,
      L_1072'Access,
      L_1073'Access,
      L_1074'Access,
      L_1075'Access,
      L_1076'Access,
      L_1077'Access,
      L_1078'Access,
      L_1079'Access,
      L_1080'Access,
      L_1081'Access,
      L_1082'Access,
      L_1083'Access,
      L_1084'Access,
      L_1085'Access,
      L_1086'Access,
      L_1087'Access,
      L_1088'Access,
      L_1089'Access,
      L_1090'Access,
      L_1091'Access,
      L_1092'Access,
      L_1093'Access,
      L_1094'Access,
      L_1095'Access,
      L_1096'Access,
      L_1097'Access,
      L_1098'Access,
      L_1099'Access,
      L_1100'Access,
      L_1101'Access,
      L_1102'Access,
      L_1103'Access,
      L_1104'Access,
      L_1105'Access,
      L_1106'Access,
      L_1107'Access,
      L_1108'Access,
      L_1109'Access,
      L_1110'Access,
      L_1111'Access,
      L_1112'Access,
      L_1113'Access,
      L_1114'Access,
      L_1115'Access,
      L_1116'Access,
      L_1117'Access,
      L_1118'Access,
      L_1119'Access,
      L_1120'Access,
      L_1121'Access,
      L_1122'Access,
      L_1123'Access,
      L_1124'Access,
      L_1125'Access,
      L_1126'Access,
      L_1127'Access,
      L_1128'Access,
      L_1129'Access,
      L_1130'Access,
      L_1131'Access,
      L_1132'Access,
      L_1133'Access,
      L_1134'Access,
      L_1135'Access,
      L_1136'Access,
      L_1137'Access,
      L_1138'Access,
      L_1139'Access,
      L_1140'Access,
      L_1141'Access,
      L_1142'Access,
      L_1143'Access,
      L_1144'Access,
      L_1145'Access,
      L_1146'Access,
      L_1147'Access,
      L_1148'Access,
      L_1149'Access,
      L_1150'Access,
      L_1151'Access,
      L_1152'Access,
      L_1153'Access,
      L_1154'Access,
      L_1155'Access,
      L_1156'Access,
      L_1157'Access,
      L_1158'Access,
      L_1159'Access,
      L_1160'Access,
      L_1161'Access,
      L_1162'Access,
      L_1163'Access,
      L_1164'Access,
      L_1165'Access,
      L_1166'Access,
      L_1167'Access,
      L_1168'Access,
      L_1169'Access,
      L_1170'Access,
      L_1171'Access,
      L_1172'Access,
      L_1173'Access,
      L_1174'Access,
      L_1175'Access,
      L_1176'Access,
      L_1177'Access,
      L_1178'Access,
      L_1179'Access,
      L_1180'Access,
      L_1181'Access,
      L_1182'Access,
      L_1183'Access,
      L_1184'Access,
      L_1185'Access,
      L_1186'Access,
      L_1187'Access,
      L_1188'Access,
      L_1189'Access,
      L_1190'Access,
      L_1191'Access,
      L_1192'Access,
      L_1193'Access,
      L_1194'Access,
      L_1195'Access,
      L_1196'Access,
      L_1197'Access);

   L_1198: aliased constant String := "--  Warning: This lexical scanner is auto"
       & "matically generated by AFLEX.";
   L_1199: aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_1200: aliased constant String := "--  Template: templates/body-reentrant-le"
       & "x.adb";
   L_1201: aliased constant String := "%if minimalist";
   L_1202: aliased constant String := "%else";
   L_1203: aliased constant String := "with Ada.Text_IO; use Ada.Text_IO;";
   L_1204: aliased constant String := "%end";
   L_1205: aliased constant String := "%%1 user";
   L_1206: aliased constant String := "";
   L_1207: aliased constant String := "%yydecl";
   L_1208: aliased constant String := "      subtype Short is Integer range -327"
       & "68 .. 32767;";
   L_1209: aliased constant String := "      yy_act : Integer;";
   L_1210: aliased constant String := "      yy_c   : Short;";
   L_1211: aliased constant String := "";
   L_1212: aliased constant String := "      --  returned upon end-of-file";
   L_1213: aliased constant String := "      YY_END_TOK : constant Integer := 0;";
   L_1214: aliased constant String := "      subtype yy_state_type is Integer;";
   L_1215: aliased constant String := "      yy_current_state : yy_state_type;";
   L_1216: aliased constant String := "";
   L_1217: aliased constant String := "      yylinecol : Integer renames ${YYVAR"
       & "}.dfa.yylinecol;";
   L_1218: aliased constant String := "      yylineno  : Integer renames ${YYVAR"
       & "}.dfa.yylineno;";
   L_1219: aliased constant String := "      yy_last_yylinecol : Integer renames"
       & " ${YYVAR}.dfa.yy_last_yylinecol;";
   L_1220: aliased constant String := "      yy_last_yylineno  : Integer renames"
       & " ${YYVAR}.dfa.yy_last_yylineno;";
   L_1221: aliased constant String := "      yy_eof_has_been_seen : Boolean rena"
       & "mes ${YYVAR}.yy_eof_has_been_seen;";
   L_1222: aliased constant String := "      aflex_debug : Boolean renames ${YYV"
       & "AR}.dfa.aflex_debug;";
   L_1223: aliased constant String := "      yy_init  : Boolean renames ${YYVAR}"
       & ".dfa.yy_init;";
   L_1224: aliased constant String := "      yy_c_buf_p  : Index renames ${YYVAR"
       & "}.dfa.yy_c_buf_p;";
   L_1225: aliased constant String := "      yy_start : yy_state_type renames ${"
       & "YYVAR}.dfa.yy_start;";
   L_1226: aliased constant String := "      yy_cp    : Index renames ${YYVAR}.d"
       & "fa.yy_cp;";
   L_1227: aliased constant String := "      yy_bp    : Index renames ${YYVAR}.d"
       & "fa.yy_bp;";
   L_1228: aliased constant String := "      yytext_ptr   : Index renames ${YYVA"
       & "R}.dfa.yytext_ptr;";
   L_1229: aliased constant String := "      yy_last_accepting_state : Lexer_DFA"
       & ".yy_state_type renames ${YYVAR}.dfa.yy_last_accepting_state;";
   L_1230: aliased constant String := "      yy_last_accepting_cpos  : Index ren"
       & "ames ${YYVAR}.dfa.yy_last_accepting_cpos;";
   L_1231: aliased constant String := "      yy_hold_char  : Character renames $"
       & "{YYVAR}.dfa.yy_hold_char;";
   L_1232: aliased constant String := "      yy_ch_buf     : Lexer_DFA.ch_buf_ty"
       & "pe renames ${YYVAR}.dfa.yy_ch_buf;";
   L_1233: aliased constant String := "      yy_n_chars    : Index renames ${YYV"
       & "AR}.yy_n_chars;";
   L_1234: aliased constant String := "      YYLVal : YYSType renames ${YYVAR}.Y"
       & "YLVal;";
   L_1235: aliased constant String := "      YYVal  : YYSType renames ${YYVAR}.Y"
       & "YVal;";
   L_1236: aliased constant String := "";
   L_1237: aliased constant String := "      function yy_get_next_buffer return "
       & "Lexer_IO.eob_action_type";
   L_1238: aliased constant String := "        is (Lexer_IO.yy_get_next_buffer ("
       & "${YYVAR}));";
   L_1239: aliased constant String := "";
   L_1240: aliased constant String := "      function YYText return String";
   L_1241: aliased constant String := "        is (Lexer_DFA.YYText (${YYVAR}.df"
       & "a));";
   L_1242: aliased constant String := "";
   L_1243: aliased constant String := "      procedure YY_DO_BEFORE_ACTION is";
   L_1244: aliased constant String := "      begin";
   L_1245: aliased constant String := "        Lexer_DFA.YY_DO_BEFORE_ACTION (${"
       & "YYVAR}.dfa);";
   L_1246: aliased constant String := "      end YY_DO_BEFORE_ACTION;";
   L_1247: aliased constant String := "";
   L_1248: aliased constant String := "%%2 tables";
   L_1249: aliased constant String := "";
   L_1250: aliased constant String := "      --  copy whatever the last rule mat"
       & "ched to the standard output";
   L_1251: aliased constant String := "%if echo";
   L_1252: aliased constant String := "      procedure ECHO is";
   L_1253: aliased constant String := "      begin";
   L_1254: aliased constant String := "         if Ada.Text_IO.Is_Open (user_out"
       & "put_file) then";
   L_1255: aliased constant String := "            Ada.Text_IO.Put (user_output_"
       & "file, YYText);";
   L_1256: aliased constant String := "         else";
   L_1257: aliased constant String := "            Ada.Text_IO.Put (YYText);";
   L_1258: aliased constant String := "         end if;";
   L_1259: aliased constant String := "      end ECHO;";
   L_1260: aliased constant String := "%end";
   L_1261: aliased constant String := "";
   L_1262: aliased constant String := "      --  enter a start condition.";
   L_1263: aliased constant String := "      --  Using procedure requires a () a"
       & "fter the ENTER, but makes everything";
   L_1264: aliased constant String := "      --  much neater.";
   L_1265: aliased constant String := "";
   L_1266: aliased constant String := "      procedure ENTER (state : Integer) i"
       & "s";
   L_1267: aliased constant String := "      begin";
   L_1268: aliased constant String := "         yy_start := 1 + 2 * state;";
   L_1269: aliased constant String := "      end ENTER;";
   L_1270: aliased constant String := "";
   L_1271: aliased constant String := "      --  action number for EOF rule of a"
       & " given start state";
   L_1272: aliased constant String := "      function YY_STATE_EOF (state : Inte"
       & "ger) return Integer is";
   L_1273: aliased constant String := "      begin";
   L_1274: aliased constant String := "         return YY_END_OF_BUFFER + state "
       & "+ 1;";
   L_1275: aliased constant String := "      end YY_STATE_EOF;";
   L_1276: aliased constant String := "";
   L_1277: aliased constant String := "      --  return all but the first 'n' ma"
       & "tched characters back to the input stream";
   L_1278: aliased constant String := "      procedure yyless (n : Integer) is";
   L_1279: aliased constant String := "      begin";
   L_1280: aliased constant String := "         yy_ch_buf (yy_cp) := yy_hold_cha"
       & "r; --  undo effects of setting up yytext";
   L_1281: aliased constant String := "         yy_cp := yy_bp + n;";
   L_1282: aliased constant String := "         yy_c_buf_p := yy_cp;";
   L_1283: aliased constant String := "         YY_DO_BEFORE_ACTION; -- set up y"
       & "ytext again";
   L_1284: aliased constant String := "      end yyless;";
   L_1285: aliased constant String := "%if yyaction";
   L_1286: aliased constant String := "      --  redefine this if you have somet"
       & "hing you want each time.";
   L_1287: aliased constant String := "      procedure YY_USER_ACTION is";
   L_1288: aliased constant String := "      begin";
   L_1289: aliased constant String := "%yyaction";
   L_1290: aliased constant String := "      end YY_USER_ACTION;";
   L_1291: aliased constant String := "%end";
   L_1292: aliased constant String := "      --  yy_get_previous_state - get the"
       & " state just before the EOB char was reached";
   L_1293: aliased constant String := "";
   L_1294: aliased constant String := "      function yy_get_previous_state retu"
       & "rn yy_state_type is";
   L_1295: aliased constant String := "         yy_current_state : yy_state_type"
       & ";";
   L_1296: aliased constant String := "         yy_c : Short;";
   L_1297: aliased constant String := "%%3 ybp";
   L_1298: aliased constant String := "         --  yy_bp : constant Integer := "
       & "yytext_ptr;";
   L_1299: aliased constant String := "      begin";
   L_1300: aliased constant String := "%%3 startstate";
   L_1301: aliased constant String := "";
   L_1302: aliased constant String := "         for yy_cp in yytext_ptr .. yy_c_"
       & "buf_p - 1 loop";
   L_1303: aliased constant String := "%%4 nextstate";
   L_1304: aliased constant String := "         end loop;";
   L_1305: aliased constant String := "";
   L_1306: aliased constant String := "         return yy_current_state;";
   L_1307: aliased constant String := "      end yy_get_previous_state;";
   L_1308: aliased constant String := "";
   L_1309: aliased constant String := "      procedure yyrestart (input_file : F"
       & "ile_Type) is";
   L_1310: aliased constant String := "      begin";
   L_1311: aliased constant String := "         Open_Input (${YYVAR}, Ada.Text_I"
       & "O.Name (input_file));";
   L_1312: aliased constant String := "      end yyrestart;";
   L_1313: aliased constant String := "";
   L_1314: aliased constant String := "   begin -- of ${YYLEX}";
   L_1315: aliased constant String := "%if yywrap";
   L_1316: aliased constant String := "      <<new_file>>";
   L_1317: aliased constant String := "      --  this is where we enter upon enc"
       & "ountering an end-of-file and";
   L_1318: aliased constant String := "      --  yyWrap () indicating that we sh"
       & "ould continue processing";
   L_1319: aliased constant String := "%end";
   L_1320: aliased constant String := "";
   L_1321: aliased constant String := "      if yy_init then";
   L_1322: aliased constant String := "%yyinit";
   L_1323: aliased constant String := "         if yy_start = 0 then";
   L_1324: aliased constant String := "            yy_start := 1;      -- first "
       & "start state";
   L_1325: aliased constant String := "         end if;";
   L_1326: aliased constant String := "";
   L_1327: aliased constant String := "         --  we put in the '\n' and start"
       & " reading from [1] so that an";
   L_1328: aliased constant String := "         --  initial match-at-newline wil"
       & "l be true.";
   L_1329: aliased constant String := "";
   L_1330: aliased constant String := "         yy_ch_buf (0) := ASCII.LF;";
   L_1331: aliased constant String := "         yy_n_chars := 1;";
   L_1332: aliased constant String := "";
   L_1333: aliased constant String := "         --  we always need two end-of-bu"
       & "ffer characters. The first causes";
   L_1334: aliased constant String := "         --  a transition to the end-of-b"
       & "uffer state. The second causes";
   L_1335: aliased constant String := "         --  a jam in that state.";
   L_1336: aliased constant String := "";
   L_1337: aliased constant String := "         yy_ch_buf (yy_n_chars) := YY_END"
       & "_OF_BUFFER_CHAR;";
   L_1338: aliased constant String := "         yy_ch_buf (yy_n_chars + 1) := YY"
       & "_END_OF_BUFFER_CHAR;";
   L_1339: aliased constant String := "";
   L_1340: aliased constant String := "         yy_eof_has_been_seen := False;";
   L_1341: aliased constant String := "";
   L_1342: aliased constant String := "         yytext_ptr := 1;";
   L_1343: aliased constant String := "         yy_c_buf_p := yytext_ptr;";
   L_1344: aliased constant String := "         yy_hold_char := yy_ch_buf (yy_c_"
       & "buf_p);";
   L_1345: aliased constant String := "         yy_init := False;";
   L_1346: aliased constant String := "%if error";
   L_1347: aliased constant String := "         --   Initialization";
   L_1348: aliased constant String := "         tok_begin_line := 1;";
   L_1349: aliased constant String := "         tok_end_line := 1;";
   L_1350: aliased constant String := "         tok_begin_col := 0;";
   L_1351: aliased constant String := "         tok_end_col := 0;";
   L_1352: aliased constant String := "         token_at_end_of_line := False;";
   L_1353: aliased constant String := "         line_number_of_saved_tok_line1 :"
       & "= 0;";
   L_1354: aliased constant String := "         line_number_of_saved_tok_line2 :"
       & "= 0;";
   L_1355: aliased constant String := "%end";
   L_1356: aliased constant String := "      end if; -- yy_init";
   L_1357: aliased constant String := "";
   L_1358: aliased constant String := "      loop                -- loops until "
       & "end-of-file is reached";
   L_1359: aliased constant String := "%if error";
   L_1360: aliased constant String := "         --    if last matched token is e"
       & "nd_of_line, we must";
   L_1361: aliased constant String := "         --    update the token_end_line "
       & "and reset tok_end_col.";
   L_1362: aliased constant String := "         if Token_At_End_Of_Line then";
   L_1363: aliased constant String := "            Tok_End_Line := Tok_End_Line "
       & "+ 1;";
   L_1364: aliased constant String := "            Tok_End_Col := 0;";
   L_1365: aliased constant String := "            Token_At_End_Of_Line := False"
       & ";";
   L_1366: aliased constant String := "         end if;";
   L_1367: aliased constant String := "%end";
   L_1368: aliased constant String := "";
   L_1369: aliased constant String := "         yy_cp := yy_c_buf_p;";
   L_1370: aliased constant String := "";
   L_1371: aliased constant String := "         --  support of yytext";
   L_1372: aliased constant String := "         yy_ch_buf (yy_cp) := yy_hold_cha"
       & "r;";
   L_1373: aliased constant String := "";
   L_1374: aliased constant String := "         --  yy_bp points to the position"
       & " in yy_ch_buf of the start of the";
   L_1375: aliased constant String := "         --  current run.";
   L_1376: aliased constant String := "%%5 action";
   L_1377: aliased constant String := "";
   L_1378: aliased constant String := "   <<next_action>>";
   L_1379: aliased constant String := "%%6 action";
   L_1380: aliased constant String := "         YY_DO_BEFORE_ACTION;";
   L_1381: aliased constant String := "%if yyaction";
   L_1382: aliased constant String := "         YY_USER_ACTION;";
   L_1383: aliased constant String := "%end";
   L_1384: aliased constant String := "";
   L_1385: aliased constant String := "         if aflex_debug then  -- output a"
       & "cceptance info. for (-d) debug mode";
   L_1386: aliased constant String := "            Ada.Text_IO.Put (Standard_Err"
       & "or, ""  -- Aflex.YYLex accept rule #"");";
   L_1387: aliased constant String := "            Ada.Text_IO.Put (Standard_Err"
       & "or, Integer'Image (yy_act));";
   L_1388: aliased constant String := "            Ada.Text_IO.Put_Line (Standar"
       & "d_Error, ""("""""" & YYText & """""")"");";
   L_1389: aliased constant String := "         end if;";
   L_1390: aliased constant String := "%if error";
   L_1391: aliased constant String := "         --   Update tok_begin_line, tok_"
       & "end_line, tok_begin_col and tok_end_col";
   L_1392: aliased constant String := "         --   after matching the token.";
   L_1393: aliased constant String := "         if yy_act /= YY_END_OF_BUFFER an"
       & "d then yy_act /= 0 then";
   L_1394: aliased constant String := "            -- Token are matched only whe"
       & "n yy_act is not yy_end_of_buffer or 0.";
   L_1395: aliased constant String := "            Tok_Begin_Line := Tok_End_Lin"
       & "e;";
   L_1396: aliased constant String := "            Tok_Begin_Col := Tok_End_Col "
       & "+ 1;";
   L_1397: aliased constant String := "            Tok_End_Col := Tok_Begin_Col "
       & "+ yy_cp - yy_bp - 1;";
   L_1398: aliased constant String := "            if yy_ch_buf ( yy_bp ) = ASCI"
       & "I.LF then";
   L_1399: aliased constant String := "               Token_At_End_Of_Line := Tr"
       & "ue;";
   L_1400: aliased constant String := "            end if;";
   L_1401: aliased constant String := "         end if;";
   L_1402: aliased constant String := "%end";
   L_1403: aliased constant String := "";
   L_1404: aliased constant String := "   <<do_action>>   -- this label is used "
       & "only to access EOF actions";
   L_1405: aliased constant String := "         case yy_act is";
   L_1406: aliased constant String := "";
   L_1407: aliased constant String := "%%7 action";
   L_1408: aliased constant String := "";
   L_1409: aliased constant String := "         when YY_END_OF_BUFFER =>";
   L_1410: aliased constant String := "            --  undo the effects of YY_DO"
       & "_BEFORE_ACTION";
   L_1411: aliased constant String := "            yy_ch_buf (yy_cp) := yy_hold_"
       & "char;";
   L_1412: aliased constant String := "";
   L_1413: aliased constant String := "            yytext_ptr := yy_bp;";
   L_1414: aliased constant String := "";
   L_1415: aliased constant String := "            case yy_get_next_buffer is";
   L_1416: aliased constant String := "               when EOB_ACT_END_OF_FILE ="
       & ">";
   L_1417: aliased constant String := "%if yywrap";
   L_1418: aliased constant String := "                  if yyWrap (${YYVAR}) th"
       & "en";
   L_1419: aliased constant String := "                     --  note: because we"
       & "'ve taken care in";
   L_1420: aliased constant String := "                     --  yy_get_next_buff"
       & "er() to have set up yytext,";
   L_1421: aliased constant String := "                     --  we can now set u"
       & "p yy_c_buf_p so that if some";
   L_1422: aliased constant String := "                     --  total hoser (lik"
       & "e aflex itself) wants";
   L_1423: aliased constant String := "                     --  to call the scan"
       & "ner after we return the";
   L_1424: aliased constant String := "                     --  End_Of_Input, it"
       & "'ll still work - another";
   L_1425: aliased constant String := "                     --  End_Of_Input wil"
       & "l get returned.";
   L_1426: aliased constant String := "";
   L_1427: aliased constant String := "                     yy_c_buf_p := yytext"
       & "_ptr;";
   L_1428: aliased constant String := "";
   L_1429: aliased constant String := "                     yy_act := YY_STATE_E"
       & "OF ((yy_start - 1) / 2);";
   L_1430: aliased constant String := "";
   L_1431: aliased constant String := "                     goto do_action;";
   L_1432: aliased constant String := "                  else";
   L_1433: aliased constant String := "                     --  start processing"
       & " a new file";
   L_1434: aliased constant String := "                     yy_init := True;";
   L_1435: aliased constant String := "                     goto new_file;";
   L_1436: aliased constant String := "                  end if;";
   L_1437: aliased constant String := "%else";
   L_1438: aliased constant String := "                  --  note: because we've"
       & " taken care in";
   L_1439: aliased constant String := "                  --  yy_get_next_buffer("
       & ") to have set up yytext,";
   L_1440: aliased constant String := "                  --  we can now set up y"
       & "y_c_buf_p so that if some";
   L_1441: aliased constant String := "                  --  total hoser (like a"
       & "flex itself) wants";
   L_1442: aliased constant String := "                  --  to call the scanner"
       & " after we return the";
   L_1443: aliased constant String := "                  --  End_Of_Input, it'll"
       & " still work - another";
   L_1444: aliased constant String := "                  --  End_Of_Input will g"
       & "et returned.";
   L_1445: aliased constant String := "";
   L_1446: aliased constant String := "                  yy_c_buf_p := yytext_pt"
       & "r;";
   L_1447: aliased constant String := "";
   L_1448: aliased constant String := "                  yy_act := YY_STATE_EOF "
       & "((yy_start - 1) / 2);";
   L_1449: aliased constant String := "";
   L_1450: aliased constant String := "                  goto do_action;";
   L_1451: aliased constant String := "%end";
   L_1452: aliased constant String := "";
   L_1453: aliased constant String := "               when EOB_ACT_RESTART_SCAN "
       & "=>";
   L_1454: aliased constant String := "                  yy_c_buf_p := yytext_pt"
       & "r;";
   L_1455: aliased constant String := "                  yy_hold_char := yy_ch_b"
       & "uf (yy_c_buf_p);";
   L_1456: aliased constant String := "";
   L_1457: aliased constant String := "               when EOB_ACT_LAST_MATCH =>";
   L_1458: aliased constant String := "                  yy_c_buf_p := yy_n_char"
       & "s;";
   L_1459: aliased constant String := "                  yy_current_state := yy_"
       & "get_previous_state;";
   L_1460: aliased constant String := "                  yy_cp := yy_c_buf_p;";
   L_1461: aliased constant String := "                  yy_bp := yytext_ptr;";
   L_1462: aliased constant String := "                  goto next_action;";
   L_1463: aliased constant String := "";
   L_1464: aliased constant String := "            end case; --  case yy_get_nex"
       & "t_buffer()";
   L_1465: aliased constant String := "";
   L_1466: aliased constant String := "         when others =>";
   L_1467: aliased constant String := "            Ada.Text_IO.Put (""action # """
       & ");";
   L_1468: aliased constant String := "            Ada.Text_IO.Put (Integer'Imag"
       & "e (yy_act));";
   L_1469: aliased constant String := "            Ada.Text_IO.New_Line;";
   L_1470: aliased constant String := "            raise AFLEX_INTERNAL_ERROR;";
   L_1471: aliased constant String := "";
   L_1472: aliased constant String := "         end case; --  case (yy_act)";
   L_1473: aliased constant String := "      end loop; --  end of loop waiting f"
       & "or end of file";
   L_1474: aliased constant String := "   end ${YYLEX};";
   L_1475: aliased constant String := "";
   L_1476: aliased constant String := "%%8 user";
   body_reentrant_lex : aliased constant Content_Array :=
     (L_1198'Access,
      L_1199'Access,
      L_1200'Access,
      L_1201'Access,
      L_1202'Access,
      L_1203'Access,
      L_1204'Access,
      L_1205'Access,
      L_1206'Access,
      L_1207'Access,
      L_1208'Access,
      L_1209'Access,
      L_1210'Access,
      L_1211'Access,
      L_1212'Access,
      L_1213'Access,
      L_1214'Access,
      L_1215'Access,
      L_1216'Access,
      L_1217'Access,
      L_1218'Access,
      L_1219'Access,
      L_1220'Access,
      L_1221'Access,
      L_1222'Access,
      L_1223'Access,
      L_1224'Access,
      L_1225'Access,
      L_1226'Access,
      L_1227'Access,
      L_1228'Access,
      L_1229'Access,
      L_1230'Access,
      L_1231'Access,
      L_1232'Access,
      L_1233'Access,
      L_1234'Access,
      L_1235'Access,
      L_1236'Access,
      L_1237'Access,
      L_1238'Access,
      L_1239'Access,
      L_1240'Access,
      L_1241'Access,
      L_1242'Access,
      L_1243'Access,
      L_1244'Access,
      L_1245'Access,
      L_1246'Access,
      L_1247'Access,
      L_1248'Access,
      L_1249'Access,
      L_1250'Access,
      L_1251'Access,
      L_1252'Access,
      L_1253'Access,
      L_1254'Access,
      L_1255'Access,
      L_1256'Access,
      L_1257'Access,
      L_1258'Access,
      L_1259'Access,
      L_1260'Access,
      L_1261'Access,
      L_1262'Access,
      L_1263'Access,
      L_1264'Access,
      L_1265'Access,
      L_1266'Access,
      L_1267'Access,
      L_1268'Access,
      L_1269'Access,
      L_1270'Access,
      L_1271'Access,
      L_1272'Access,
      L_1273'Access,
      L_1274'Access,
      L_1275'Access,
      L_1276'Access,
      L_1277'Access,
      L_1278'Access,
      L_1279'Access,
      L_1280'Access,
      L_1281'Access,
      L_1282'Access,
      L_1283'Access,
      L_1284'Access,
      L_1285'Access,
      L_1286'Access,
      L_1287'Access,
      L_1288'Access,
      L_1289'Access,
      L_1290'Access,
      L_1291'Access,
      L_1292'Access,
      L_1293'Access,
      L_1294'Access,
      L_1295'Access,
      L_1296'Access,
      L_1297'Access,
      L_1298'Access,
      L_1299'Access,
      L_1300'Access,
      L_1301'Access,
      L_1302'Access,
      L_1303'Access,
      L_1304'Access,
      L_1305'Access,
      L_1306'Access,
      L_1307'Access,
      L_1308'Access,
      L_1309'Access,
      L_1310'Access,
      L_1311'Access,
      L_1312'Access,
      L_1313'Access,
      L_1314'Access,
      L_1315'Access,
      L_1316'Access,
      L_1317'Access,
      L_1318'Access,
      L_1319'Access,
      L_1320'Access,
      L_1321'Access,
      L_1322'Access,
      L_1323'Access,
      L_1324'Access,
      L_1325'Access,
      L_1326'Access,
      L_1327'Access,
      L_1328'Access,
      L_1329'Access,
      L_1330'Access,
      L_1331'Access,
      L_1332'Access,
      L_1333'Access,
      L_1334'Access,
      L_1335'Access,
      L_1336'Access,
      L_1337'Access,
      L_1338'Access,
      L_1339'Access,
      L_1340'Access,
      L_1341'Access,
      L_1342'Access,
      L_1343'Access,
      L_1344'Access,
      L_1345'Access,
      L_1346'Access,
      L_1347'Access,
      L_1348'Access,
      L_1349'Access,
      L_1350'Access,
      L_1351'Access,
      L_1352'Access,
      L_1353'Access,
      L_1354'Access,
      L_1355'Access,
      L_1356'Access,
      L_1357'Access,
      L_1358'Access,
      L_1359'Access,
      L_1360'Access,
      L_1361'Access,
      L_1362'Access,
      L_1363'Access,
      L_1364'Access,
      L_1365'Access,
      L_1366'Access,
      L_1367'Access,
      L_1368'Access,
      L_1369'Access,
      L_1370'Access,
      L_1371'Access,
      L_1372'Access,
      L_1373'Access,
      L_1374'Access,
      L_1375'Access,
      L_1376'Access,
      L_1377'Access,
      L_1378'Access,
      L_1379'Access,
      L_1380'Access,
      L_1381'Access,
      L_1382'Access,
      L_1383'Access,
      L_1384'Access,
      L_1385'Access,
      L_1386'Access,
      L_1387'Access,
      L_1388'Access,
      L_1389'Access,
      L_1390'Access,
      L_1391'Access,
      L_1392'Access,
      L_1393'Access,
      L_1394'Access,
      L_1395'Access,
      L_1396'Access,
      L_1397'Access,
      L_1398'Access,
      L_1399'Access,
      L_1400'Access,
      L_1401'Access,
      L_1402'Access,
      L_1403'Access,
      L_1404'Access,
      L_1405'Access,
      L_1406'Access,
      L_1407'Access,
      L_1408'Access,
      L_1409'Access,
      L_1410'Access,
      L_1411'Access,
      L_1412'Access,
      L_1413'Access,
      L_1414'Access,
      L_1415'Access,
      L_1416'Access,
      L_1417'Access,
      L_1418'Access,
      L_1419'Access,
      L_1420'Access,
      L_1421'Access,
      L_1422'Access,
      L_1423'Access,
      L_1424'Access,
      L_1425'Access,
      L_1426'Access,
      L_1427'Access,
      L_1428'Access,
      L_1429'Access,
      L_1430'Access,
      L_1431'Access,
      L_1432'Access,
      L_1433'Access,
      L_1434'Access,
      L_1435'Access,
      L_1436'Access,
      L_1437'Access,
      L_1438'Access,
      L_1439'Access,
      L_1440'Access,
      L_1441'Access,
      L_1442'Access,
      L_1443'Access,
      L_1444'Access,
      L_1445'Access,
      L_1446'Access,
      L_1447'Access,
      L_1448'Access,
      L_1449'Access,
      L_1450'Access,
      L_1451'Access,
      L_1452'Access,
      L_1453'Access,
      L_1454'Access,
      L_1455'Access,
      L_1456'Access,
      L_1457'Access,
      L_1458'Access,
      L_1459'Access,
      L_1460'Access,
      L_1461'Access,
      L_1462'Access,
      L_1463'Access,
      L_1464'Access,
      L_1465'Access,
      L_1466'Access,
      L_1467'Access,
      L_1468'Access,
      L_1469'Access,
      L_1470'Access,
      L_1471'Access,
      L_1472'Access,
      L_1473'Access,
      L_1474'Access,
      L_1475'Access,
      L_1476'Access);

   L_1477: aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_1478: aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_1479: aliased constant String := "--  Template: templates/spec-dfa.ads";
   L_1480: aliased constant String := "%if private";
   L_1481: aliased constant String := "package ${NAME}_DFA is";
   L_1482: aliased constant String := "%else";
   L_1483: aliased constant String := "package ${NAME}_DFA is";
   L_1484: aliased constant String := "%end";
   L_1485: aliased constant String := "";
   L_1486: aliased constant String := "%if debug";
   L_1487: aliased constant String := "   aflex_debug       : Boolean := True;";
   L_1488: aliased constant String := "%else";
   L_1489: aliased constant String := "   aflex_debug       : Boolean := False;";
   L_1490: aliased constant String := "%end";
   L_1491: aliased constant String := "%if yylineno";
   L_1492: aliased constant String := "   yylineno          : Natural := 0;";
   L_1493: aliased constant String := "   yylinecol         : Natural := 0;";
   L_1494: aliased constant String := "   yy_last_yylineno  : Natural := 0;";
   L_1495: aliased constant String := "   yy_last_yylinecol : Natural := 0;";
   L_1496: aliased constant String := "%end";
   L_1497: aliased constant String := "   yytext_ptr        : Integer; --  point"
       & "s to start of yytext in buffer";
   L_1498: aliased constant String := "";
   L_1499: aliased constant String := "   --  yy_ch_buf has to be 2 characters l"
       & "onger than YY_BUF_SIZE because we need";
   L_1500: aliased constant String := "   --  to put in 2 end-of-buffer characte"
       & "rs (this is explained where it is";
   L_1501: aliased constant String := "   --  done) at the end of yy_ch_buf";
   L_1502: aliased constant String := "";
   L_1503: aliased constant String := "   --  ----------------------------------"
       & "------------------------------------------";
   L_1504: aliased constant String := "   --  Buffer size is configured with:";
   L_1505: aliased constant String := "   --  %option bufsize=${YYBUFSIZE}";
   L_1506: aliased constant String := "";
   L_1507: aliased constant String := "   YY_READ_BUF_SIZE : constant Integer :="
       & " ${YYBUFSIZE};";
   L_1508: aliased constant String := "   --  ----------------------------------"
       & "------------------------------------------";
   L_1509: aliased constant String := "";
   L_1510: aliased constant String := "   YY_BUF_SIZE : constant Integer := YY_R"
       & "EAD_BUF_SIZE * 2; --  size of input buffer";
   L_1511: aliased constant String := "";
   L_1512: aliased constant String := "   type unbounded_character_array is arra"
       & "y (Integer range <>) of Character;";
   L_1513: aliased constant String := "   subtype ch_buf_type is unbounded_chara"
       & "cter_array (0 .. YY_BUF_SIZE + 1);";
   L_1514: aliased constant String := "";
   L_1515: aliased constant String := "   yy_ch_buf    : ch_buf_type;";
   L_1516: aliased constant String := "   yy_cp, yy_bp : Integer;";
   L_1517: aliased constant String := "";
   L_1518: aliased constant String := "   --  yy_hold_char holds the character l"
       & "ost when yytext is formed";
   L_1519: aliased constant String := "   yy_hold_char : Character;";
   L_1520: aliased constant String := "   yy_c_buf_p   : Integer;   --  points t"
       & "o current character in buffer";
   L_1521: aliased constant String := "";
   L_1522: aliased constant String := "   function YYText return String;";
   L_1523: aliased constant String := "   function YYLength return Integer;";
   L_1524: aliased constant String := "   procedure YY_DO_BEFORE_ACTION;";
   L_1525: aliased constant String := "";
   L_1526: aliased constant String := "   subtype yy_state_type is Integer;";
   L_1527: aliased constant String := "";
   L_1528: aliased constant String := "   --  These variables are needed between"
       & " calls to YYLex.";
   L_1529: aliased constant String := "   yy_init                 : Boolean := T"
       & "rue; --  do we need to initialize YYLex?";
   L_1530: aliased constant String := "   yy_start                : Integer := 0"
       & "; --  current start state number";
   L_1531: aliased constant String := "   yy_last_accepting_state : yy_state_typ"
       & "e;";
   L_1532: aliased constant String := "   yy_last_accepting_cpos  : Integer;";
   L_1533: aliased constant String := "";
   L_1534: aliased constant String := "end ${NAME}_DFA;";
   spec_dfa : aliased constant Content_Array :=
     (L_1477'Access,
      L_1478'Access,
      L_1479'Access,
      L_1480'Access,
      L_1481'Access,
      L_1482'Access,
      L_1483'Access,
      L_1484'Access,
      L_1485'Access,
      L_1486'Access,
      L_1487'Access,
      L_1488'Access,
      L_1489'Access,
      L_1490'Access,
      L_1491'Access,
      L_1492'Access,
      L_1493'Access,
      L_1494'Access,
      L_1495'Access,
      L_1496'Access,
      L_1497'Access,
      L_1498'Access,
      L_1499'Access,
      L_1500'Access,
      L_1501'Access,
      L_1502'Access,
      L_1503'Access,
      L_1504'Access,
      L_1505'Access,
      L_1506'Access,
      L_1507'Access,
      L_1508'Access,
      L_1509'Access,
      L_1510'Access,
      L_1511'Access,
      L_1512'Access,
      L_1513'Access,
      L_1514'Access,
      L_1515'Access,
      L_1516'Access,
      L_1517'Access,
      L_1518'Access,
      L_1519'Access,
      L_1520'Access,
      L_1521'Access,
      L_1522'Access,
      L_1523'Access,
      L_1524'Access,
      L_1525'Access,
      L_1526'Access,
      L_1527'Access,
      L_1528'Access,
      L_1529'Access,
      L_1530'Access,
      L_1531'Access,
      L_1532'Access,
      L_1533'Access,
      L_1534'Access);

   L_1535: aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_1536: aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_1537: aliased constant String := "--  Template: templates/spec-io.ads";
   L_1538: aliased constant String := "with Ada.Text_IO;";
   L_1539: aliased constant String := "with ${NAME}_DFA; use ${NAME}_DFA;";
   L_1540: aliased constant String := "%if private";
   L_1541: aliased constant String := "package ${NAME}_IO is";
   L_1542: aliased constant String := "%else";
   L_1543: aliased constant String := "package ${NAME}_IO is";
   L_1544: aliased constant String := "%end";
   L_1545: aliased constant String := "";
   L_1546: aliased constant String := "   user_input_file       : Ada.Text_IO.Fi"
       & "le_Type;";
   L_1547: aliased constant String := "%if output";
   L_1548: aliased constant String := "   user_output_file      : Ada.Text_IO.Fi"
       & "le_Type;";
   L_1549: aliased constant String := "%end";
   L_1550: aliased constant String := "   NULL_IN_INPUT         : exception;";
   L_1551: aliased constant String := "   AFLEX_INTERNAL_ERROR  : exception;";
   L_1552: aliased constant String := "   UNEXPECTED_LAST_MATCH : exception;";
   L_1553: aliased constant String := "   PUSHBACK_OVERFLOW     : exception;";
   L_1554: aliased constant String := "   AFLEX_SCANNER_JAMMED  : exception;";
   L_1555: aliased constant String := "   type eob_action_type is (EOB_ACT_RESTA"
       & "RT_SCAN,";
   L_1556: aliased constant String := "                            EOB_ACT_END_O"
       & "F_FILE,";
   L_1557: aliased constant String := "                            EOB_ACT_LAST_"
       & "MATCH);";
   L_1558: aliased constant String := "   YY_END_OF_BUFFER_CHAR : constant Chara"
       & "cter := ASCII.NUL;";
   L_1559: aliased constant String := "   yy_n_chars            : Integer;      "
       & " --  number of characters read into yy_ch_buf";
   L_1560: aliased constant String := "";
   L_1561: aliased constant String := "   --  true when we've seen an EOF for th"
       & "e current input file";
   L_1562: aliased constant String := "   yy_eof_has_been_seen  : Boolean;";
   L_1563: aliased constant String := "";
   L_1564: aliased constant String := "%if error";
   L_1565: aliased constant String := "   --   In order to support YY_Get_Token_"
       & "Line, we need";
   L_1566: aliased constant String := "   --   a variable to hold current line.";
   L_1567: aliased constant String := "   type String_Ptr is access String;";
   L_1568: aliased constant String := "   Saved_Tok_Line1 : String_Ptr := Null;";
   L_1569: aliased constant String := "   Line_Number_Of_Saved_Tok_Line1 : Integ"
       & "er := 0;";
   L_1570: aliased constant String := "   Saved_Tok_Line2 : String_Ptr := Null;";
   L_1571: aliased constant String := "   Line_Number_Of_Saved_Tok_Line2 : Integ"
       & "er := 0;";
   L_1572: aliased constant String := "   -- Aflex will try to get next buffer b"
       & "efore it processs the";
   L_1573: aliased constant String := "   -- last token. Since now Aflex has bee"
       & "n changed to accept";
   L_1574: aliased constant String := "   -- one line by one line, the last toke"
       & "n in the buffer is";
   L_1575: aliased constant String := "   -- always end_of_line ( or end_of_buff"
       & "er ). So before the";
   L_1576: aliased constant String := "   -- end_of_line is processed, next line"
       & " will be retrieved";
   L_1577: aliased constant String := "   -- into the buffer. So we need to main"
       & "tain two lines,";
   L_1578: aliased constant String := "   -- which line will be returned in Get_"
       & "Token_Line is";
   L_1579: aliased constant String := "   -- determined according to the line nu"
       & "mber. It is the same";
   L_1580: aliased constant String := "   -- reason that we can not reinitialize"
       & " tok_end_col to 0 in";
   L_1581: aliased constant String := "   -- Yy_Input, but we must do it in yyle"
       & "x after we process the";
   L_1582: aliased constant String := "   -- end_of_line.";
   L_1583: aliased constant String := "   Tok_Begin_Line : Integer := 1;";
   L_1584: aliased constant String := "   Tok_End_Line   : Integer := 1;";
   L_1585: aliased constant String := "   Tok_End_Col    : Integer := 0;";
   L_1586: aliased constant String := "   Tok_Begin_Col  : Integer := 0;";
   L_1587: aliased constant String := "   Token_At_End_Of_Line : Boolean := Fals"
       & "e;";
   L_1588: aliased constant String := "   -- Indicates whether or not last match"
       & "ed token is end_of_line.";
   L_1589: aliased constant String := "";
   L_1590: aliased constant String := "%end";
   L_1591: aliased constant String := "   procedure YY_INPUT (buf      : out unb"
       & "ounded_character_array;";
   L_1592: aliased constant String := "                       result   : out Int"
       & "eger;";
   L_1593: aliased constant String := "                       max_size : in Inte"
       & "ger);";
   L_1594: aliased constant String := "   function yy_get_next_buffer return eob"
       & "_action_type;";
   L_1595: aliased constant String := "%if unput";
   L_1596: aliased constant String := "   procedure yyUnput (c : Character; yy_b"
       & "p : in out Integer);";
   L_1597: aliased constant String := "   procedure Unput (c : Character);";
   L_1598: aliased constant String := "%end";
   L_1599: aliased constant String := "%if input";
   L_1600: aliased constant String := "   function Input return Character;";
   L_1601: aliased constant String := "%end";
   L_1602: aliased constant String := "%if output";
   L_1603: aliased constant String := "   procedure Output (c : Character);";
   L_1604: aliased constant String := "   procedure Output_New_Line;";
   L_1605: aliased constant String := "   function Output_Column return Ada.Text"
       & "_IO.Count;";
   L_1606: aliased constant String := "%end";
   L_1607: aliased constant String := "%if error";
   L_1608: aliased constant String := "   function Input_Line return Ada.Text_IO"
       & ".Count;";
   L_1609: aliased constant String := "%end";
   L_1610: aliased constant String := "%if yywrap";
   L_1611: aliased constant String := "   function yyWrap return Boolean;";
   L_1612: aliased constant String := "%end";
   L_1613: aliased constant String := "   procedure Open_Input (fname : in Strin"
       & "g);";
   L_1614: aliased constant String := "   procedure Close_Input;";
   L_1615: aliased constant String := "%if output";
   L_1616: aliased constant String := "   procedure Create_Output (fname : in St"
       & "ring := """");";
   L_1617: aliased constant String := "   procedure Close_Output;";
   L_1618: aliased constant String := "%end";
   L_1619: aliased constant String := "%if error";
   L_1620: aliased constant String := "";
   L_1621: aliased constant String := "   procedure Yy_Get_Token_Line ( Yy_Line_"
       & "String : out String;";
   L_1622: aliased constant String := "                                 Yy_Line_"
       & "Length : out Natural );";
   L_1623: aliased constant String := "   --  Returnes the entire line in the in"
       & "put, on which the currently";
   L_1624: aliased constant String := "   --  matched token resides.";
   L_1625: aliased constant String := "";
   L_1626: aliased constant String := "   function Yy_Line_Number return Natural"
       & ";";
   L_1627: aliased constant String := "   --  Returns the line number of the cur"
       & "rently matched token.";
   L_1628: aliased constant String := "   --  In case a token spans lines, then "
       & "the line number of the first line";
   L_1629: aliased constant String := "   --  is returned.";
   L_1630: aliased constant String := "";
   L_1631: aliased constant String := "   function Yy_Begin_Column return Natura"
       & "l;";
   L_1632: aliased constant String := "   function Yy_End_Column return Natural;";
   L_1633: aliased constant String := "   --  Returns the beginning and ending c"
       & "olumn positions of the";
   L_1634: aliased constant String := "   --  currently mathched token. If the t"
       & "oken spans lines then the";
   L_1635: aliased constant String := "   --  begin column number is the column "
       & "number on the first line";
   L_1636: aliased constant String := "   --  and the end columne number is the "
       & "column number on the last line.";
   L_1637: aliased constant String := "%end";
   L_1638: aliased constant String := "";
   L_1639: aliased constant String := "end ${NAME}_IO;";
   spec_io : aliased constant Content_Array :=
     (L_1535'Access,
      L_1536'Access,
      L_1537'Access,
      L_1538'Access,
      L_1539'Access,
      L_1540'Access,
      L_1541'Access,
      L_1542'Access,
      L_1543'Access,
      L_1544'Access,
      L_1545'Access,
      L_1546'Access,
      L_1547'Access,
      L_1548'Access,
      L_1549'Access,
      L_1550'Access,
      L_1551'Access,
      L_1552'Access,
      L_1553'Access,
      L_1554'Access,
      L_1555'Access,
      L_1556'Access,
      L_1557'Access,
      L_1558'Access,
      L_1559'Access,
      L_1560'Access,
      L_1561'Access,
      L_1562'Access,
      L_1563'Access,
      L_1564'Access,
      L_1565'Access,
      L_1566'Access,
      L_1567'Access,
      L_1568'Access,
      L_1569'Access,
      L_1570'Access,
      L_1571'Access,
      L_1572'Access,
      L_1573'Access,
      L_1574'Access,
      L_1575'Access,
      L_1576'Access,
      L_1577'Access,
      L_1578'Access,
      L_1579'Access,
      L_1580'Access,
      L_1581'Access,
      L_1582'Access,
      L_1583'Access,
      L_1584'Access,
      L_1585'Access,
      L_1586'Access,
      L_1587'Access,
      L_1588'Access,
      L_1589'Access,
      L_1590'Access,
      L_1591'Access,
      L_1592'Access,
      L_1593'Access,
      L_1594'Access,
      L_1595'Access,
      L_1596'Access,
      L_1597'Access,
      L_1598'Access,
      L_1599'Access,
      L_1600'Access,
      L_1601'Access,
      L_1602'Access,
      L_1603'Access,
      L_1604'Access,
      L_1605'Access,
      L_1606'Access,
      L_1607'Access,
      L_1608'Access,
      L_1609'Access,
      L_1610'Access,
      L_1611'Access,
      L_1612'Access,
      L_1613'Access,
      L_1614'Access,
      L_1615'Access,
      L_1616'Access,
      L_1617'Access,
      L_1618'Access,
      L_1619'Access,
      L_1620'Access,
      L_1621'Access,
      L_1622'Access,
      L_1623'Access,
      L_1624'Access,
      L_1625'Access,
      L_1626'Access,
      L_1627'Access,
      L_1628'Access,
      L_1629'Access,
      L_1630'Access,
      L_1631'Access,
      L_1632'Access,
      L_1633'Access,
      L_1634'Access,
      L_1635'Access,
      L_1636'Access,
      L_1637'Access,
      L_1638'Access,
      L_1639'Access);

   L_1640: aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_1641: aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_1642: aliased constant String := "--  Template: templates/spec-reentrant-df"
       & "a.ads";
   L_1643: aliased constant String := "%if private";
   L_1644: aliased constant String := "private package ${NAME}_DFA is";
   L_1645: aliased constant String := "%else";
   L_1646: aliased constant String := "package ${NAME}_DFA is";
   L_1647: aliased constant String := "%end";
   L_1648: aliased constant String := "";
   L_1649: aliased constant String := "   --  ----------------------------------"
       & "------------------------------------------";
   L_1650: aliased constant String := "   --  Buffer size is configured with:";
   L_1651: aliased constant String := "   --  %option bufsize=${YYBUFSIZE}";
   L_1652: aliased constant String := "";
   L_1653: aliased constant String := "   YY_READ_BUF_SIZE : constant Integer :="
       & " ${YYBUFSIZE};";
   L_1654: aliased constant String := "   --  ----------------------------------"
       & "------------------------------------------";
   L_1655: aliased constant String := "";
   L_1656: aliased constant String := "   YY_BUF_SIZE : constant Integer := YY_R"
       & "EAD_BUF_SIZE * 2; --  size of input buffer";
   L_1657: aliased constant String := "";
   L_1658: aliased constant String := "   subtype Index is Natural range 0 .. YY"
       & "_BUF_SIZE;";
   L_1659: aliased constant String := "   type unbounded_character_array is arra"
       & "y (Integer range <>) of Character;";
   L_1660: aliased constant String := "   subtype ch_buf_type is unbounded_chara"
       & "cter_array (0 .. YY_BUF_SIZE + 1);";
   L_1661: aliased constant String := "";
   L_1662: aliased constant String := "   subtype yy_state_type is Integer;";
   L_1663: aliased constant String := "";
   L_1664: aliased constant String := "   type Context_Type is limited record";
   L_1665: aliased constant String := "%if debug";
   L_1666: aliased constant String := "      aflex_debug       : Boolean := True"
       & ";";
   L_1667: aliased constant String := "%else";
   L_1668: aliased constant String := "      aflex_debug       : Boolean := Fals"
       & "e;";
   L_1669: aliased constant String := "%end";
   L_1670: aliased constant String := "%if yylineno";
   L_1671: aliased constant String := "      yylineno          : Natural := 0;";
   L_1672: aliased constant String := "      yylinecol         : Natural := 0;";
   L_1673: aliased constant String := "      yy_last_yylineno  : Natural := 0;";
   L_1674: aliased constant String := "      yy_last_yylinecol : Natural := 0;";
   L_1675: aliased constant String := "%end";
   L_1676: aliased constant String := "      yytext_ptr        : Integer; --  po"
       & "ints to start of yytext in buffer";
   L_1677: aliased constant String := "";
   L_1678: aliased constant String := "      --  yy_ch_buf has to be 2 character"
       & "s longer than YY_BUF_SIZE because we need";
   L_1679: aliased constant String := "      --  to put in 2 end-of-buffer chara"
       & "cters (this is explained where it is";
   L_1680: aliased constant String := "      --  done) at the end of yy_ch_buf";
   L_1681: aliased constant String := "";
   L_1682: aliased constant String := "      yy_ch_buf    : ch_buf_type;";
   L_1683: aliased constant String := "      yy_cp, yy_bp : Integer;";
   L_1684: aliased constant String := "";
   L_1685: aliased constant String := "      --  yy_hold_char holds the characte"
       & "r lost when yytext is formed";
   L_1686: aliased constant String := "      yy_hold_char : Character;";
   L_1687: aliased constant String := "      yy_c_buf_p   : Integer;   --  point"
       & "s to current character in buffer";
   L_1688: aliased constant String := "";
   L_1689: aliased constant String := "      --  These variables are needed betw"
       & "een calls to YYLex.";
   L_1690: aliased constant String := "      yy_init                 : Boolean :"
       & "= True; --  do we need to initialize YYLex?";
   L_1691: aliased constant String := "      yy_start                : Integer :"
       & "= 0; --  current start state number";
   L_1692: aliased constant String := "      yy_last_accepting_state : yy_state_"
       & "type;";
   L_1693: aliased constant String := "      yy_last_accepting_cpos  : Integer;";
   L_1694: aliased constant String := "";
   L_1695: aliased constant String := "   end record;";
   L_1696: aliased constant String := "";
   L_1697: aliased constant String := "   function YYText (Context : in Context_"
       & "Type) return String;";
   L_1698: aliased constant String := "   function YYLength (Context : in Contex"
       & "t_Type) return Integer;";
   L_1699: aliased constant String := "   procedure YY_DO_BEFORE_ACTION (Context"
       & " : in out Context_Type);";
   L_1700: aliased constant String := "";
   L_1701: aliased constant String := "end ${NAME}_DFA;";
   spec_reentrant_dfa : aliased constant Content_Array :=
     (L_1640'Access,
      L_1641'Access,
      L_1642'Access,
      L_1643'Access,
      L_1644'Access,
      L_1645'Access,
      L_1646'Access,
      L_1647'Access,
      L_1648'Access,
      L_1649'Access,
      L_1650'Access,
      L_1651'Access,
      L_1652'Access,
      L_1653'Access,
      L_1654'Access,
      L_1655'Access,
      L_1656'Access,
      L_1657'Access,
      L_1658'Access,
      L_1659'Access,
      L_1660'Access,
      L_1661'Access,
      L_1662'Access,
      L_1663'Access,
      L_1664'Access,
      L_1665'Access,
      L_1666'Access,
      L_1667'Access,
      L_1668'Access,
      L_1669'Access,
      L_1670'Access,
      L_1671'Access,
      L_1672'Access,
      L_1673'Access,
      L_1674'Access,
      L_1675'Access,
      L_1676'Access,
      L_1677'Access,
      L_1678'Access,
      L_1679'Access,
      L_1680'Access,
      L_1681'Access,
      L_1682'Access,
      L_1683'Access,
      L_1684'Access,
      L_1685'Access,
      L_1686'Access,
      L_1687'Access,
      L_1688'Access,
      L_1689'Access,
      L_1690'Access,
      L_1691'Access,
      L_1692'Access,
      L_1693'Access,
      L_1694'Access,
      L_1695'Access,
      L_1696'Access,
      L_1697'Access,
      L_1698'Access,
      L_1699'Access,
      L_1700'Access,
      L_1701'Access);

   L_1702: aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_1703: aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_1704: aliased constant String := "--  Template: templates/spec-reentrant-io"
       & ".ads";
   L_1705: aliased constant String := "with Ada.Text_IO;";
   L_1706: aliased constant String := "with ${NAME}_DFA; use ${NAME}_DFA;";
   L_1707: aliased constant String := "%if private";
   L_1708: aliased constant String := "private package ${NAME}_IO is";
   L_1709: aliased constant String := "%else";
   L_1710: aliased constant String := "package ${NAME}_IO is";
   L_1711: aliased constant String := "%end";
   L_1712: aliased constant String := "";
   L_1713: aliased constant String := "   NULL_IN_INPUT         : exception;";
   L_1714: aliased constant String := "   AFLEX_INTERNAL_ERROR  : exception;";
   L_1715: aliased constant String := "   UNEXPECTED_LAST_MATCH : exception;";
   L_1716: aliased constant String := "   PUSHBACK_OVERFLOW     : exception;";
   L_1717: aliased constant String := "   AFLEX_SCANNER_JAMMED  : exception;";
   L_1718: aliased constant String := "   type eob_action_type is (EOB_ACT_RESTA"
       & "RT_SCAN,";
   L_1719: aliased constant String := "                            EOB_ACT_END_O"
       & "F_FILE,";
   L_1720: aliased constant String := "                            EOB_ACT_LAST_"
       & "MATCH);";
   L_1721: aliased constant String := "   YY_END_OF_BUFFER_CHAR : constant Chara"
       & "cter := ASCII.NUL;";
   L_1722: aliased constant String := "";
   L_1723: aliased constant String := "%if error";
   L_1724: aliased constant String := "   --   In order to support YY_Get_Token_"
       & "Line, we need";
   L_1725: aliased constant String := "   --   a variable to hold current line.";
   L_1726: aliased constant String := "   type String_Ptr is access String;";
   L_1727: aliased constant String := "";
   L_1728: aliased constant String := "%end";
   L_1729: aliased constant String := "   type Context_Type is limited record";
   L_1730: aliased constant String := "      user_input_file       : Ada.Text_IO"
       & ".File_Type;";
   L_1731: aliased constant String := "%if output";
   L_1732: aliased constant String := "      user_output_file      : Ada.Text_IO"
       & ".File_Type;";
   L_1733: aliased constant String := "%end";
   L_1734: aliased constant String := "      yy_n_chars            : Integer;   "
       & "    --  number of characters read into yy_ch_buf";
   L_1735: aliased constant String := "";
   L_1736: aliased constant String := "      --  true when we've seen an EOF for"
       & " the current input file";
   L_1737: aliased constant String := "      yy_eof_has_been_seen  : Boolean;";
   L_1738: aliased constant String := "      dfa                   : ${NAME}_DFA"
       & ".Context_Type;";
   L_1739: aliased constant String := "      YYLVal                : YYSType;";
   L_1740: aliased constant String := "      YYVal                 : YYSType;";
   L_1741: aliased constant String := "%yytype";
   L_1742: aliased constant String := "";
   L_1743: aliased constant String := "%if error";
   L_1744: aliased constant String := "      Saved_Tok_Line1 : String_Ptr := Nul"
       & "l;";
   L_1745: aliased constant String := "      Line_Number_Of_Saved_Tok_Line1 : In"
       & "teger := 0;";
   L_1746: aliased constant String := "      Saved_Tok_Line2 : String_Ptr := Nul"
       & "l;";
   L_1747: aliased constant String := "      Line_Number_Of_Saved_Tok_Line2 : In"
       & "teger := 0;";
   L_1748: aliased constant String := "      --  Aflex will try to get next buff"
       & "er before it processs the";
   L_1749: aliased constant String := "      --  last token. Since now Aflex has"
       & " been changed to accept";
   L_1750: aliased constant String := "      --  one line by one line, the last "
       & "token in the buffer is";
   L_1751: aliased constant String := "      --  always end_of_line ( or end_of_"
       & "buffer ). So before the";
   L_1752: aliased constant String := "      --  end_of_line is processed, next "
       & "line will be retrieved";
   L_1753: aliased constant String := "      --  into the buffer. So we need to "
       & "maintain two lines,";
   L_1754: aliased constant String := "      --  which line will be returned in "
       & "Get_Token_Line is";
   L_1755: aliased constant String := "      --  determined according to the lin"
       & "e number. It is the same";
   L_1756: aliased constant String := "      --  reason that we can not reinitia"
       & "lize tok_end_col to 0 in";
   L_1757: aliased constant String := "      --  Yy_Input, but we must do it in "
       & "yylex after we process the";
   L_1758: aliased constant String := "      --  end_of_line.";
   L_1759: aliased constant String := "      Tok_Begin_Line : Integer := 1;";
   L_1760: aliased constant String := "      Tok_End_Line   : Integer := 1;";
   L_1761: aliased constant String := "      Tok_End_Col    : Integer := 0;";
   L_1762: aliased constant String := "      Tok_Begin_Col  : Integer := 0;";
   L_1763: aliased constant String := "      Token_At_End_Of_Line : Boolean := F"
       & "alse;";
   L_1764: aliased constant String := "      --  Indicates whether or not last m"
       & "atched token is end_of_line.";
   L_1765: aliased constant String := "%end";
   L_1766: aliased constant String := "   end record;";
   L_1767: aliased constant String := "";
   L_1768: aliased constant String := "   procedure YY_INPUT (Context  : in out "
       & "Context_Type;";
   L_1769: aliased constant String := "                       buf      : out unb"
       & "ounded_character_array;";
   L_1770: aliased constant String := "                       result   : out Int"
       & "eger;";
   L_1771: aliased constant String := "                       max_size : in Inte"
       & "ger);";
   L_1772: aliased constant String := "   function yy_get_next_buffer (Context :"
       & " in out Context_Type) return eob_action_type;";
   L_1773: aliased constant String := "%if unput";
   L_1774: aliased constant String := "   procedure yyUnput (Context : in out Co"
       & "ntext_Type;";
   L_1775: aliased constant String := "                      c       : Character"
       & ";";
   L_1776: aliased constant String := "                      yy_bp   : in out In"
       & "teger);";
   L_1777: aliased constant String := "   procedure Unput (Context : in out Cont"
       & "ext_Type;";
   L_1778: aliased constant String := "                    c       : Character);";
   L_1779: aliased constant String := "%end";
   L_1780: aliased constant String := "%if input";
   L_1781: aliased constant String := "   function Input (Context : in out Conte"
       & "xt_Type) return Character;";
   L_1782: aliased constant String := "%end";
   L_1783: aliased constant String := "%if output";
   L_1784: aliased constant String := "   procedure Output (Context : in out Con"
       & "text_Type; c : Character);";
   L_1785: aliased constant String := "   procedure Output_New_Line (Context : i"
       & "n out Context_Type);";
   L_1786: aliased constant String := "   function Output_Column (Context : in C"
       & "ontext_Type) return Ada.Text_IO.Count;";
   L_1787: aliased constant String := "%end";
   L_1788: aliased constant String := "%if error";
   L_1789: aliased constant String := "   function Input_Line (Context : in Cont"
       & "ext_Type) return Ada.Text_IO.Count;";
   L_1790: aliased constant String := "%end";
   L_1791: aliased constant String := "%if yywrap";
   L_1792: aliased constant String := "   function yyWrap (Context : in Context_"
       & "Type) return Boolean;";
   L_1793: aliased constant String := "%end";
   L_1794: aliased constant String := "   procedure Open_Input (Context : in out"
       & " Context_Type; fname : in String);";
   L_1795: aliased constant String := "   procedure Close_Input (Context : in ou"
       & "t Context_Type);";
   L_1796: aliased constant String := "%if output";
   L_1797: aliased constant String := "   procedure Create_Output (Context : in "
       & "out Context_Type) fname : in String := """");";
   L_1798: aliased constant String := "   procedure Close_Output (Context : in o"
       & "ut Context_Type);";
   L_1799: aliased constant String := "%end";
   L_1800: aliased constant String := "";
   L_1801: aliased constant String := "%if error";
   L_1802: aliased constant String := "   procedure Yy_Get_Token_Line (Context :"
       & " in out Context_Type;";
   L_1803: aliased constant String := "                                Yy_Line_S"
       & "tring : out String;";
   L_1804: aliased constant String := "                                Yy_Line_L"
       & "ength : out Natural );";
   L_1805: aliased constant String := "   --  Returnes the entire line in the in"
       & "put, on which the currently";
   L_1806: aliased constant String := "   --  matched token resides.";
   L_1807: aliased constant String := "";
   L_1808: aliased constant String := "   function Yy_Line_Number (Context : in "
       & "Context_Type) return Natural;";
   L_1809: aliased constant String := "   --  Returns the line number of the cur"
       & "rently matched token.";
   L_1810: aliased constant String := "   --  In case a token spans lines, then "
       & "the line number of the first line";
   L_1811: aliased constant String := "   --  is returned.";
   L_1812: aliased constant String := "";
   L_1813: aliased constant String := "   function Yy_Begin_Column (Context : in"
       & " Context_Type) return Natural;";
   L_1814: aliased constant String := "   function Yy_End_Column (Context : in C"
       & "ontext_Type) return Natural;";
   L_1815: aliased constant String := "   --  Returns the beginning and ending c"
       & "olumn positions of the";
   L_1816: aliased constant String := "   --  currently mathched token. If the t"
       & "oken spans lines then the";
   L_1817: aliased constant String := "   --  begin column number is the column "
       & "number on the first line";
   L_1818: aliased constant String := "   --  and the end columne number is the "
       & "column number on the last line.";
   L_1819: aliased constant String := "%end";
   L_1820: aliased constant String := "";
   L_1821: aliased constant String := "end ${NAME}_IO;";
   spec_reentrant_io : aliased constant Content_Array :=
     (L_1702'Access,
      L_1703'Access,
      L_1704'Access,
      L_1705'Access,
      L_1706'Access,
      L_1707'Access,
      L_1708'Access,
      L_1709'Access,
      L_1710'Access,
      L_1711'Access,
      L_1712'Access,
      L_1713'Access,
      L_1714'Access,
      L_1715'Access,
      L_1716'Access,
      L_1717'Access,
      L_1718'Access,
      L_1719'Access,
      L_1720'Access,
      L_1721'Access,
      L_1722'Access,
      L_1723'Access,
      L_1724'Access,
      L_1725'Access,
      L_1726'Access,
      L_1727'Access,
      L_1728'Access,
      L_1729'Access,
      L_1730'Access,
      L_1731'Access,
      L_1732'Access,
      L_1733'Access,
      L_1734'Access,
      L_1735'Access,
      L_1736'Access,
      L_1737'Access,
      L_1738'Access,
      L_1739'Access,
      L_1740'Access,
      L_1741'Access,
      L_1742'Access,
      L_1743'Access,
      L_1744'Access,
      L_1745'Access,
      L_1746'Access,
      L_1747'Access,
      L_1748'Access,
      L_1749'Access,
      L_1750'Access,
      L_1751'Access,
      L_1752'Access,
      L_1753'Access,
      L_1754'Access,
      L_1755'Access,
      L_1756'Access,
      L_1757'Access,
      L_1758'Access,
      L_1759'Access,
      L_1760'Access,
      L_1761'Access,
      L_1762'Access,
      L_1763'Access,
      L_1764'Access,
      L_1765'Access,
      L_1766'Access,
      L_1767'Access,
      L_1768'Access,
      L_1769'Access,
      L_1770'Access,
      L_1771'Access,
      L_1772'Access,
      L_1773'Access,
      L_1774'Access,
      L_1775'Access,
      L_1776'Access,
      L_1777'Access,
      L_1778'Access,
      L_1779'Access,
      L_1780'Access,
      L_1781'Access,
      L_1782'Access,
      L_1783'Access,
      L_1784'Access,
      L_1785'Access,
      L_1786'Access,
      L_1787'Access,
      L_1788'Access,
      L_1789'Access,
      L_1790'Access,
      L_1791'Access,
      L_1792'Access,
      L_1793'Access,
      L_1794'Access,
      L_1795'Access,
      L_1796'Access,
      L_1797'Access,
      L_1798'Access,
      L_1799'Access,
      L_1800'Access,
      L_1801'Access,
      L_1802'Access,
      L_1803'Access,
      L_1804'Access,
      L_1805'Access,
      L_1806'Access,
      L_1807'Access,
      L_1808'Access,
      L_1809'Access,
      L_1810'Access,
      L_1811'Access,
      L_1812'Access,
      L_1813'Access,
      L_1814'Access,
      L_1815'Access,
      L_1816'Access,
      L_1817'Access,
      L_1818'Access,
      L_1819'Access,
      L_1820'Access,
      L_1821'Access);

end Template_Manager.Templates;
