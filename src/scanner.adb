
pragma Warnings (Off);
with Ada.Text_Io;
with misc_defs, misc, sym, parse_tokens, int_io;
with tstring, ascan_dfa, ascan_io;
use misc_defs, parse_tokens, tstring;
use ascan_dfa, ascan_io;
package body scanner is

   use Ada;
   use Ada.Text_IO;

   beglin : Boolean := False;
   i, bracelevel: Integer;

   function get_token return Token is
      toktype : Token;
      didadef, indented_code : Boolean;
      cclval : Integer;
      nmdefptr : vstring;
      nmdef, tmpbuf : vstring;

      procedure ACTION_ECHO is
      begin
         Ada.Text_IO.Put (temp_action_file, yytext(1 .. YYLength));
      end ACTION_ECHO;

      procedure MARK_END_OF_PROLOG is
      begin
         Ada.Text_IO.Put (temp_action_file, "%%%% end of prolog");
         Ada.Text_IO.New_Line (temp_action_file);
      end MARK_END_OF_PROLOG;

      procedure PUT_BACK_STRING(str : vstring; start : Integer) is
      begin
         for i in reverse start + 1 .. tstring.len (str) loop
            unput (CHAR (str, i));
         end loop;
      end PUT_BACK_STRING;

      function check_yylex_here return Boolean is
      begin
         return ( (yytext'length >= 2) and then
                ((yytext(1) = '#') and (yytext(2) = '#')));
      end check_yylex_here;

   function YYLex return Token is
      subtype Short is Integer range -32768..32767;
      yy_act : Integer;
      yy_c   : Short;

      -- returned upon end-of-file
      YY_END_TOK : constant Integer := 0;
YY_END_OF_BUFFER : constant := 
84;
subtype yy_state_type is Integer;
yy_current_state : yy_state_type;
INITIAL : constant := 0;
SECT2 : constant := 1;
SECT2PROLOG : constant := 2;
SECT3 : constant := 3;
PICKUPDEF : constant := 4;
SC : constant := 5;
CARETISBOL : constant := 6;
NUM : constant := 7;
QUOTE : constant := 8;
FIRSTCCL : constant := 9;
CCL : constant := 10;
ACTION : constant := 11;
RECOVER : constant := 12;
BRACEERROR : constant := 13;
ACTION_STRING : constant := 14;
yy_accept : constant array(0..213) of Short :=
    (   0,
        0,    0,    0,    0,    0,    0,   82,   82,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
       84,   15,    7,   14,   12,    1,   13,   15,   15,   15,
       10,   41,   33,   34,   27,   41,   40,   25,   41,   41,
       41,   33,   23,   41,   41,   26,   83,   21,   82,   82,
       17,   16,   18,   47,   83,   43,   44,   46,   48,   62,
       63,   60,   59,   61,   49,   51,   50,   49,   55,   54,
       55,   55,   57,   57,   57,   58,   68,   73,   72,   74,
       68,   74,   69,   66,   67,   83,   19,   65,   64,   75,

       77,   78,   79,    7,   14,   12,    0,    1,   13,    0,
        0,    2,    0,    8,    4,    6,    5,    0,   10,   33,
       34,    0,   30,    0,    0,    0,   80,   80,   29,   28,
       29,    0,   33,   23,    0,    0,   37,    0,    0,   21,
       20,   82,   82,   17,   16,   45,   46,   59,   81,   81,
       52,   53,   56,   68,    0,   71,    0,   68,   69,    0,
       19,   75,   76,   11,    0,    8,    0,    0,    0,    3,
        0,   31,    0,   38,    0,   80,   29,   29,   39,    0,
        0,    0,   37,    0,   32,   81,   68,   70,    0,   11,
        0,    9,    0,    0,    0,    0,    0,    0,    0,    0,

        6,    0,    0,    0,   24,    0,   24,    0,   24,    4,
        0,   36,    0
    ) ;

yy_ec : constant array(ASCII.NUL..Character'Last) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    4,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    5,    1,    6,    7,    8,    9,    1,   10,   11,
       11,   11,   11,   12,   13,   14,   15,   16,   16,   16,
       16,   16,   16,   16,   16,   16,   16,    1,    1,   17,
        1,   18,   11,    1,   24,   23,   23,   23,   25,   26,
       23,   23,   27,   23,   23,   23,   23,   28,   29,   23,
       23,   30,   31,   32,   33,   23,   23,   34,   23,   23,
       19,   20,   21,   22,   23,    1,   24,   23,   23,   23,

       25,   26,   23,   23,   27,   23,   23,   23,   23,   28,
       29,   23,   23,   30,   31,   32,   33,   23,   23,   34,
       23,   23,   35,   36,   37,    1,    1, others=> 1

    ) ;

yy_meta : constant array(0..37) of short :=
    (   0,
        1,    2,    3,    2,    2,    4,    1,    1,    1,    5,
        1,    1,    6,    7,    5,    6,    1,    1,    1,    8,
        9,    1,   10,   10,   10,   10,   10,   10,   10,   10,
       10,   10,   10,   10,    5,    1,   11
    ) ;

yy_base : constant array(0..259) of Short :=
    (   0,
        0,   37,   73,  108,  400,  399,  398,  397,   92,   96,
      144,    0,  377,  376,  179,  180,   83,  112,  181,  184,
      121,  187,  217,    0,  394,  393,   99,  101,  182,  252,
      395,  911,  207,  911,  380,  257,  911,  390,  247,  379,
      377,  911,  261,  911,  911,   80,  911,  373,  369,  371,
      282,  315,  911,  377,  372,  911,  381,    0,  380,  911,
        0,  135,  911,  911,  911,  911,  360,    0,  911,  911,
      911,  911,  365,  911,  911,  911,  911,  359,  911,  911,
      358,  348,  911,    0,  344,  911,    0,  911,  911,  179,
      346,  911,    0,  911,  911,  355,  911,  911,  911,    0,

      911,  911,    0,  271,  911,  343,    0,  280,  911,  343,
      351,  911,  348,    0,  318,  321,  911,  345,  333,  285,
      911,  343,  911,  320,   85,  110,  911,  328,    0,  911,
      339,  330,  375,  911,  329,  202,    0,  338,  337,    0,
      911,  336,  911,    0,  290,  911,    0,  322,  911,  321,
      911,  911,  911,    0,  247,  911,    0,  411,    0,  333,
      911,    0,  911,  321,  331,    0,  309,  304,  327,  911,
      326,  911,  298,  911,  280,  310,    0,    0,  911,  312,
      266,  319,    0,  321,  911,  307,    0,  911,  299,  277,
      283,  911,  247,  239,  242,  283,  195,  190,  183,  103,

      911,  115,  193,  126,  911,  117,  911,  104,  911,  911,
       73,  911,  911,  448,  459,  470,  481,  492,  503,  514,
      525,  536,  547,  558,  564,  574,  585,  591,  601,  612,
      623,  634,  645,  656,  667,  678,  684,  694,  705,  716,
      727,  736,  742,  752,  763,  774,   70,  785,  796,  807,
      818,  828,  839,  845,  855,  866,  877,  888,  899
    ) ;

yy_def : constant array(0..259) of Short :=
    (   0,
      213,  213,  214,  214,  215,  215,  216,  216,  217,  217,
      213,   11,  218,  218,  219,  219,  220,  220,  221,  221,
      222,  222,  213,   23,  223,  223,  218,  218,  224,  224,
      213,  213,  213,  213,  225,  213,  213,  226,  227,  213,
      228,  213,  213,  213,  213,  213,  213,  213,  229,  230,
      231,  232,  213,  213,  213,  213,  233,  234,  235,  213,
      236,  213,  213,  213,  213,  213,  213,  237,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  230,  213,  213,
      238,  239,  213,  240,  230,  213,  241,  213,  213,  242,
      241,  213,  243,  213,  213,  244,  213,  213,  213,  245,

      213,  213,  246,  213,  213,  225,  247,  213,  213,  213,
      226,  213,  213,  248,  213,  213,  213,  249,  228,  213,
      213,  250,  213,  213,  229,  229,  213,  213,  251,  213,
      251,  213,  232,  213,  213,  250,  252,  253,  233,  234,
      213,  235,  213,  236,  213,  213,  237,  213,  213,  213,
      213,  213,  213,  241,  242,  213,  242,  213,  243,  244,
      213,  245,  213,  254,  255,  248,  213,  213,  249,  213,
      250,  213,  213,  213,  229,  213,  251,  131,  213,  213,
      253,  250,  252,  253,  213,  213,  158,  213,  256,  254,
      255,  213,  213,  213,  213,  229,  257,  258,  259,  213,

      213,  213,  229,  257,  213,  258,  213,  259,  213,  213,
      213,  213,    0,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213
    ) ;

yy_nxt : constant array(0..948) of Short :=
    (   0,
       32,   33,   34,   33,   33,   32,   32,   32,   32,   32,
       32,   32,   32,   32,   32,   32,   32,   32,   32,   32,
       32,   32,   35,   35,   35,   35,   35,   35,   35,   35,
       35,   35,   35,   35,   32,   32,   32,   32,   36,   37,
       36,   36,   32,   38,   32,   39,   32,   32,   32,   40,
       32,   32,   32,   32,   32,   32,   32,   32,   32,   41,
       41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
       41,   32,   32,   32,   43,   44,   43,   43,   45,  164,
       46,  123,  123,   47,  123,   76,   47,   47,   77,   48,
      212,   49,   50,   62,   63,   62,   62,   62,   63,   62,

       62,   98,   78,   98,  126,  174,  209,   51,   47,   52,
       53,   52,   52,   45,   76,   46,   54,   77,   47,  207,
       55,   47,   47,   65,   48,  175,   49,   50,  205,   56,
      125,   78,  211,   84,  210,   99,  145,   99,  145,  145,
       85,   86,   51,   47,   64,   64,   65,   64,   64,   64,
       64,   64,   64,   64,   64,   66,   64,   64,   64,   64,
       64,   67,   64,   64,   64,   64,   68,   68,   68,   68,
       68,   68,   68,   68,   68,   68,   68,   68,   64,   64,
       64,   71,   71,   65,  101,  209,   65,  102,  156,   65,
       72,   72,  207,   80,   73,   73,   80,  205,  157,   84,

       81,  103,   82,   81,  172,   82,   85,   86,  104,  105,
      104,  104,  126,  174,  182,   74,   74,   87,   87,   88,
       87,   87,   89,   87,   87,   87,   90,   87,   87,   91,
       87,   92,   87,   87,   87,   87,   87,   87,   87,   93,
       93,   93,   93,   93,   93,   93,   93,   93,   93,   93,
       93,   94,   87,   95,  101,  114,  156,  102,  108,  109,
      108,  108,  120,  121,  120,  120,  157,  202,  185,  110,
      201,  103,  104,  105,  104,  104,  200,  115,  198,  116,
      117,  108,  109,  108,  108,  192,  120,  121,  120,  120,
      107,  145,  110,  145,  145,  196,  122,  130,  203,  126,

      174,  188,  126,  174,  131,  131,  131,  131,  131,  131,
      131,  131,  131,  131,  131,  131,  133,  134,  133,  133,
      122,  172,  149,  185,  197,  127,  195,  135,  172,  170,
      194,  199,  193,  192,  107,  161,  186,  148,  143,  140,
      185,  181,  180,  176,  173,  172,  107,  170,  168,  167,
      136,  178,  165,  112,  178,  118,  107,  161,  158,  128,
      152,  178,  178,  178,  178,  178,  178,  178,  178,  178,
      178,  178,  178,  150,  128,  179,  133,  134,  133,  133,
      148,  146,  143,  140,  138,  137,  128,  135,  126,  124,
      107,  118,  112,  107,  213,   97,   97,   69,   69,   60,

       60,   58,   58,  213,  213,  213,  213,  213,  213,  213,
      136,  187,  187,  188,  187,  187,  189,  187,  187,  187,
      189,  187,  187,  187,  187,  189,  187,  187,  187,  187,
      187,  187,  187,  189,  189,  189,  189,  189,  189,  189,
      189,  189,  189,  189,  189,  189,  187,  189,   42,   42,
       42,   42,   42,   42,   42,   42,   42,   42,   42,   57,
       57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
       59,   59,   59,   59,   59,   59,   59,   59,   59,   59,
       59,   61,   61,   61,   61,   61,   61,   61,   61,   61,
       61,   61,   65,   65,   65,   65,   65,   65,   65,   65,

       65,   65,   65,   70,   70,   70,   70,   70,   70,   70,
       70,   70,   70,   70,   75,   75,   75,   75,   75,   75,
       75,   75,   75,   75,   75,   79,   79,   79,   79,   79,
       79,   79,   79,   79,   79,   79,   83,   83,   83,   83,
       83,   83,   83,   83,   83,   83,   83,   96,   96,   96,
       96,   96,   96,   96,   96,   96,   96,   96,  100,  100,
      100,  100,  100,  100,  100,  100,  100,  100,  100,  106,
      106,  213,  213,  106,  111,  111,  111,  111,  111,  111,
      111,  111,  111,  111,  111,  113,  113,  113,  113,  113,
      113,  113,  113,  113,  113,  113,  119,  119,  213,  213,

      119,  125,  125,  213,  125,  125,  125,  125,  125,  213,
      125,  125,  127,  127,  213,  127,  127,  127,  127,  127,
      127,  127,  127,  129,  129,  213,  129,  129,  129,  129,
      129,  129,  129,  129,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  139,  139,  139,  139,  139,
      139,  139,  139,  139,  139,  139,  141,  213,  213,  141,
      141,  141,  141,  141,  141,  141,  141,  142,  142,  142,
      142,  142,  142,  142,  142,  142,  142,  142,  144,  144,
      213,  144,  144,  144,  144,  144,  144,  144,  144,  147,
      213,  213,  213,  147,  149,  149,  213,  149,  149,  149,

      149,  149,  149,  149,  149,  151,  151,  213,  151,  151,
      151,  151,  151,  151,  151,  151,  153,  153,  213,  153,
      153,  153,  153,  153,  213,  153,  153,  154,  154,  213,
      213,  213,  154,  154,  154,  154,  155,  155,  213,  155,
      155,  155,  155,  155,  155,  155,  155,  159,  213,  213,
      213,  159,  160,  160,  160,  160,  160,  160,  160,  160,
      160,  160,  160,  162,  162,  213,  213,  162,  162,  162,
      213,  162,  162,  162,  163,  163,  213,  163,  163,  163,
      163,  163,  163,  163,  163,  166,  166,  213,  166,  166,
      166,  166,  166,  166,  166,  166,  169,  169,  169,  169,

      169,  169,  169,  169,  169,  169,  169,  171,  171,  171,
      171,  171,  171,  171,  171,  171,  171,  171,  177,  177,
      213,  177,  177,  177,  177,  177,  177,  177,  183,  183,
      213,  183,  183,  183,  183,  183,  183,  183,  183,  184,
      184,  184,  184,  184,  184,  184,  184,  184,  184,  184,
      190,  190,  213,  213,  190,  191,  191,  191,  191,  191,
      191,  191,  191,  191,  191,  191,  189,  189,  189,  189,
      189,  189,  189,  189,  189,  189,  189,  204,  204,  204,
      204,  204,  204,  204,  204,  204,  204,  204,  206,  206,
      206,  206,  206,  206,  206,  206,  206,  206,  206,  208,

      208,  208,  208,  208,  208,  208,  208,  208,  208,  208,
       31,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213
    ) ;

yy_chk : constant array(0..948) of Short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    3,    3,    3,    3,    3,  247,
        3,   46,   46,    3,   46,   17,    3,    3,   17,    3,
      211,    3,    3,    9,    9,    9,    9,   10,   10,   10,

       10,   27,   17,   28,  125,  125,  208,    3,    3,    4,
        4,    4,    4,    4,   18,    4,    4,   18,    4,  206,
        4,    4,    4,   21,    4,  126,    4,    4,  204,    4,
      126,   18,  202,   21,  200,   27,   62,   28,   62,   62,
       21,   21,    4,    4,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   15,   16,   19,   29,  199,   20,   29,   90,   22,
       15,   16,  198,   19,   15,   16,   20,  197,   90,   22,

       19,   29,   19,   20,  136,   20,   22,   22,   33,   33,
       33,   33,  203,  203,  136,   15,   16,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   30,   39,  155,   30,   36,   36,
       36,   36,   43,   43,   43,   43,  155,  195,  181,   36,
      194,   30,  104,  104,  104,  104,  193,   39,  181,   39,
       39,  108,  108,  108,  108,  191,  120,  120,  120,  120,
      190,  145,  108,  145,  145,  175,   43,   51,  196,  175,

      175,  189,  196,  196,   51,   51,   51,   51,   51,   51,
       51,   51,   51,   51,   51,   51,   52,   52,   52,   52,
      120,  182,  186,  184,  180,  176,  173,   52,  171,  169,
      168,  182,  167,  165,  164,  160,  150,  148,  142,  139,
      138,  135,  132,  128,  124,  122,  119,  118,  116,  115,
       52,  131,  113,  111,  131,  110,  106,   96,   91,   85,
       82,  131,  131,  131,  131,  131,  131,  131,  131,  131,
      131,  131,  131,   81,   78,  131,  133,  133,  133,  133,
       73,   67,   59,   57,   55,   54,   50,  133,   49,   48,
       41,   40,   38,   35,   31,   26,   25,   14,   13,    8,

        7,    6,    5,    0,    0,    0,    0,    0,    0,    0,
      133,  158,  158,  158,  158,  158,  158,  158,  158,  158,
      158,  158,  158,  158,  158,  158,  158,  158,  158,  158,
      158,  158,  158,  158,  158,  158,  158,  158,  158,  158,
      158,  158,  158,  158,  158,  158,  158,  158,  214,  214,
      214,  214,  214,  214,  214,  214,  214,  214,  214,  215,
      215,  215,  215,  215,  215,  215,  215,  215,  215,  215,
      216,  216,  216,  216,  216,  216,  216,  216,  216,  216,
      216,  217,  217,  217,  217,  217,  217,  217,  217,  217,
      217,  217,  218,  218,  218,  218,  218,  218,  218,  218,

      218,  218,  218,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  220,  220,  220,  220,  220,  220,
      220,  220,  220,  220,  220,  221,  221,  221,  221,  221,
      221,  221,  221,  221,  221,  221,  222,  222,  222,  222,
      222,  222,  222,  222,  222,  222,  222,  223,  223,  223,
      223,  223,  223,  223,  223,  223,  223,  223,  224,  224,
      224,  224,  224,  224,  224,  224,  224,  224,  224,  225,
      225,    0,    0,  225,  226,  226,  226,  226,  226,  226,
      226,  226,  226,  226,  226,  227,  227,  227,  227,  227,
      227,  227,  227,  227,  227,  227,  228,  228,    0,    0,

      228,  229,  229,    0,  229,  229,  229,  229,  229,    0,
      229,  229,  230,  230,    0,  230,  230,  230,  230,  230,
      230,  230,  230,  231,  231,    0,  231,  231,  231,  231,
      231,  231,  231,  231,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  233,  233,  233,  233,  233,
      233,  233,  233,  233,  233,  233,  234,    0,    0,  234,
      234,  234,  234,  234,  234,  234,  234,  235,  235,  235,
      235,  235,  235,  235,  235,  235,  235,  235,  236,  236,
        0,  236,  236,  236,  236,  236,  236,  236,  236,  237,
        0,    0,    0,  237,  238,  238,    0,  238,  238,  238,

      238,  238,  238,  238,  238,  239,  239,    0,  239,  239,
      239,  239,  239,  239,  239,  239,  240,  240,    0,  240,
      240,  240,  240,  240,    0,  240,  240,  241,  241,    0,
        0,    0,  241,  241,  241,  241,  242,  242,    0,  242,
      242,  242,  242,  242,  242,  242,  242,  243,    0,    0,
        0,  243,  244,  244,  244,  244,  244,  244,  244,  244,
      244,  244,  244,  245,  245,    0,    0,  245,  245,  245,
        0,  245,  245,  245,  246,  246,    0,  246,  246,  246,
      246,  246,  246,  246,  246,  248,  248,    0,  248,  248,
      248,  248,  248,  248,  248,  248,  249,  249,  249,  249,

      249,  249,  249,  249,  249,  249,  249,  250,  250,  250,
      250,  250,  250,  250,  250,  250,  250,  250,  251,  251,
        0,  251,  251,  251,  251,  251,  251,  251,  252,  252,
        0,  252,  252,  252,  252,  252,  252,  252,  252,  253,
      253,  253,  253,  253,  253,  253,  253,  253,  253,  253,
      254,  254,    0,    0,  254,  255,  255,  255,  255,  255,
      255,  255,  255,  255,  255,  255,  256,  256,  256,  256,
      256,  256,  256,  256,  256,  256,  256,  257,  257,  257,
      257,  257,  257,  257,  257,  257,  257,  257,  258,  258,
      258,  258,  258,  258,  258,  258,  258,  258,  258,  259,

      259,  259,  259,  259,  259,  259,  259,  259,  259,  259,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213,  213,  213,
      213,  213,  213,  213,  213,  213,  213,  213
    ) ;


      -- copy whatever the last rule matched to the standard output

      procedure ECHO is
      begin
         if Text_IO.is_open(user_output_file) then
            Text_IO.put( user_output_file, yytext );
         else
            Text_IO.put( yytext );
         end if;
      end ECHO;

      -- enter a start condition.
      -- Using procedure requires a () after the ENTER, but makes everything
      -- much neater.

      procedure ENTER( state : integer ) is
      begin
         yy_start := 1 + 2 * state;
      end ENTER;

      -- action number for EOF rule of a given start state
      function YY_STATE_EOF(state : integer) return integer is
      begin
         return YY_END_OF_BUFFER + state + 1;
      end YY_STATE_EOF;

      -- return all but the first 'n' matched characters back to the input stream
      procedure yyless(n : integer) is
      begin
         yy_ch_buf(yy_cp) := yy_hold_char; -- undo effects of setting up yytext
         yy_cp := yy_bp + n;
         yy_c_buf_p := yy_cp;
         YY_DO_BEFORE_ACTION; -- set up yytext again
      end yyless;

      -- redefine this if you have something you want each time.
      procedure YY_USER_ACTION is
      begin
         null;
      end;

      -- yy_get_previous_state - get the state just before the EOB char was reached

      function yy_get_previous_state return yy_state_type is
         yy_current_state : yy_state_type;
         yy_c : short;
         yy_bp : constant Integer := yytext_ptr;
      begin
         yy_current_state := yy_start;
         if yy_ch_buf(yy_bp-1) = ASCII.LF then
            yy_current_state := yy_current_state + 1;
         end if;

         for yy_cp in yytext_ptr .. yy_c_buf_p - 1 loop
            yy_c := yy_ec(yy_ch_buf(yy_cp));
            if yy_accept(yy_current_state) /= 0 then
               yy_last_accepting_state := yy_current_state;
               yy_last_accepting_cpos := yy_cp;
            end if;
            while yy_chk(yy_base(yy_current_state) + yy_c) /= yy_current_state loop
               yy_current_state := yy_def(yy_current_state);
               if ( yy_current_state >= 214 ) then
                  yy_c := yy_meta(yy_c);
               end if;
            end loop;
            yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
         end loop;

         return yy_current_state;
      end yy_get_previous_state;

      procedure yyrestart( input_file : file_type ) is
      begin
         open_input(Text_IO.name(input_file));
      end yyrestart;

   begin -- of YYLex
      <<new_file>>
      -- this is where we enter upon encountering an end-of-file and
      -- yywrap() indicating that we should continue processing

      if yy_init then
         if yy_start = 0 then
            yy_start := 1;      -- first start state
         end if;

         -- we put in the '\n' and start reading from [1] so that an
         -- initial match-at-newline will be true.

         yy_ch_buf(0) := ASCII.LF;
         yy_n_chars := 1;

         -- we always need two end-of-buffer characters. The first causes
         -- a transition to the end-of-buffer state. The second causes
         -- a jam in that state.

         yy_ch_buf(yy_n_chars) := YY_END_OF_BUFFER_CHAR;
         yy_ch_buf(yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;

         yy_eof_has_been_seen := false;

         yytext_ptr := 1;
         yy_c_buf_p := yytext_ptr;
         yy_hold_char := yy_ch_buf(yy_c_buf_p);
         yy_init := false;
      end if; -- yy_init

      loop                -- loops until end-of-file is reached


         yy_cp := yy_c_buf_p;

         -- support of yytext
         yy_ch_buf(yy_cp) := yy_hold_char;

         -- yy_bp points to the position in yy_ch_buf of the start of the
         -- current run.
         yy_bp := yy_cp;
         yy_current_state := yy_start;
         if yy_ch_buf(yy_bp-1) = ASCII.LF then
            yy_current_state := yy_current_state + 1;
         end if;
         loop
               yy_c := yy_ec(yy_ch_buf(yy_cp));
               if yy_accept(yy_current_state) /= 0 then
                  yy_last_accepting_state := yy_current_state;
                  yy_last_accepting_cpos := yy_cp;
               end if;
               while yy_chk(yy_base(yy_current_state) + yy_c) /= yy_current_state loop
                  yy_current_state := yy_def(yy_current_state);
                  if ( yy_current_state >= 214 ) then
                     yy_c := yy_meta(yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
if ( yy_current_state = 213 ) then
    exit;
end if;
         end loop;
         yy_cp := yy_last_accepting_cpos;
         yy_current_state := yy_last_accepting_state;

   <<next_action>>
         yy_act := yy_accept(yy_current_state);
         YY_DO_BEFORE_ACTION;
         YY_USER_ACTION;

         if aflex_debug then  -- output acceptance info. for (-d) debug mode
            Text_IO.Put (Standard_Error, "--accepting rule #");
            Text_IO.Put (Standard_Error, INTEGER'IMAGE(yy_act));
            Text_IO.Put_Line (Standard_Error, "(""" & yytext & """)");
         end if;


   <<do_action>>   -- this label is used only to access EOF actions
         case yy_act is
            when 0 => -- must backtrack
            -- undo the effects of YY_DO_BEFORE_ACTION
            yy_ch_buf(yy_cp) := yy_hold_char;
            yy_cp := yy_last_accepting_cpos;
            yy_current_state := yy_last_accepting_state;
            goto next_action;



         when 1 => 
--# line 55 "ascan.l"
             indented_code := True; 

         when 2 => 
--# line 56 "ascan.l"
             linenum := linenum + 1; ECHO;
                -- treat as a comment;
            

         when 3 => 
--# line 59 "ascan.l"
             linenum := linenum + 1; ECHO; 

         when 4 => 
--# line 60 "ascan.l"
             return SCDECL; 

         when 5 => 
--# line 61 "ascan.l"
             return XSCDECL; 

         when 6 => 
--# line 62 "ascan.l"
             return USCDECL; 

         when 7 => 
--# line 64 "ascan.l"
             return WHITESPACE; 

         when 8 => 
--# line 66 "ascan.l"
            
            sectnum := 2;
            misc.line_directive_out;
            ENTER(SECT2PROLOG);
            return SECTEND;
            

         when 9 => 
--# line 73 "ascan.l"
            
            Ada.Text_IO.Put( Standard_Error, "old-style lex command at line " );
            int_io.put( Standard_Error, linenum );
            Ada.Text_IO.Put( Standard_Error, " ignored:" );
            text_io.new_line( Standard_Error );
            Ada.Text_IO.Put( Standard_Error, ASCII.HT );
            Ada.Text_IO.Put( Standard_Error, yytext(1..YYLength) );
            linenum := linenum + 1;
            

         when 10 => 
--# line 83 "ascan.l"
            
            nmstr := vstr(yytext(1..YYLength));
            didadef := False;
            ENTER(PICKUPDEF);
            

         when 11 => 
--# line 89 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return UNAME;
            

         when 12 => 
--# line 93 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 13 => 
--# line 96 "ascan.l"
             linenum := linenum + 1;
              -- allows blank lines in section 1;
            

         when 14 => 
--# line 99 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 15 => 
--# line 100 "ascan.l"
             misc.synerr( "illegal character" );ENTER(RECOVER);

         when 16 => 
--# line 102 "ascan.l"
             null;
              -- separates name and definition;
            

         when 17 => 
--# line 106 "ascan.l"
            
            nmdef := vstr(yytext(1..YYLength));

            i := tstring.len( nmdef );
            while ( i >= tstring.first ) loop
                if ( (CHAR(nmdef,i) /= ' ') and
                 (CHAR(nmdef,i) /= ASCII.HT) ) then
                exit;
                end if;
                i := i - 1;
            end loop;

                        sym.ndinstal( nmstr,
                tstring.slice(nmdef, tstring.first, i) );
            didadef := True;
            

         when 18 => 
--# line 123 "ascan.l"
            
            if not didadef then
                misc.synerr( "incomplete name definition" );
            end if;
            ENTER(0);
            linenum := linenum + 1;
            

         when 19 => 
--# line 131 "ascan.l"
             linenum := linenum + 1;
              ENTER(0);
              nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 20 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_cp - 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 137 "ascan.l"
            
            linenum := linenum + 1;
            ACTION_ECHO;
            MARK_END_OF_PROLOG;
            ENTER(SECT2);
            

         when 21 => 
--# line 144 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

   when YY_END_OF_BUFFER +SECT2PROLOG + 1 
 =>
--# line 146 "ascan.l"
 MARK_END_OF_PROLOG;
              return End_Of_Input;
            

         when 23 => 
--# line 150 "ascan.l"
             linenum := linenum + 1;
              -- allow blank lines in sect2;

            -- this rule matches indented lines which
            -- are not comments.
         when 24 => 
--# line 155 "ascan.l"
            
            misc.synerr("indented code found outside of action");
            linenum := linenum + 1;
            

         when 25 => 
--# line 160 "ascan.l"
             ENTER(SC); return ( '<' ); 

         when 26 => 
--# line 161 "ascan.l"
             return ( '^' );  

         when 27 => 
--# line 162 "ascan.l"
             ENTER(QUOTE); return ( '"' ); 

         when 28 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 163 "ascan.l"
             ENTER(NUM); return ( '{' ); 

         when 29 => 
--# line 164 "ascan.l"
             ENTER(BRACEERROR); 

         when 30 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 165 "ascan.l"
             return '$'; 

         when 31 => 
--# line 167 "ascan.l"
             continued_action := True;
              linenum := linenum + 1;
              return Newline;
            

         when 32 => 
--# line 172 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 33 => 
--# line 174 "ascan.l"
            
            -- this rule is separate from the one below because
            -- otherwise we get variable trailing context, so
            -- we can't build the scanner using -f,F

            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            

         when 34 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_cp - 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 185 "ascan.l"
            
            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            

         when 35 => 
--# line 192 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 36 => 
--# line 194 "ascan.l"
             return EOF_OP; 

         when 37 => 
--# line 196 "ascan.l"
            
            sectnum := 3;
            ENTER(SECT3);
            return End_Of_Input;
            -- to stop the parser
            

         when 38 => 
--# line 203 "ascan.l"
            

            nmstr := vstr(yytext(1..YYLength));

            -- check to see if we've already encountered this ccl
                        cclval := sym.ccllookup( nmstr );
            if ( cclval /= 0 ) then
                YYLVal := cclval;
                cclreuse := cclreuse + 1;
                return PREVCCL;
            else
                -- we fudge a bit.  We know that this ccl will
                -- soon be numbered as lastccl + 1 by cclinit
                sym.cclinstal( nmstr, lastccl + 1 );

                -- push back everything but the leading bracket
                -- so the ccl can be rescanned

                PUT_BACK_STRING(nmstr, 1);

                ENTER(FIRSTCCL);
                return '[';
            end if;
            

         when 39 => 
--# line 228 "ascan.l"
            
            nmstr := vstr(yytext(1..YYLength));
            -- chop leading and trailing brace
            tmpbuf := slice(vstr(yytext(1..YYLength)),
                                2, YYLength-1);

            nmdefptr := sym.ndlookup( tmpbuf );
            if ( nmdefptr = NUL ) then
                misc.synerr( "undefined {name}" );
            else
                -- push back name surrounded by ()'s
                unput(')');
                PUT_BACK_STRING(nmdefptr, 0);
                unput('(');
            end if;
            

         when 40 => 
--# line 245 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              case tstring.CHAR(tmpbuf,1) is
                when '/' => return '/';
                when '|' => return '|';
                when '*' => return '*';
                when '+' => return '+';
                when '?' => return '?';
                when '.' => return '.';
                when '(' => return '(';
                when ')' => return ')';
                when others =>
                    misc.aflexerror("error in aflex case");
              end case;
            

         when 41 => 
--# line 259 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 42 => 
--# line 263 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 43 => 
--# line 266 "ascan.l"
             return ( ',' ); 

         when 44 => 
--# line 267 "ascan.l"
             ENTER(SECT2); return ( '>' ); 

         when 45 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 268 "ascan.l"
             ENTER(CARETISBOL); return ( '>' ); 

         when 46 => 
--# line 269 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 47 => 
--# line 272 "ascan.l"
             misc.synerr( "bad start condition name" ); 

         when 48 => 
--# line 274 "ascan.l"
             ENTER(SECT2); return '^'; 

         when 49 => 
--# line 277 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 50 => 
--# line 281 "ascan.l"
             ENTER(SECT2); return '"'; 

         when 51 => 
--# line 283 "ascan.l"
            
            misc.synerr( "missing quote" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '"';
            

         when 52 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 291 "ascan.l"
             ENTER(CCL); return '^'; 

         when 53 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 292 "ascan.l"
             return '^'; 

         when 54 => 
--# line 293 "ascan.l"
             ENTER(CCL); YYLVal := CHARACTER'POS('-'); return ( CHAR ); 

         when 55 => 
--# line 294 "ascan.l"
             ENTER(CCL);
              tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 56 => 
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 300 "ascan.l"
             return '-'; 

         when 57 => 
--# line 301 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 58 => 
--# line 305 "ascan.l"
             ENTER(SECT2); return ']'; 

         when 59 => 
--# line 308 "ascan.l"
            
            YYLVal := misc.myctoi( vstr(yytext(1..YYLength)) );
            return NUMBER;
            

         when 60 => 
--# line 313 "ascan.l"
             return ','; 

         when 61 => 
--# line 314 "ascan.l"
             ENTER(SECT2); return '}'; 

         when 62 => 
--# line 316 "ascan.l"
            
            misc.synerr( "bad character inside {}'s" );
            ENTER(SECT2);
            return '}';
            

         when 63 => 
--# line 322 "ascan.l"
            
            misc.synerr( "missing }" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '}';
            

         when 64 => 
--# line 330 "ascan.l"
             misc.synerr( "bad name in {}'s" ); ENTER(SECT2); 

         when 65 => 
--# line 331 "ascan.l"
             misc.synerr( "missing }" );
              linenum := linenum + 1;
              ENTER(SECT2);
            

         when 66 => 
--# line 336 "ascan.l"
             bracelevel := bracelevel + 1; 

         when 67 => 
--# line 337 "ascan.l"
             bracelevel := bracelevel - 1; 

         when 68 => 
--# line 338 "ascan.l"
             ACTION_ECHO; 

         when 69 => 
--# line 339 "ascan.l"
             ACTION_ECHO; 

         when 70 => 
--# line 340 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 71 => 
--# line 341 "ascan.l"
             ACTION_ECHO;
                  -- character constant;
            

         when 72 => 
--# line 345 "ascan.l"
             ACTION_ECHO; ENTER(ACTION_STRING); 

         when 73 => 
--# line 347 "ascan.l"
            
            linenum := linenum + 1;
            ACTION_ECHO;
            if bracelevel = 0 then
                text_io.new_line ( temp_action_file );
                ENTER(SECT2);
                    end if;
            

         when 74 => 
--# line 355 "ascan.l"
             ACTION_ECHO; 

         when 75 => 
--# line 357 "ascan.l"
             ACTION_ECHO; 

         when 76 => 
--# line 358 "ascan.l"
             ACTION_ECHO; 

         when 77 => 
--# line 359 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 78 => 
--# line 360 "ascan.l"
             ACTION_ECHO; ENTER(ACTION); 

         when 79 => 
--# line 361 "ascan.l"
             ACTION_ECHO; 

         when 80 => 
--# line 364 "ascan.l"
            
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            return ( CHAR );
            

         when 81 => 
--# line 369 "ascan.l"
            
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            ENTER(CCL);
            return CHAR;
            

         when 82 => 
--# line 376 "ascan.l"
             if check_yylex_here then
                return End_Of_Input;
              else
                ECHO;
              end if;
            

         when 83 => 
--# line 382 "ascan.l"
            ECHO;
         when YY_END_OF_BUFFER + INITIAL + 1 |
             YY_END_OF_BUFFER + SECT2 + 1 |
             YY_END_OF_BUFFER + SECT3 + 1 |
             YY_END_OF_BUFFER + PICKUPDEF + 1 |
             YY_END_OF_BUFFER + SC + 1 |
             YY_END_OF_BUFFER + CARETISBOL + 1 |
             YY_END_OF_BUFFER + NUM + 1 |
             YY_END_OF_BUFFER + QUOTE + 1 |
             YY_END_OF_BUFFER + FIRSTCCL + 1 |
             YY_END_OF_BUFFER + CCL + 1 |
             YY_END_OF_BUFFER + ACTION + 1 |
             YY_END_OF_BUFFER + RECOVER + 1 |
             YY_END_OF_BUFFER + BRACEERROR + 1 |
             YY_END_OF_BUFFER + ACTION_STRING + 1 => 
               return End_Of_Input;
            when YY_END_OF_BUFFER =>
                    -- undo the effects of YY_DO_BEFORE_ACTION
                    yy_ch_buf(yy_cp) := yy_hold_char;

                    yytext_ptr := yy_bp;

                    case yy_get_next_buffer is
                        when EOB_ACT_END_OF_FILE =>
                            if yywrap then
                                -- note: because we've taken care in
                                -- yy_get_next_buffer() to have set up yytext,
                                -- we can now set up yy_c_buf_p so that if some
                                -- total hoser (like aflex itself) wants
                                -- to call the scanner after we return the
                                -- End_Of_Input, it'll still work - another
                                -- End_Of_Input will get returned.

                                yy_c_buf_p := yytext_ptr;

                                yy_act := YY_STATE_EOF((yy_start - 1) / 2);

                                goto do_action;
                            else
                                --  start processing a new file
                                yy_init := true;
                                goto new_file;
                            end if;

                        when EOB_ACT_RESTART_SCAN =>
                            yy_c_buf_p := yytext_ptr;
                            yy_hold_char := yy_ch_buf(yy_c_buf_p);
                        when EOB_ACT_LAST_MATCH =>
                            yy_c_buf_p := yy_n_chars;
                            yy_current_state := yy_get_previous_state;

                            yy_cp := yy_c_buf_p;
                            yy_bp := yytext_ptr;
                            goto next_action;
                        when others =>
                           null;
                    end case; -- case yy_get_next_buffer()

            when others =>
               Text_IO.put ("action # " );
               Text_IO.put (Integer'Image (yy_act));
               Text_IO.new_line;
               raise AFLEX_INTERNAL_ERROR;
         end case; -- case (yy_act)
      end loop; -- end of loop waiting for end of file
   end YYLex;
--# line 382 "ascan.l"
   begin

      if (call_yylex) then
         toktype := YYLex;
         call_yylex := False;
         return toktype;
      end if;

      if ( eofseen ) then
         toktype := End_Of_Input;
      else
         toktype := YYLex;
      end if;

      -- this tracing code allows easy tracing of aflex runs
      if (trace) then
         Ada.Text_IO.New_Line (Standard_Error);
         Ada.Text_IO.Put (Standard_Error, "toktype = :" );
         Ada.Text_IO.Put (Standard_Error, Token'Image (toktype));
         Ada.Text_IO.Put_line (Standard_Error, ":" );
      end if;

      if ( toktype = End_Of_Input ) then
         eofseen := True;

         if sectnum = 1 then
            misc.synerr ("unexpected EOF");
            sectnum := 2;
            toktype := SECTEND;
         elsif sectnum = 2 then
            sectnum := 3;
            toktype := SECTEND;
         end if;
      end if;
    
      if trace then
         if beglin then
            Int_IO.Put (Standard_Error, num_rules + 1);
            Ada.Text_IO.Put (Standard_Error, ASCII.HT);
            beglin := False;
         end if;

         case toktype is
            when '<' | '>'|'^'|'$'|'"'|'['|']'|'{'|'}'|'|'|'('|
                 ')'|'-'|'/'|'?'|'.'|'*'|'+'|',' =>
               Ada.Text_IO.Put (Standard_Error, Token'Image (toktype));

            when NEWLINE =>
               Ada.Text_IO.New_Line (Standard_Error);
               if sectnum = 2 then
                  beglin := True;
               end if;

            when SCDECL =>
               Ada.Text_IO.Put (Standard_Error, "%s");

            when XSCDECL =>
               Ada.Text_IO.Put (Standard_Error, "%x");

            when WHITESPACE =>
               Ada.Text_IO.Put (Standard_Error, " ");

            when SECTEND =>
               Ada.Text_IO.Put_line (Standard_Error, "%%");

               --  we set beglin to be true so we'll start
               --  writing out numbers as we echo rules.  aflexscan() has
               --  already assigned sectnum

               if sectnum = 2 then
                  beglin := True;
               end if;

            when NAME =>
               Ada.Text_IO.Put (Standard_Error, ''');
               Ada.Text_IO.Put (Standard_Error, YYText);
               Ada.Text_IO.Put (Standard_Error, ''');

            when CHAR =>
               if ( (YYLVal < CHARACTER'POS(' ')) or
                  (YYLVal = CHARACTER'POS(ASCII.DEL)) ) then
                  Ada.Text_IO.Put (Standard_Error, '\');
                  Int_IO.Put (Standard_Error, YYLVal);
                  Ada.Text_IO.Put (Standard_Error, '\');
               else
                  Ada.Text_IO.Put (Standard_Error, Token'Image (toktype));
               end if;

            when NUMBER =>
               Int_IO.Put (Standard_Error, YYLVal);

            when PREVCCL =>
               Ada.Text_IO.Put (Standard_Error, '[');
               Int_IO.Put (Standard_Error, YYLVal);
               Ada.Text_IO.Put (Standard_Error, ']');

            when End_Of_Input =>
               Ada.Text_IO.Put (Standard_Error, "End Marker");

            when others =>
               Ada.Text_IO.Put (Standard_Error, "Something weird:");
               Ada.Text_IO.Put_line (Standard_Error, Token'Image (toktype));
         end case;
      end if;
      return toktype;
   end get_token;

end scanner;

