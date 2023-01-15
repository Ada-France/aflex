--  Advanced Resource Embedder 1.3.0
package Template_Manager.Templates is

   type Content_Array is array (Positive range <>) of access constant String;
   type Content_Access is access constant Content_Array;

   body_dfa : aliased constant Content_Array;
   body_io : aliased constant Content_Array;
   spec_dfa : aliased constant Content_Array;
   spec_io : aliased constant Content_Array;

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
   L_43  : aliased constant String := "package body ${NAME}_IO is";
   L_44  : aliased constant String := "";
   L_45  : aliased constant String := "   --  gets input and stuffs it into 'buf"
       & "'.  number of characters read, or YY_NULL,";
   L_46  : aliased constant String := "   --  is returned in 'result'.";
   L_47  : aliased constant String := "";
   L_48  : aliased constant String := "   procedure YY_INPUT (buf      : out unb"
       & "ounded_character_array;";
   L_49  : aliased constant String := "                       result   : out Int"
       & "eger;";
   L_50  : aliased constant String := "                       max_size : in Inte"
       & "ger) is";
   L_51  : aliased constant String := "      c   : Character;";
   L_52  : aliased constant String := "      i   : Integer := 1;";
   L_53  : aliased constant String := "      loc : Integer := buf'First;";
   L_54  : aliased constant String := "%if error";
   L_55  : aliased constant String := "   --    Since buf is an out parameter wh"
       & "ich is not readable";
   L_56  : aliased constant String := "   --    and saved lines is a string poin"
       & "ter which space must";
   L_57  : aliased constant String := "   --    be allocated after we know the s"
       & "ize, we maintain";
   L_58  : aliased constant String := "   --    an extra buffer to collect the i"
       & "nput line and";
   L_59  : aliased constant String := "   --    save it into the saved line 2.";
   L_60  : aliased constant String := "      Temp_Line : String (1 .. YY_BUF_SIZ"
       & "E + 2);";
   L_61  : aliased constant String := "%end";
   L_62  : aliased constant String := "   begin";
   L_63  : aliased constant String := "%if error";
   L_64  : aliased constant String := "      -- buf := ( others => ASCII.NUL ); "
       & "-- CvdL: does not work in GNAT";
   L_65  : aliased constant String := "      for j in buf'First .. buf'Last loop";
   L_66  : aliased constant String := "         buf (j) := ASCII.NUL;";
   L_67  : aliased constant String := "      end loop;";
   L_68  : aliased constant String := "      -- Move the saved lines forward.";
   L_69  : aliased constant String := "      Saved_Tok_Line1 := Saved_Tok_Line2;";
   L_70  : aliased constant String := "      Line_Number_Of_Saved_Tok_Line1 := L"
       & "ine_Number_Of_Saved_Tok_Line2;";
   L_71  : aliased constant String := "%end";
   L_72  : aliased constant String := "";
   L_73  : aliased constant String := "      if Text_IO.Is_Open (user_input_file"
       & ") then";
   L_74  : aliased constant String := "         while i <= max_size loop";
   L_75  : aliased constant String := "            --  Ada ate our newline, put "
       & "it back on the end.";
   L_76  : aliased constant String := "            if Text_IO.End_Of_Line (user_"
       & "input_file) then";
   L_77  : aliased constant String := "               buf (loc) := ASCII.LF;";
   L_78  : aliased constant String := "               Text_IO.Skip_Line (user_in"
       & "put_file, 1);";
   L_79  : aliased constant String := "%if error";
   L_80  : aliased constant String := "               --   We try to get one lin"
       & "e by one line. So we return";
   L_81  : aliased constant String := "               --   here because we saw t"
       & "he end_of_line.";
   L_82  : aliased constant String := "               result := i;";
   L_83  : aliased constant String := "               Temp_Line (i) := ASCII.LF;";
   L_84  : aliased constant String := "               Saved_Tok_Line2 := new Str"
       & "ing (1 .. i);";
   L_85  : aliased constant String := "               Saved_Tok_Line2 (1 .. i) :"
       & "= Temp_Line (1 .. i);";
   L_86  : aliased constant String := "               Line_Number_Of_Saved_Tok_L"
       & "ine2 := Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_87  : aliased constant String := "               return;";
   L_88  : aliased constant String := "%end";
   L_89  : aliased constant String := "%if interactive";
   L_90  : aliased constant String := "               i := i + 1; --  update cou"
       & "nter, miss end of loop";
   L_91  : aliased constant String := "               exit; --  in interactive m"
       & "ode return at end of line.";
   L_92  : aliased constant String := "%end";
   L_93  : aliased constant String := "            else";
   L_94  : aliased constant String := "               --  UCI CODES CHANGED:";
   L_95  : aliased constant String := "               --    The following codes "
       & "are modified. Previous codes is commented out.";
   L_96  : aliased constant String := "               --    The purpose of doing"
       & " this is to make it possible to set Temp_Line";
   L_97  : aliased constant String := "               --    in Ayacc-extension s"
       & "pecific codes. Definitely, we can read the character";
   L_98  : aliased constant String := "               --    into the Temp_Line a"
       & "nd then set the buf. But Temp_Line will only";
   L_99  : aliased constant String := "               --    be used in Ayacc-ext"
       & "ension specific codes which makes";
   L_100 : aliased constant String := "               --    this approach imposs"
       & "ible.";
   L_101 : aliased constant String := "               Text_IO.Get (user_input_fi"
       & "le, c);";
   L_102 : aliased constant String := "               buf (loc) := c;";
   L_103 : aliased constant String := "--             Text_IO.Get (user_input_fi"
       & "le, buf (loc));";
   L_104 : aliased constant String := "%if error";
   L_105 : aliased constant String := "               Temp_Line (i) := c;";
   L_106 : aliased constant String := "%end";
   L_107 : aliased constant String := "            end if;";
   L_108 : aliased constant String := "";
   L_109 : aliased constant String := "            loc := loc + 1;";
   L_110 : aliased constant String := "            i := i + 1;";
   L_111 : aliased constant String := "         end loop;";
   L_112 : aliased constant String := "      else";
   L_113 : aliased constant String := "         while i <= max_size loop";
   L_114 : aliased constant String := "            if Text_IO.End_Of_Line then -"
       & "- Ada ate our newline, put it back on the end.";
   L_115 : aliased constant String := "               buf (loc) := ASCII.LF;";
   L_116 : aliased constant String := "               Text_IO.Skip_Line (1);";
   L_117 : aliased constant String := "%if error";
   L_118 : aliased constant String := "               --   We try to get one lin"
       & "e by one line. So we return";
   L_119 : aliased constant String := "               --   here because we saw t"
       & "he end_of_line.";
   L_120 : aliased constant String := "               result := i;";
   L_121 : aliased constant String := "               Temp_Line (i) := ASCII.LF;";
   L_122 : aliased constant String := "               Saved_Tok_Line2 := new Str"
       & "ing (1 .. i);";
   L_123 : aliased constant String := "               Saved_Tok_Line2 (1 .. i) :"
       & "= Temp_Line (1 .. i);";
   L_124 : aliased constant String := "               Line_Number_Of_Saved_Tok_L"
       & "ine2 := Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_125 : aliased constant String := "               return;";
   L_126 : aliased constant String := "%end";
   L_127 : aliased constant String := "";
   L_128 : aliased constant String := "            else";
   L_129 : aliased constant String := "               --  The following codes ar"
       & "e modified. Previous codes is commented out.";
   L_130 : aliased constant String := "               --  The purpose of doing t"
       & "his is to make it possible to set Temp_Line";
   L_131 : aliased constant String := "               --  in Ayacc-extension spe"
       & "cific codes. Definitely, we can read the character";
   L_132 : aliased constant String := "               --  into the Temp_Line and"
       & " then set the buf. But Temp_Line will only";
   L_133 : aliased constant String := "               --  be used in Ayacc-exten"
       & "sion specific codes which makes this approach impossible.";
   L_134 : aliased constant String := "               Text_IO.Get (c);";
   L_135 : aliased constant String := "               buf (loc) := c;";
   L_136 : aliased constant String := "               --         get (buf (loc))"
       & ";";
   L_137 : aliased constant String := "%if error";
   L_138 : aliased constant String := "               Temp_Line (i) := c;";
   L_139 : aliased constant String := "%end";
   L_140 : aliased constant String := "            end if;";
   L_141 : aliased constant String := "";
   L_142 : aliased constant String := "            loc := loc + 1;";
   L_143 : aliased constant String := "            i := i + 1;";
   L_144 : aliased constant String := "         end loop;";
   L_145 : aliased constant String := "      end if; --  for input file being st"
       & "andard input";
   L_146 : aliased constant String := "      result := i - 1;";
   L_147 : aliased constant String := "";
   L_148 : aliased constant String := "%if error";
   L_149 : aliased constant String := "      --  Since we get one line by one li"
       & "ne, if we";
   L_150 : aliased constant String := "      --  reach here, it means that curre"
       & "nt line have";
   L_151 : aliased constant String := "      --  more that max_size characters. "
       & "So it is";
   L_152 : aliased constant String := "      --  impossible to hold the whole li"
       & "ne. We";
   L_153 : aliased constant String := "      --  report the warning message and "
       & "continue.";
   L_154 : aliased constant String := "      buf (loc - 1) := Ascii.LF;";
   L_155 : aliased constant String := "      if Text_IO.Is_Open (user_input_file"
       & ") then";
   L_156 : aliased constant String := "         Text_IO.Skip_Line (user_input_fi"
       & "le, 1);";
   L_157 : aliased constant String := "      else";
   L_158 : aliased constant String := "         Text_IO.Skip_Line (1);";
   L_159 : aliased constant String := "      end if;";
   L_160 : aliased constant String := "      Temp_Line (i - 1) := ASCII.LF;";
   L_161 : aliased constant String := "      Saved_Tok_Line2 := new String (1 .."
       & " i - 1);";
   L_162 : aliased constant String := "      Saved_Tok_Line2 (1 .. i - 1) := Tem"
       & "p_Line (1 .. i - 1);";
   L_163 : aliased constant String := "      Line_Number_Of_Saved_Tok_Line2 := L"
       & "ine_Number_Of_Saved_Tok_Line1 + 1;";
   L_164 : aliased constant String := "      Put_Line (""Input line """;
   L_165 : aliased constant String := "                & Integer'Image ( Line_Nu"
       & "mber_Of_Saved_Tok_Line2 )";
   L_166 : aliased constant String := "                & ""has more than """;
   L_167 : aliased constant String := "                & Integer'Image ( max_siz"
       & "e )";
   L_168 : aliased constant String := "                & "" characters, ... trun"
       & "cated."" );";
   L_169 : aliased constant String := "%end";
   L_170 : aliased constant String := "   exception";
   L_171 : aliased constant String := "      when Text_IO.End_Error =>";
   L_172 : aliased constant String := "         result := i - 1;";
   L_173 : aliased constant String := "         --  when we hit EOF we need to s"
       & "et yy_eof_has_been_seen";
   L_174 : aliased constant String := "         yy_eof_has_been_seen := True;";
   L_175 : aliased constant String := "%if error";
   L_176 : aliased constant String := "         --   Processing incomplete line.";
   L_177 : aliased constant String := "         if i /= 1 then";
   L_178 : aliased constant String := "            -- Current line is not empty "
       & "but do not have end_of_line.";
   L_179 : aliased constant String := "            -- So current line is incompl"
       & "ete line. But we still need";
   L_180 : aliased constant String := "            -- to save it.";
   L_181 : aliased constant String := "            Saved_Tok_Line2 := new String"
       & " (1 .. i - 1);";
   L_182 : aliased constant String := "            Saved_Tok_Line2 (1 .. i - 1) "
       & ":= Temp_Line (1 .. i - 1);";
   L_183 : aliased constant String := "            Line_Number_Of_Saved_Tok_Line"
       & "2 := Line_Number_Of_Saved_Tok_Line1 + 1;";
   L_184 : aliased constant String := "         end if;";
   L_185 : aliased constant String := "%end";
   L_186 : aliased constant String := "   end YY_INPUT;";
   L_187 : aliased constant String := "";
   L_188 : aliased constant String := "   --  yy_get_next_buffer - try to read i"
       & "n new buffer";
   L_189 : aliased constant String := "   --";
   L_190 : aliased constant String := "   --  returns a code representing an act"
       & "ion";
   L_191 : aliased constant String := "   --     EOB_ACT_LAST_MATCH -";
   L_192 : aliased constant String := "   --     EOB_ACT_RESTART_SCAN - restart "
       & "the scanner";
   L_193 : aliased constant String := "   --     EOB_ACT_END_OF_FILE - end of fi"
       & "le";
   L_194 : aliased constant String := "";
   L_195 : aliased constant String := "   function yy_get_next_buffer return eob"
       & "_action_type is";
   L_196 : aliased constant String := "      dest           : Integer := 0;";
   L_197 : aliased constant String := "      source         : Integer := yytext_"
       & "ptr - 1; -- copy prev. char, too";
   L_198 : aliased constant String := "      number_to_move : Integer;";
   L_199 : aliased constant String := "      ret_val        : eob_action_type;";
   L_200 : aliased constant String := "      num_to_read    : Integer;";
   L_201 : aliased constant String := "   begin";
   L_202 : aliased constant String := "      if yy_c_buf_p > yy_n_chars + 1 then";
   L_203 : aliased constant String := "         raise NULL_IN_INPUT;";
   L_204 : aliased constant String := "      end if;";
   L_205 : aliased constant String := "";
   L_206 : aliased constant String := "      --  try to read more data";
   L_207 : aliased constant String := "";
   L_208 : aliased constant String := "      --  first move last chars to start "
       & "of buffer";
   L_209 : aliased constant String := "      number_to_move := yy_c_buf_p - yyte"
       & "xt_ptr;";
   L_210 : aliased constant String := "";
   L_211 : aliased constant String := "      for i in 0 .. number_to_move - 1 lo"
       & "op";
   L_212 : aliased constant String := "         yy_ch_buf (dest) := yy_ch_buf (s"
       & "ource);";
   L_213 : aliased constant String := "         dest := dest + 1;";
   L_214 : aliased constant String := "         source := source + 1;";
   L_215 : aliased constant String := "      end loop;";
   L_216 : aliased constant String := "";
   L_217 : aliased constant String := "      if yy_eof_has_been_seen then";
   L_218 : aliased constant String := "         --  don't do the read, it's not "
       & "guaranteed to return an EOF,";
   L_219 : aliased constant String := "         --  just force an EOF";
   L_220 : aliased constant String := "";
   L_221 : aliased constant String := "         yy_n_chars := 0;";
   L_222 : aliased constant String := "      else";
   L_223 : aliased constant String := "         num_to_read := YY_BUF_SIZE - num"
       & "ber_to_move - 1;";
   L_224 : aliased constant String := "";
   L_225 : aliased constant String := "         if num_to_read > YY_READ_BUF_SIZ"
       & "E then";
   L_226 : aliased constant String := "            num_to_read := YY_READ_BUF_SI"
       & "ZE;";
   L_227 : aliased constant String := "         end if;";
   L_228 : aliased constant String := "";
   L_229 : aliased constant String := "         --  read in more data";
   L_230 : aliased constant String := "         YY_INPUT (yy_ch_buf (number_to_m"
       & "ove .. yy_ch_buf'Last), yy_n_chars, num_to_read);";
   L_231 : aliased constant String := "      end if;";
   L_232 : aliased constant String := "      if yy_n_chars = 0 then";
   L_233 : aliased constant String := "         if number_to_move = 1 then";
   L_234 : aliased constant String := "            ret_val := EOB_ACT_END_OF_FIL"
       & "E;";
   L_235 : aliased constant String := "         else";
   L_236 : aliased constant String := "            ret_val := EOB_ACT_LAST_MATCH"
       & ";";
   L_237 : aliased constant String := "         end if;";
   L_238 : aliased constant String := "";
   L_239 : aliased constant String := "         yy_eof_has_been_seen := True;";
   L_240 : aliased constant String := "      else";
   L_241 : aliased constant String := "         ret_val := EOB_ACT_RESTART_SCAN;";
   L_242 : aliased constant String := "      end if;";
   L_243 : aliased constant String := "";
   L_244 : aliased constant String := "      yy_n_chars := yy_n_chars + number_t"
       & "o_move;";
   L_245 : aliased constant String := "      yy_ch_buf (yy_n_chars) := YY_END_OF"
       & "_BUFFER_CHAR;";
   L_246 : aliased constant String := "      yy_ch_buf (yy_n_chars + 1) := YY_EN"
       & "D_OF_BUFFER_CHAR;";
   L_247 : aliased constant String := "";
   L_248 : aliased constant String := "      --  yytext begins at the second cha"
       & "racter in";
   L_249 : aliased constant String := "      --  yy_ch_buf; the first character "
       & "is the one which";
   L_250 : aliased constant String := "      --  preceded it before reading in t"
       & "he latest buffer;";
   L_251 : aliased constant String := "      --  it needs to be kept around in c"
       & "ase it's a";
   L_252 : aliased constant String := "      --  newline, so yy_get_previous_sta"
       & "te() will have";
   L_253 : aliased constant String := "      --  with '^' rules active";
   L_254 : aliased constant String := "";
   L_255 : aliased constant String := "      yytext_ptr := 1;";
   L_256 : aliased constant String := "";
   L_257 : aliased constant String := "      return ret_val;";
   L_258 : aliased constant String := "   end yy_get_next_buffer;";
   L_259 : aliased constant String := "";
   L_260 : aliased constant String := "%if unput";
   L_261 : aliased constant String := "   procedure yyUnput (c : Character; yy_b"
       & "p : in out Integer) is";
   L_262 : aliased constant String := "      number_to_move : Integer;";
   L_263 : aliased constant String := "      dest : Integer;";
   L_264 : aliased constant String := "      source : Integer;";
   L_265 : aliased constant String := "      tmp_yy_cp : Integer;";
   L_266 : aliased constant String := "   begin";
   L_267 : aliased constant String := "      tmp_yy_cp := yy_c_buf_p;";
   L_268 : aliased constant String := "      yy_ch_buf (tmp_yy_cp) := yy_hold_ch"
       & "ar; --  undo effects of setting up yytext";
   L_269 : aliased constant String := "";
   L_270 : aliased constant String := "      if tmp_yy_cp < 2 then";
   L_271 : aliased constant String := "         --  need to shift things up to m"
       & "ake room";
   L_272 : aliased constant String := "         number_to_move := yy_n_chars + 2"
       & "; --  +2 for EOB chars";
   L_273 : aliased constant String := "         dest := YY_BUF_SIZE + 2;";
   L_274 : aliased constant String := "         source := number_to_move;";
   L_275 : aliased constant String := "";
   L_276 : aliased constant String := "         while source > 0 loop";
   L_277 : aliased constant String := "            dest := dest - 1;";
   L_278 : aliased constant String := "            source := source - 1;";
   L_279 : aliased constant String := "            yy_ch_buf (dest) := yy_ch_buf"
       & " (source);";
   L_280 : aliased constant String := "         end loop;";
   L_281 : aliased constant String := "";
   L_282 : aliased constant String := "         tmp_yy_cp := tmp_yy_cp + dest - "
       & "source;";
   L_283 : aliased constant String := "         yy_bp := yy_bp + dest - source;";
   L_284 : aliased constant String := "         yy_n_chars := YY_BUF_SIZE;";
   L_285 : aliased constant String := "";
   L_286 : aliased constant String := "         if tmp_yy_cp < 2 then";
   L_287 : aliased constant String := "            raise PUSHBACK_OVERFLOW;";
   L_288 : aliased constant String := "         end if;";
   L_289 : aliased constant String := "      end if;";
   L_290 : aliased constant String := "";
   L_291 : aliased constant String := "      if tmp_yy_cp > yy_bp and then yy_ch"
       & "_buf (tmp_yy_cp - 1) = ASCII.LF then";
   L_292 : aliased constant String := "         yy_ch_buf (tmp_yy_cp - 2) := ASC"
       & "II.LF;";
   L_293 : aliased constant String := "      end if;";
   L_294 : aliased constant String := "";
   L_295 : aliased constant String := "      tmp_yy_cp := tmp_yy_cp - 1;";
   L_296 : aliased constant String := "      yy_ch_buf (tmp_yy_cp) := c;";
   L_297 : aliased constant String := "";
   L_298 : aliased constant String := "      --  Note:  this code is the text of"
       & " YY_DO_BEFORE_ACTION, only";
   L_299 : aliased constant String := "      --         here we get different yy"
       & "_cp and yy_bp's";
   L_300 : aliased constant String := "      yytext_ptr := yy_bp;";
   L_301 : aliased constant String := "      yy_hold_char := yy_ch_buf (tmp_yy_c"
       & "p);";
   L_302 : aliased constant String := "      yy_ch_buf (tmp_yy_cp) := ASCII.NUL;";
   L_303 : aliased constant String := "      yy_c_buf_p := tmp_yy_cp;";
   L_304 : aliased constant String := "   end yyUnput;";
   L_305 : aliased constant String := "";
   L_306 : aliased constant String := "   procedure Unput (c : Character) is";
   L_307 : aliased constant String := "   begin";
   L_308 : aliased constant String := "      yyUnput (c, yy_bp);";
   L_309 : aliased constant String := "   end Unput;";
   L_310 : aliased constant String := "%end";
   L_311 : aliased constant String := "";
   L_312 : aliased constant String := "   function Input return Character is";
   L_313 : aliased constant String := "      c : Character;";
   L_314 : aliased constant String := "   begin";
   L_315 : aliased constant String := "      yy_ch_buf (yy_c_buf_p) := yy_hold_c"
       & "har;";
   L_316 : aliased constant String := "";
   L_317 : aliased constant String := "      if yy_ch_buf (yy_c_buf_p) = YY_END_"
       & "OF_BUFFER_CHAR then";
   L_318 : aliased constant String := "         --  need more input";
   L_319 : aliased constant String := "         yytext_ptr := yy_c_buf_p;";
   L_320 : aliased constant String := "         yy_c_buf_p := yy_c_buf_p + 1;";
   L_321 : aliased constant String := "";
   L_322 : aliased constant String := "         case yy_get_next_buffer is";
   L_323 : aliased constant String := "            --  this code, unfortunately,"
       & " is somewhat redundant with";
   L_324 : aliased constant String := "            --  that above";
   L_325 : aliased constant String := "";
   L_326 : aliased constant String := "         when EOB_ACT_END_OF_FILE =>";
   L_327 : aliased constant String := "            if yyWrap then";
   L_328 : aliased constant String := "               yy_c_buf_p := yytext_ptr;";
   L_329 : aliased constant String := "               return ASCII.NUL;";
   L_330 : aliased constant String := "            end if;";
   L_331 : aliased constant String := "";
   L_332 : aliased constant String := "            yy_ch_buf (0) := ASCII.LF;";
   L_333 : aliased constant String := "            yy_n_chars := 1;";
   L_334 : aliased constant String := "            yy_ch_buf (yy_n_chars) := YY_"
       & "END_OF_BUFFER_CHAR;";
   L_335 : aliased constant String := "            yy_ch_buf (yy_n_chars + 1) :="
       & " YY_END_OF_BUFFER_CHAR;";
   L_336 : aliased constant String := "            yy_eof_has_been_seen := False"
       & ";";
   L_337 : aliased constant String := "            yy_c_buf_p := 1;";
   L_338 : aliased constant String := "            yytext_ptr := yy_c_buf_p;";
   L_339 : aliased constant String := "            yy_hold_char := yy_ch_buf (yy"
       & "_c_buf_p);";
   L_340 : aliased constant String := "";
   L_341 : aliased constant String := "            return Input;";
   L_342 : aliased constant String := "         when EOB_ACT_RESTART_SCAN =>";
   L_343 : aliased constant String := "            yy_c_buf_p := yytext_ptr;";
   L_344 : aliased constant String := "";
   L_345 : aliased constant String := "         when EOB_ACT_LAST_MATCH =>";
   L_346 : aliased constant String := "            raise UNEXPECTED_LAST_MATCH;";
   L_347 : aliased constant String := "         end case;";
   L_348 : aliased constant String := "      end if;";
   L_349 : aliased constant String := "";
   L_350 : aliased constant String := "      c := yy_ch_buf (yy_c_buf_p);";
   L_351 : aliased constant String := "      yy_c_buf_p := yy_c_buf_p + 1;";
   L_352 : aliased constant String := "      yy_hold_char := yy_ch_buf (yy_c_buf"
       & "_p);";
   L_353 : aliased constant String := "";
   L_354 : aliased constant String := "      return c;";
   L_355 : aliased constant String := "   end Input;";
   L_356 : aliased constant String := "";
   L_357 : aliased constant String := "%if output";
   L_358 : aliased constant String := "   procedure Output (c : Character) is";
   L_359 : aliased constant String := "   begin";
   L_360 : aliased constant String := "      if Is_Open (user_output_file) then";
   L_361 : aliased constant String := "         Text_IO.Put (user_output_file, c"
       & ");";
   L_362 : aliased constant String := "      else";
   L_363 : aliased constant String := "         Text_IO.Put (c);";
   L_364 : aliased constant String := "      end if;";
   L_365 : aliased constant String := "   end Output;";
   L_366 : aliased constant String := "";
   L_367 : aliased constant String := "   procedure Output_New_Line is";
   L_368 : aliased constant String := "   begin";
   L_369 : aliased constant String := "      if Is_Open (user_output_file) then";
   L_370 : aliased constant String := "         Text_IO.New_Line (user_output_fi"
       & "le);";
   L_371 : aliased constant String := "      else";
   L_372 : aliased constant String := "         Text_IO.New_Line;";
   L_373 : aliased constant String := "      end if;";
   L_374 : aliased constant String := "   end Output_New_Line;";
   L_375 : aliased constant String := "";
   L_376 : aliased constant String := "   function Output_Column return Text_IO."
       & "Count is";
   L_377 : aliased constant String := "   begin";
   L_378 : aliased constant String := "      if Is_Open (user_output_file) then";
   L_379 : aliased constant String := "         return Text_IO.Col (user_output_"
       & "file);";
   L_380 : aliased constant String := "      else";
   L_381 : aliased constant String := "         return Text_IO.Col;";
   L_382 : aliased constant String := "      end if;";
   L_383 : aliased constant String := "   end Output_Column;";
   L_384 : aliased constant String := "%end";
   L_385 : aliased constant String := "";
   L_386 : aliased constant String := "   --  default yywrap function - always t"
       & "reat EOF as an EOF";
   L_387 : aliased constant String := "   function yyWrap return Boolean is";
   L_388 : aliased constant String := "   begin";
   L_389 : aliased constant String := "      return True;";
   L_390 : aliased constant String := "   end yyWrap;";
   L_391 : aliased constant String := "";
   L_392 : aliased constant String := "   procedure Open_Input (fname : in Strin"
       & "g) is";
   L_393 : aliased constant String := "   begin";
   L_394 : aliased constant String := "      yy_init := True;";
   L_395 : aliased constant String := "      Open (user_input_file, Text_IO.In_F"
       & "ile, fname);";
   L_396 : aliased constant String := "   end Open_Input;";
   L_397 : aliased constant String := "";
   L_398 : aliased constant String := "%if output";
   L_399 : aliased constant String := "   procedure Create_Output (fname : in St"
       & "ring := """") is";
   L_400 : aliased constant String := "   begin";
   L_401 : aliased constant String := "      if fname /= """" then";
   L_402 : aliased constant String := "         Create (user_output_file, Text_I"
       & "O.Out_File, fname);";
   L_403 : aliased constant String := "      end if;";
   L_404 : aliased constant String := "   end Create_Output;";
   L_405 : aliased constant String := "%end";
   L_406 : aliased constant String := "";
   L_407 : aliased constant String := "   procedure Close_Input is";
   L_408 : aliased constant String := "   begin";
   L_409 : aliased constant String := "      if Is_Open (user_input_file) then";
   L_410 : aliased constant String := "         Text_IO.Close (user_input_file);";
   L_411 : aliased constant String := "      end if;";
   L_412 : aliased constant String := "   end Close_Input;";
   L_413 : aliased constant String := "";
   L_414 : aliased constant String := "%if output";
   L_415 : aliased constant String := "   procedure Close_Output is";
   L_416 : aliased constant String := "   begin";
   L_417 : aliased constant String := "      if Is_Open (user_output_file) then";
   L_418 : aliased constant String := "         Text_IO.Close (user_output_file)"
       & ";";
   L_419 : aliased constant String := "      end if;";
   L_420 : aliased constant String := "   end Close_Output;";
   L_421 : aliased constant String := "%end";
   L_422 : aliased constant String := "";
   L_423 : aliased constant String := "%if error";
   L_424 : aliased constant String := "   procedure Yy_Get_Token_Line ( Yy_Line_"
       & "String : out String;";
   L_425 : aliased constant String := "                                 Yy_Line_"
       & "Length : out Natural ) is";
   L_426 : aliased constant String := "   begin";
   L_427 : aliased constant String := "      --  Currently processing line is ei"
       & "ther in saved token line1 or";
   L_428 : aliased constant String := "      --  in saved token line2.";
   L_429 : aliased constant String := "      if Yy_Line_Number = Line_Number_Of_"
       & "Saved_Tok_Line1 then";
   L_430 : aliased constant String := "         Yy_Line_Length := Saved_Tok_Line"
       & "1.all'length;";
   L_431 : aliased constant String := "         Yy_Line_String ( Yy_Line_String'"
       & "First .. ( Yy_Line_String'First + Saved_Tok_Line1.all'length - 1 ))";
   L_432 : aliased constant String := "           := Saved_Tok_Line1 ( 1 .. Save"
       & "d_Tok_Line1.all'length );";
   L_433 : aliased constant String := "      else";
   L_434 : aliased constant String := "         Yy_Line_Length := Saved_Tok_Line"
       & "2.all'length;";
   L_435 : aliased constant String := "         Yy_Line_String ( Yy_Line_String'"
       & "First .. ( Yy_Line_String'First + Saved_Tok_Line2.all'length - 1 ))";
   L_436 : aliased constant String := "           := Saved_Tok_Line2 ( 1 .. Save"
       & "d_Tok_Line2.all'length );";
   L_437 : aliased constant String := "      end if;";
   L_438 : aliased constant String := "   end Yy_Get_Token_Line;";
   L_439 : aliased constant String := "";
   L_440 : aliased constant String := "   function Yy_Line_Number return Natural"
       & " is";
   L_441 : aliased constant String := "   begin";
   L_442 : aliased constant String := "      return Tok_Begin_Line;";
   L_443 : aliased constant String := "   end Yy_Line_Number;";
   L_444 : aliased constant String := "";
   L_445 : aliased constant String := "   function Yy_Begin_Column return Natura"
       & "l is";
   L_446 : aliased constant String := "   begin";
   L_447 : aliased constant String := "      return Tok_Begin_Col;";
   L_448 : aliased constant String := "   end Yy_Begin_Column;";
   L_449 : aliased constant String := "";
   L_450 : aliased constant String := "   function Yy_End_Column return Natural "
       & "is";
   L_451 : aliased constant String := "   begin";
   L_452 : aliased constant String := "      return Tok_End_Col;";
   L_453 : aliased constant String := "   end Yy_End_Column;";
   L_454 : aliased constant String := "";
   L_455 : aliased constant String := "%end";
   L_456 : aliased constant String := "";
   L_457 : aliased constant String := "end ${NAME}_IO;";
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
      L_457'Access);

   L_458 : aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_459 : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_460 : aliased constant String := "%if private";
   L_461 : aliased constant String := "package ${NAME}_DFA is";
   L_462 : aliased constant String := "%else";
   L_463 : aliased constant String := "package ${NAME}_DFA is";
   L_464 : aliased constant String := "%end";
   L_465 : aliased constant String := "";
   L_466 : aliased constant String := "%if debug";
   L_467 : aliased constant String := "   aflex_debug       : Boolean := True;";
   L_468 : aliased constant String := "%else";
   L_469 : aliased constant String := "   aflex_debug       : Boolean := False;";
   L_470 : aliased constant String := "%end";
   L_471 : aliased constant String := "%if yylineno";
   L_472 : aliased constant String := "   yylineno          : Natural := 0;";
   L_473 : aliased constant String := "   yylinecol         : Natural := 0;";
   L_474 : aliased constant String := "   yy_last_yylineno  : Natural := 0;";
   L_475 : aliased constant String := "   yy_last_yylinecol : Natural := 0;";
   L_476 : aliased constant String := "%end";
   L_477 : aliased constant String := "   yytext_ptr        : Integer; --  point"
       & "s to start of yytext in buffer";
   L_478 : aliased constant String := "";
   L_479 : aliased constant String := "   --  yy_ch_buf has to be 2 characters l"
       & "onger than YY_BUF_SIZE because we need";
   L_480 : aliased constant String := "   --  to put in 2 end-of-buffer characte"
       & "rs (this is explained where it is";
   L_481 : aliased constant String := "   --  done) at the end of yy_ch_buf";
   L_482 : aliased constant String := "";
   L_483 : aliased constant String := "   --  ----------------------------------"
       & "------------------------------------------";
   L_484 : aliased constant String := "   --  If the buffer size variable YY_REA"
       & "D_BUF_SIZE is too small, then";
   L_485 : aliased constant String := "   --  big comments won't be parsed and t"
       & "he parser stops.";
   L_486 : aliased constant String := "   --  YY_READ_BUF_SIZE should be at leas"
       & "t as large as the number of ASCII bytes in";
   L_487 : aliased constant String := "   --  comments that need to be parsed.";
   L_488 : aliased constant String := "";
   L_489 : aliased constant String := "   YY_READ_BUF_SIZE : constant Integer :="
       & "  75_000;";
   L_490 : aliased constant String := "   --  ----------------------------------"
       & "------------------------------------------";
   L_491 : aliased constant String := "";
   L_492 : aliased constant String := "   YY_BUF_SIZE : constant Integer := YY_R"
       & "EAD_BUF_SIZE * 2; --  size of input buffer";
   L_493 : aliased constant String := "";
   L_494 : aliased constant String := "   type unbounded_character_array is arra"
       & "y (Integer range <>) of Character;";
   L_495 : aliased constant String := "   subtype ch_buf_type is unbounded_chara"
       & "cter_array (0 .. YY_BUF_SIZE + 1);";
   L_496 : aliased constant String := "";
   L_497 : aliased constant String := "   yy_ch_buf    : ch_buf_type;";
   L_498 : aliased constant String := "   yy_cp, yy_bp : Integer;";
   L_499 : aliased constant String := "";
   L_500 : aliased constant String := "   --  yy_hold_char holds the character l"
       & "ost when yytext is formed";
   L_501 : aliased constant String := "   yy_hold_char : Character;";
   L_502 : aliased constant String := "   yy_c_buf_p   : Integer;   --  points t"
       & "o current character in buffer";
   L_503 : aliased constant String := "";
   L_504 : aliased constant String := "   function YYText return String;";
   L_505 : aliased constant String := "   function YYLength return Integer;";
   L_506 : aliased constant String := "   procedure YY_DO_BEFORE_ACTION;";
   L_507 : aliased constant String := "";
   L_508 : aliased constant String := "   subtype yy_state_type is Integer;";
   L_509 : aliased constant String := "";
   L_510 : aliased constant String := "   --  These variables are needed between"
       & " calls to YYLex.";
   L_511 : aliased constant String := "   yy_init                 : Boolean := T"
       & "rue; --  do we need to initialize YYLex?";
   L_512 : aliased constant String := "   yy_start                : Integer := 0"
       & "; --  current start state number";
   L_513 : aliased constant String := "   yy_last_accepting_state : yy_state_typ"
       & "e;";
   L_514 : aliased constant String := "   yy_last_accepting_cpos  : Integer;";
   L_515 : aliased constant String := "";
   L_516 : aliased constant String := "end ${NAME}_DFA;";
   spec_dfa : aliased constant Content_Array :=
     (L_458'Access,
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
      L_481'Access,
      L_482'Access,
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
      L_516'Access);

   L_517 : aliased constant String := "--  Warning: This file is automatically g"
       & "enerated by AFLEX.";
   L_518 : aliased constant String := "--           It is useless to modify it. "
       & "Change the "".Y"" & "".L"" files instead.";
   L_519 : aliased constant String := "with Ada.Text_IO; use Ada.Text_IO;";
   L_520 : aliased constant String := "with ${NAME}_DFA; use ${NAME}_DFA;";
   L_521 : aliased constant String := "%if private";
   L_522 : aliased constant String := "package ${NAME}_IO is";
   L_523 : aliased constant String := "%else";
   L_524 : aliased constant String := "package ${NAME}_IO is";
   L_525 : aliased constant String := "%end";
   L_526 : aliased constant String := "";
   L_527 : aliased constant String := "   user_input_file       : File_Type;";
   L_528 : aliased constant String := "%if output";
   L_529 : aliased constant String := "   user_output_file      : File_Type;";
   L_530 : aliased constant String := "%end";
   L_531 : aliased constant String := "   NULL_IN_INPUT         : exception;";
   L_532 : aliased constant String := "   AFLEX_INTERNAL_ERROR  : exception;";
   L_533 : aliased constant String := "   UNEXPECTED_LAST_MATCH : exception;";
   L_534 : aliased constant String := "   PUSHBACK_OVERFLOW     : exception;";
   L_535 : aliased constant String := "   AFLEX_SCANNER_JAMMED  : exception;";
   L_536 : aliased constant String := "   type eob_action_type is (EOB_ACT_RESTA"
       & "RT_SCAN,";
   L_537 : aliased constant String := "                            EOB_ACT_END_O"
       & "F_FILE,";
   L_538 : aliased constant String := "                            EOB_ACT_LAST_"
       & "MATCH);";
   L_539 : aliased constant String := "   YY_END_OF_BUFFER_CHAR : constant Chara"
       & "cter := ASCII.NUL;";
   L_540 : aliased constant String := "   yy_n_chars            : Integer;      "
       & " --  number of characters read into yy_ch_buf";
   L_541 : aliased constant String := "";
   L_542 : aliased constant String := "   --  true when we've seen an EOF for th"
       & "e current input file";
   L_543 : aliased constant String := "   yy_eof_has_been_seen  : Boolean;";
   L_544 : aliased constant String := "";
   L_545 : aliased constant String := "%if error";
   L_546 : aliased constant String := "   --   In order to support YY_Get_Token_"
       & "Line, we need";
   L_547 : aliased constant String := "   --   a variable to hold current line.";
   L_548 : aliased constant String := "   type String_Ptr is access String;";
   L_549 : aliased constant String := "   Saved_Tok_Line1 : String_Ptr := Null;";
   L_550 : aliased constant String := "   Line_Number_Of_Saved_Tok_Line1 : Integ"
       & "er := 0;";
   L_551 : aliased constant String := "   Saved_Tok_Line2 : String_Ptr := Null;";
   L_552 : aliased constant String := "   Line_Number_Of_Saved_Tok_Line2 : Integ"
       & "er := 0;";
   L_553 : aliased constant String := "   -- Aflex will try to get next buffer b"
       & "efore it processs the";
   L_554 : aliased constant String := "   -- last token. Since now Aflex has bee"
       & "n changed to accept";
   L_555 : aliased constant String := "   -- one line by one line, the last toke"
       & "n in the buffer is";
   L_556 : aliased constant String := "   -- always end_of_line ( or end_of_buff"
       & "er ). So before the";
   L_557 : aliased constant String := "   -- end_of_line is processed, next line"
       & " will be retrieved";
   L_558 : aliased constant String := "   -- into the buffer. So we need to main"
       & "tain two lines,";
   L_559 : aliased constant String := "   -- which line will be returned in Get_"
       & "Token_Line is";
   L_560 : aliased constant String := "   -- determined according to the line nu"
       & "mber. It is the same";
   L_561 : aliased constant String := "   -- reason that we can not reinitialize"
       & " tok_end_col to 0 in";
   L_562 : aliased constant String := "   -- Yy_Input, but we must do it in yyle"
       & "x after we process the";
   L_563 : aliased constant String := "   -- end_of_line.";
   L_564 : aliased constant String := "   Tok_Begin_Line : Integer := 1;";
   L_565 : aliased constant String := "   Tok_End_Line   : Integer := 1;";
   L_566 : aliased constant String := "   Tok_End_Col    : Integer := 0;";
   L_567 : aliased constant String := "   Tok_Begin_Col  : Integer := 0;";
   L_568 : aliased constant String := "   Token_At_End_Of_Line : Boolean := Fals"
       & "e;";
   L_569 : aliased constant String := "   -- Indicates whether or not last match"
       & "ed token is end_of_line.";
   L_570 : aliased constant String := "%end";
   L_571 : aliased constant String := "";
   L_572 : aliased constant String := "   procedure YY_INPUT (buf      : out unb"
       & "ounded_character_array;";
   L_573 : aliased constant String := "                       result   : out Int"
       & "eger;";
   L_574 : aliased constant String := "                       max_size : in Inte"
       & "ger);";
   L_575 : aliased constant String := "   function yy_get_next_buffer return eob"
       & "_action_type;";
   L_576 : aliased constant String := "%if unput";
   L_577 : aliased constant String := "   procedure yyUnput (c : Character; yy_b"
       & "p : in out Integer);";
   L_578 : aliased constant String := "   procedure Unput (c : Character);";
   L_579 : aliased constant String := "%end";
   L_580 : aliased constant String := "   function Input return Character;";
   L_581 : aliased constant String := "%if output";
   L_582 : aliased constant String := "   procedure Output (c : Character);";
   L_583 : aliased constant String := "   procedure Output_New_Line;";
   L_584 : aliased constant String := "   function Output_Column return Text_IO."
       & "Count;";
   L_585 : aliased constant String := "%end";
   L_586 : aliased constant String := "   function yyWrap return Boolean;";
   L_587 : aliased constant String := "   procedure Open_Input (fname : in Strin"
       & "g);";
   L_588 : aliased constant String := "   procedure Close_Input;";
   L_589 : aliased constant String := "%if output";
   L_590 : aliased constant String := "   procedure Create_Output (fname : in St"
       & "ring := """");";
   L_591 : aliased constant String := "   procedure Close_Output;";
   L_592 : aliased constant String := "%end";
   L_593 : aliased constant String := "";
   L_594 : aliased constant String := "%if error";
   L_595 : aliased constant String := "   procedure Yy_Get_Token_Line ( Yy_Line_"
       & "String : out String;";
   L_596 : aliased constant String := "                                 Yy_Line_"
       & "Length : out Natural );";
   L_597 : aliased constant String := "   --  Returnes the entire line in the in"
       & "put, on which the currently";
   L_598 : aliased constant String := "   --  matched token resides.";
   L_599 : aliased constant String := "";
   L_600 : aliased constant String := "   function Yy_Line_Number return Natural"
       & ";";
   L_601 : aliased constant String := "   --  Returns the line number of the cur"
       & "rently matched token.";
   L_602 : aliased constant String := "   --  In case a token spans lines, then "
       & "the line number of the first line";
   L_603 : aliased constant String := "   --  is returned.";
   L_604 : aliased constant String := "";
   L_605 : aliased constant String := "   function Yy_Begin_Column return Natura"
       & "l;";
   L_606 : aliased constant String := "   function Yy_End_Column return Natural;";
   L_607 : aliased constant String := "   --  Returns the beginning and ending c"
       & "olumn positions of the";
   L_608 : aliased constant String := "   --  currently mathched token. If the t"
       & "oken spans lines then the";
   L_609 : aliased constant String := "   --  begin column number is the column "
       & "number on the first line";
   L_610 : aliased constant String := "   --  and the end columne number is the "
       & "column number on the last line.";
   L_611 : aliased constant String := "";
   L_612 : aliased constant String := "%end";
   L_613 : aliased constant String := "";
   L_614 : aliased constant String := "end ${NAME}_IO;";
   spec_io : aliased constant Content_Array :=
     (L_517'Access,
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
      L_614'Access);

end Template_Manager.Templates;
