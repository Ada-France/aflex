--  Warning: This file is automatically generated by AFLEX.
--           It is useless to modify it. Change the ".Y" & ".L" files instead.
--  Template: templates/spec-dfa.ads
package ascan_DFA is

   aflex_debug       : Boolean := False;
   yylineno          : Natural := 0;
   yylinecol         : Natural := 0;
   yy_last_yylineno  : Natural := 0;
   yy_last_yylinecol : Natural := 0;
   yytext_ptr        : Integer; --  points to start of yytext in buffer

   --  yy_ch_buf has to be 2 characters longer than YY_BUF_SIZE because we need
   --  to put in 2 end-of-buffer characters (this is explained where it is
   --  done) at the end of yy_ch_buf

   --  ----------------------------------------------------------------------------
   --  Buffer size is configured with:
   --  %option bufsize=75000

   YY_READ_BUF_SIZE : constant Integer := 75000;
   --  ----------------------------------------------------------------------------

   YY_BUF_SIZE : constant Integer := YY_READ_BUF_SIZE * 2; --  size of input buffer

   type unbounded_character_array is array (Integer range <>) of Character;
   subtype ch_buf_type is unbounded_character_array (0 .. YY_BUF_SIZE + 1);

   yy_ch_buf    : ch_buf_type;
   yy_cp, yy_bp : Integer;

   --  yy_hold_char holds the character lost when yytext is formed
   yy_hold_char : Character;
   yy_c_buf_p   : Integer;   --  points to current character in buffer

   function YYText return String;
   function YYLength return Integer;
   procedure YY_DO_BEFORE_ACTION;

   subtype yy_state_type is Integer;

   --  These variables are needed between calls to YYLex.
   yy_init                 : Boolean := True; --  do we need to initialize YYLex?
   yy_start                : Integer := 0; --  current start state number
   yy_last_accepting_state : yy_state_type;
   yy_last_accepting_cpos  : Integer;

end ascan_DFA;
