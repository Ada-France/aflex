package ascan_dfa is
aflex_debug : boolean := false;
yytext_ptr : integer; -- points to start of yytext in buffer

-- yy_ch_buf has to be 2 characters longer than YY_BUF_SIZE because we need
-- to put in 2 end-of-buffer characters (this is explained where it is
-- done) at the end of yy_ch_buf
YY_READ_BUF_SIZE : constant integer :=  8192;
YY_BUF_SIZE : constant integer := YY_READ_BUF_SIZE * 2; -- size of input buffer
type unbounded_character_array is array(integer range <>) of character;
subtype ch_buf_type is unbounded_character_array(0..YY_BUF_SIZE + 1);
yy_ch_buf : ch_buf_type;
yy_cp, yy_bp : integer;

-- yy_hold_char holds the character lost when yytext is formed
yy_hold_char : character;
yy_c_buf_p : integer;   -- points to current character in buffer

function YYText return string;
function YYLength return integer;
procedure YY_DO_BEFORE_ACTION;
--These variables are needed between calls to YYLex.
yy_init : boolean := true; -- do we need to initialize YYLex?
yy_start : integer := 0; -- current start state number
subtype yy_state_type is integer;
yy_last_accepting_state : yy_state_type;
yy_last_accepting_cpos : integer;
end ascan_dfa;

with ascan_dfa; use ascan_dfa; 
package body ascan_dfa is
function YYText return string is
    i : integer;
    str_loc : integer := 1;
    buffer : string(1..1024);
    EMPTY_STRING : constant string := "";
begin
    -- find end of buffer
    i := yytext_ptr;
    while ( yy_ch_buf(i) /= ASCII.NUL ) loop
    buffer(str_loc ) := yy_ch_buf(i);
        i := i + 1;
    str_loc := str_loc + 1;
    end loop;
--    return yy_ch_buf(yytext_ptr.. i - 1);

    if (str_loc < 2) then
        return EMPTY_STRING;
    else
      return buffer(1..str_loc-1);
    end if;

end;

-- returns the length of the matched text
function YYLength return integer is
begin
    return yy_cp - yy_bp;
end YYLength;

-- done after the current pattern has been matched and before the
-- corresponding action - sets up yytext

procedure YY_DO_BEFORE_ACTION is
begin
    yytext_ptr := yy_bp;
    yy_hold_char := yy_ch_buf(yy_cp);
    yy_ch_buf(yy_cp) := ASCII.NUL;
    yy_c_buf_p := yy_cp;
end YY_DO_BEFORE_ACTION;

end ascan_dfa;
