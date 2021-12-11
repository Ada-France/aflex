
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
      subtype Short is Integer range -32768 .. 32767;
      yy_act : Integer;
      yy_c   : Short;

      --  returned upon end-of-file
      YY_END_TOK : constant Integer := 0;
      YY_END_OF_BUFFER : constant := 85;
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
      yy_accept : constant array (0 .. 219) of Short :=
          (0,
        0,    0,    0,    0,    0,    0,   83,   83,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
       85,   16,    8,   15,   13,    1,   14,   16,   16,   16,
       11,   42,   34,   35,   28,   42,   41,   26,   42,   42,
       42,   34,   24,   42,   42,   27,   84,   22,   83,   83,
       18,   17,   19,   48,   84,   44,   45,   47,   49,   63,
       64,   61,   60,   62,   50,   52,   51,   50,   56,   55,
       56,   56,   58,   58,   58,   59,   69,   74,   73,   75,
       69,   75,   70,   67,   68,   84,   20,   66,   65,   76,

       78,   79,   80,    8,   15,   13,    0,    1,   14,    0,
        0,    2,    0,    9,    7,    4,    6,    5,    0,   11,
       34,   35,    0,   31,    0,    0,    0,   81,   81,   30,
       29,   30,    0,   34,   24,    0,    0,   38,    0,    0,
       22,   21,   83,   83,   18,   17,   46,   47,   60,   82,
       82,   53,   54,   57,   69,    0,   72,    0,   69,   70,
        0,   20,   76,   77,   12,    0,    9,    0,    0,    0,
        0,    3,    0,   32,    0,   39,    0,   81,   30,   30,
       40,    0,    0,    0,   38,    0,   33,   82,   69,   71,
        0,   12,    0,   10,    0,    0,    0,    0,    0,    0,

        0,    0,    0,    0,    6,    0,    0,    0,   25,    0,
       25,    0,   25,    0,    4,    0,    7,   37,    0
       );

      yy_ec : constant array (ASCII.NUL .. Character'Last) of Short := (0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    4,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    5,    1,    6,    7,    8,    9,    1,   10,   11,
       11,   11,   11,   12,   13,   14,   15,   16,   16,   16,
       16,   16,   16,   16,   16,   16,   16,    1,    1,   17,
        1,   18,   11,    1,   24,   23,   23,   23,   25,   26,
       23,   23,   27,   23,   23,   23,   23,   28,   29,   30,
       23,   31,   32,   33,   34,   23,   23,   35,   23,   23,
       19,   20,   21,   22,   23,    1,   24,   23,   23,   23,

       25,   26,   23,   23,   27,   23,   23,   23,   23,   28,
       29,   30,   23,   31,   32,   33,   34,   23,   23,   35,
       23,   23,   36,   37,   38,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1, others => 1

       );

      yy_meta : constant array (0 .. 38) of Short :=
          (0,
        1,    2,    3,    2,    2,    4,    1,    1,    1,    5,
        1,    1,    6,    7,    5,    6,    1,    1,    1,    8,
        9,    1,   10,   10,   10,   10,   10,   10,   10,   10,
       10,   10,   10,   10,   10,    5,    1,   11
       );

      yy_base : constant array (0 .. 264) of Short :=
          (0,
        0,   38,   75,  111,  412,  411,  410,  409,   94,   98,
      148,    0,  389,  388,  184,  185,   85,  101,  124,  186,
      189,  191,  223,    0,  406,  405,  103,  105,  187,  259,
      407,  950,  211,  950,  392,  264,  950,  402,  100,  391,
      389,  950,  268,  950,  950,   82,  950,  385,  381,  384,
      290,  324,  950,  389,  384,  950,  393,    0,  392,  950,
        0,  134,  950,  950,  950,  950,  372,    0,  950,  950,
      950,  950,  377,  950,  950,  950,  950,  376,  950,  950,
      370,  372,  950,    0,  355,  950,    0,  950,  950,  185,
      357,  950,    0,  950,  950,  366,  950,  950,  950,    0,

      950,  950,    0,  215,  950,  354,    0,  278,  950,  354,
      363,  950,  359,    0,   88,  330,  332,  950,  356,  344,
      293,  950,  354,  950,  331,  243,  124,  950,  339,    0,
      950,  349,  341,  386,  950,  340,  271,    0,  349,  348,
        0,  950,  347,  950,    0,  283,  950,    0,  333,  950,
      332,  950,  950,  950,    0,  266,  950,    0,  423,    0,
      344,  950,    0,  950,  332,  342,    0,  311,  319,  315,
      338,  950,  337,  950,  310,  950,  273,  322,    0,    0,
      950,  323,  287,  289,    0,  332,  950,  318,    0,  950,
      461,  319,  329,  950,  304,  281,  278,  284,  283,  306,

      298,  275,  246,  188,  950,  185,  287,  195,  950,  188,
      950,  139,  950,   95,  950,   92,  950,  950,  950,  498,
      509,  520,  531,  542,  553,  564,  575,  586,  597,  608,
      614,  624,  635,  641,  651,  662,  673,  684,  695,  706,
      717,  728,  734,  744,  755,  766,  777,  786,  792,  802,
      813,  824,   72,  835,  846,  857,  868,  878,  889,  895,
      905,  916,  927,  938
       );

      yy_def : constant array (0 .. 264) of Short :=
          (0,
      219,  219,  220,  220,  221,  221,  222,  222,  223,  223,
      219,   11,  224,  224,  225,  225,  226,  226,  227,  227,
      228,  228,  219,   23,  229,  229,  224,  224,  230,  230,
      219,  219,  219,  219,  231,  219,  219,  232,  233,  219,
      234,  219,  219,  219,  219,  219,  219,  219,  235,  236,
      237,  238,  219,  219,  219,  219,  239,  240,  241,  219,
      242,  219,  219,  219,  219,  219,  219,  243,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  236,  219,  219,
      244,  245,  219,  246,  236,  219,  247,  219,  219,  248,
      247,  219,  249,  219,  219,  250,  219,  219,  219,  251,

      219,  219,  252,  219,  219,  231,  253,  219,  219,  219,
      232,  219,  219,  254,  219,  219,  219,  219,  255,  234,
      219,  219,  256,  219,  219,  235,  235,  219,  219,  257,
      219,  257,  219,  238,  219,  219,  256,  258,  259,  239,
      240,  219,  241,  219,  242,  219,  219,  243,  219,  219,
      219,  219,  219,  219,  247,  248,  219,  248,  219,  249,
      250,  219,  251,  219,  260,  261,  254,  219,  219,  219,
      255,  219,  256,  219,  219,  219,  235,  219,  257,  132,
      219,  219,  259,  256,  258,  259,  219,  219,  159,  219,
      159,  260,  261,  219,  219,  219,  219,  219,  235,  262,

      263,  264,  219,  219,  219,  219,  235,  262,  219,  263,
      219,  264,  219,  219,  219,  219,  219,  219,    0,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219
       );

      yy_nxt : constant array (0 .. 988) of Short :=
          (0,
       32,   33,   34,   33,   33,   32,   32,   32,   32,   32,
       32,   32,   32,   32,   32,   32,   32,   32,   32,   32,
       32,   32,   35,   35,   35,   35,   35,   35,   35,   35,
       35,   35,   35,   35,   35,   32,   32,   32,   32,   36,
       37,   36,   36,   32,   38,   32,   39,   32,   32,   32,
       40,   32,   32,   32,   32,   32,   32,   32,   32,   32,
       41,   41,   41,   41,   41,   41,   41,   41,   41,   41,
       41,   41,   41,   32,   32,   32,   43,   44,   43,   43,
       45,  165,   46,  124,  124,   47,  124,   76,   47,   47,
       77,   48,  166,   49,   50,   62,   63,   62,   62,   62,

       63,   62,   62,   76,   78,   98,   77,   98,  114,  218,
       51,   47,   52,   53,   52,   52,   45,  168,   46,   54,
       78,   47,  217,   55,   47,   47,   65,   48,  115,   49,
       50,  116,   56,  117,  118,  146,   80,  146,  146,  177,
       99,  213,   99,   81,  126,   82,   51,   47,   64,   64,
       65,   64,   64,   64,   64,   64,   64,   64,   64,   66,
       64,   64,   64,   64,   64,   67,   64,   64,   64,   64,
       68,   68,   68,   68,   68,   68,   68,   68,   68,   68,
       68,   68,   68,   64,   64,   64,   71,   71,   65,  101,
      211,   65,  102,   65,  157,   72,   72,  209,   80,   73,

       73,   84,  216,   84,  158,   81,  103,   82,   85,   86,
       85,   86,  104,  105,  104,  104,  104,  105,  104,  104,
      215,   74,   74,   87,   87,   88,   87,   87,   89,   87,
       87,   87,   90,   87,   87,   91,   87,   92,   87,   87,
       87,   87,   87,   87,   87,   93,   93,   93,   93,   93,
       93,   93,   93,   93,   93,   93,   93,   93,   94,   87,
       95,  101,  127,  176,  102,  108,  109,  108,  108,  121,
      122,  121,  121,  174,  214,  157,  110,  213,  103,  108,
      109,  108,  108,  184,  146,  158,  146,  146,  199,  187,
      110,  174,  127,  176,  121,  122,  121,  121,  207,  201,

      211,  202,  127,  176,  123,  131,  127,  176,  209,  206,
      205,  204,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,  132,  134,  135,  134,  134,  123,
      203,  194,  107,  150,  187,  200,  136,  128,  198,  174,
      172,  197,  196,  195,  194,  107,  162,  188,  149,  144,
      141,  187,  183,  182,  178,  175,  174,  107,  172,  170,
      137,  180,  169,  166,  180,  112,  119,  107,  162,  159,
      129,  180,  180,  180,  180,  180,  180,  180,  180,  180,
      180,  180,  180,  180,  153,  151,  181,  134,  135,  134,
      134,  129,  149,  147,  144,  141,  139,  138,  136,  129,

      127,  125,  107,  119,  112,  107,  219,   97,   97,   69,
       69,   60,   60,   58,   58,  219,  219,  219,  219,  219,
      219,  219,  137,  189,  189,  190,  189,  189,  191,  189,
      189,  189,  191,  189,  189,  189,  189,  191,  189,  189,
      189,  189,  189,  189,  189,  191,  191,  191,  191,  191,
      191,  191,  191,  191,  191,  191,  191,  191,  191,  189,
      191,  191,  191,  219,  191,  191,  219,  191,  191,  191,
      219,  191,  191,  191,  191,  219,  191,  191,  191,  191,
      191,  191,  191,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  191,   42,   42,

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
      106,  219,  219,  106,  111,  111,  111,  111,  111,  111,
      111,  111,  111,  111,  111,  113,  113,  113,  113,  113,
      113,  113,  113,  113,  113,  113,  120,  120,  219,  219,
      120,  126,  126,  219,  126,  126,  126,  126,  126,  219,
      126,  126,  128,  128,  219,  128,  128,  128,  128,  128,
      128,  128,  128,  130,  130,  219,  130,  130,  130,  130,
      130,  130,  130,  130,  133,  133,  133,  133,  133,  133,
      133,  133,  133,  133,  133,  140,  140,  140,  140,  140,

      140,  140,  140,  140,  140,  140,  142,  219,  219,  142,
      142,  142,  142,  142,  142,  142,  142,  143,  143,  143,
      143,  143,  143,  143,  143,  143,  143,  143,  145,  145,
      219,  145,  145,  145,  145,  145,  145,  145,  145,  148,
      219,  219,  219,  148,  150,  150,  219,  150,  150,  150,
      150,  150,  150,  150,  150,  152,  152,  219,  152,  152,
      152,  152,  152,  152,  152,  152,  154,  154,  219,  154,
      154,  154,  154,  154,  219,  154,  154,  155,  155,  219,
      219,  219,  155,  155,  155,  155,  156,  156,  219,  156,
      156,  156,  156,  156,  156,  156,  156,  160,  219,  219,

      219,  160,  161,  161,  161,  161,  161,  161,  161,  161,
      161,  161,  161,  163,  163,  219,  219,  163,  163,  163,
      219,  163,  163,  163,  164,  164,  219,  164,  164,  164,
      164,  164,  164,  164,  164,  167,  167,  219,  167,  167,
      167,  167,  167,  167,  167,  167,  171,  171,  171,  171,
      171,  171,  171,  171,  171,  171,  171,  173,  173,  173,
      173,  173,  173,  173,  173,  173,  173,  173,  179,  179,
      219,  179,  179,  179,  179,  179,  179,  179,  185,  185,
      219,  185,  185,  185,  185,  185,  185,  185,  185,  186,
      186,  186,  186,  186,  186,  186,  186,  186,  186,  186,

      192,  192,  219,  219,  192,  193,  193,  193,  193,  193,
      193,  193,  193,  193,  193,  193,  208,  208,  208,  208,
      208,  208,  208,  208,  208,  208,  208,  210,  210,  210,
      210,  210,  210,  210,  210,  210,  210,  210,  212,  212,
      212,  212,  212,  212,  212,  212,  212,  212,  212,   31,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219
       );

      yy_chk : constant array (0 .. 988) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    3,    3,    3,    3,
        3,  253,    3,   46,   46,    3,   46,   17,    3,    3,
       17,    3,  115,    3,    3,    9,    9,    9,    9,   10,

       10,   10,   10,   18,   17,   27,   18,   28,   39,  216,
        3,    3,    4,    4,    4,    4,    4,  115,    4,    4,
       18,    4,  214,    4,    4,    4,   19,    4,   39,    4,
        4,   39,    4,   39,   39,   62,   19,   62,   62,  127,
       27,  212,   28,   19,  127,   19,    4,    4,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   15,   16,   20,   29,
      210,   21,   29,   22,   90,   15,   16,  208,   20,   15,

       16,   21,  206,   22,   90,   20,   29,   20,   21,   21,
       22,   22,   33,   33,   33,   33,  104,  104,  104,  104,
      204,   15,   16,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   30,  126,  126,   30,   36,   36,   36,   36,   43,
       43,   43,   43,  137,  203,  156,   36,  202,   30,  108,
      108,  108,  108,  137,  146,  156,  146,  146,  177,  183,
      108,  184,  177,  177,  121,  121,  121,  121,  199,  183,

      201,  184,  199,  199,   43,   51,  207,  207,  200,  198,
      197,  196,   51,   51,   51,   51,   51,   51,   51,   51,
       51,   51,   51,   51,   51,   52,   52,   52,   52,  121,
      195,  193,  192,  188,  186,  182,   52,  178,  175,  173,
      171,  170,  169,  168,  166,  165,  161,  151,  149,  143,
      140,  139,  136,  133,  129,  125,  123,  120,  119,  117,
       52,  132,  116,  113,  132,  111,  110,  106,   96,   91,
       85,  132,  132,  132,  132,  132,  132,  132,  132,  132,
      132,  132,  132,  132,   82,   81,  132,  134,  134,  134,
      134,   78,   73,   67,   59,   57,   55,   54,  134,   50,

       49,   48,   41,   40,   38,   35,   31,   26,   25,   14,
       13,    8,    7,    6,    5,    0,    0,    0,    0,    0,
        0,    0,  134,  159,  159,  159,  159,  159,  159,  159,
      159,  159,  159,  159,  159,  159,  159,  159,  159,  159,
      159,  159,  159,  159,  159,  159,  159,  159,  159,  159,
      159,  159,  159,  159,  159,  159,  159,  159,  159,  159,
      159,  191,  191,    0,  191,  191,    0,  191,  191,  191,
        0,  191,  191,  191,  191,    0,  191,  191,  191,  191,
      191,  191,  191,    0,    0,    0,    0,    0,    0,    0,
        0,    0,    0,    0,    0,    0,    0,  191,  220,  220,

      220,  220,  220,  220,  220,  220,  220,  220,  220,  221,
      221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
      222,  222,  222,  222,  222,  222,  222,  222,  222,  222,
      222,  223,  223,  223,  223,  223,  223,  223,  223,  223,
      223,  223,  224,  224,  224,  224,  224,  224,  224,  224,
      224,  224,  224,  225,  225,  225,  225,  225,  225,  225,
      225,  225,  225,  225,  226,  226,  226,  226,  226,  226,
      226,  226,  226,  226,  226,  227,  227,  227,  227,  227,
      227,  227,  227,  227,  227,  227,  228,  228,  228,  228,
      228,  228,  228,  228,  228,  228,  228,  229,  229,  229,

      229,  229,  229,  229,  229,  229,  229,  229,  230,  230,
      230,  230,  230,  230,  230,  230,  230,  230,  230,  231,
      231,    0,    0,  231,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  233,  233,  233,  233,  233,
      233,  233,  233,  233,  233,  233,  234,  234,    0,    0,
      234,  235,  235,    0,  235,  235,  235,  235,  235,    0,
      235,  235,  236,  236,    0,  236,  236,  236,  236,  236,
      236,  236,  236,  237,  237,    0,  237,  237,  237,  237,
      237,  237,  237,  237,  238,  238,  238,  238,  238,  238,
      238,  238,  238,  238,  238,  239,  239,  239,  239,  239,

      239,  239,  239,  239,  239,  239,  240,    0,    0,  240,
      240,  240,  240,  240,  240,  240,  240,  241,  241,  241,
      241,  241,  241,  241,  241,  241,  241,  241,  242,  242,
        0,  242,  242,  242,  242,  242,  242,  242,  242,  243,
        0,    0,    0,  243,  244,  244,    0,  244,  244,  244,
      244,  244,  244,  244,  244,  245,  245,    0,  245,  245,
      245,  245,  245,  245,  245,  245,  246,  246,    0,  246,
      246,  246,  246,  246,    0,  246,  246,  247,  247,    0,
        0,    0,  247,  247,  247,  247,  248,  248,    0,  248,
      248,  248,  248,  248,  248,  248,  248,  249,    0,    0,

        0,  249,  250,  250,  250,  250,  250,  250,  250,  250,
      250,  250,  250,  251,  251,    0,    0,  251,  251,  251,
        0,  251,  251,  251,  252,  252,    0,  252,  252,  252,
      252,  252,  252,  252,  252,  254,  254,    0,  254,  254,
      254,  254,  254,  254,  254,  254,  255,  255,  255,  255,
      255,  255,  255,  255,  255,  255,  255,  256,  256,  256,
      256,  256,  256,  256,  256,  256,  256,  256,  257,  257,
        0,  257,  257,  257,  257,  257,  257,  257,  258,  258,
        0,  258,  258,  258,  258,  258,  258,  258,  258,  259,
      259,  259,  259,  259,  259,  259,  259,  259,  259,  259,

      260,  260,    0,    0,  260,  261,  261,  261,  261,  261,
      261,  261,  261,  261,  261,  261,  262,  262,  262,  262,
      262,  262,  262,  262,  262,  262,  262,  263,  263,  263,
      263,  263,  263,  263,  263,  263,  263,  263,  264,  264,
      264,  264,  264,  264,  264,  264,  264,  264,  264,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      219,  219,  219,  219,  219,  219,  219,  219
       );


      --  copy whatever the last rule matched to the standard output

      procedure ECHO is
      begin
         if Text_IO.Is_Open (user_output_file) then
            Text_IO.Put (user_output_file, YYText);
         else
            Text_IO.Put (YYText);
         end if;
      end ECHO;

      --  enter a start condition.
      --  Using procedure requires a () after the ENTER, but makes everything
      --  much neater.

      procedure ENTER (state : Integer) is
      begin
         yy_start := 1 + 2 * state;
      end ENTER;

      --  action number for EOF rule of a given start state
      function YY_STATE_EOF (state : Integer) return Integer is
      begin
         return YY_END_OF_BUFFER + state + 1;
      end YY_STATE_EOF;

      --  return all but the first 'n' matched characters back to the input stream
      procedure yyless (n : Integer) is
      begin
         yy_ch_buf (yy_cp) := yy_hold_char; --  undo effects of setting up yytext
         yy_cp := yy_bp + n;
         yy_c_buf_p := yy_cp;
         YY_DO_BEFORE_ACTION; -- set up yytext again
      end yyless;

      --  redefine this if you have something you want each time.
      procedure YY_USER_ACTION is
      begin
         null;
      end YY_USER_ACTION;

      --  yy_get_previous_state - get the state just before the EOB char was reached

      function yy_get_previous_state return yy_state_type is
         yy_current_state : yy_state_type;
         yy_c : Short;
         yy_bp : constant Integer := yytext_ptr;
      begin
         yy_current_state := yy_start;
         if yy_ch_buf (yy_bp - 1) = ASCII.LF then
            yy_current_state := yy_current_state + 1;
         end if;

         for yy_cp in yytext_ptr .. yy_c_buf_p - 1 loop
            yy_c := yy_ec (yy_ch_buf (yy_cp));
            if yy_accept (yy_current_state) /= 0 then
               yy_last_accepting_state := yy_current_state;
               yy_last_accepting_cpos := yy_cp;
            end if;
            while yy_chk (yy_base (yy_current_state) + yy_c) /= yy_current_state loop
               yy_current_state := yy_def (yy_current_state);
               if yy_current_state >= 220 then
                  yy_c := yy_meta (yy_c);
               end if;
            end loop;
            yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
         end loop;

         return yy_current_state;
      end yy_get_previous_state;

      procedure yyrestart (input_file : File_Type) is
      begin
         Open_Input (Text_IO.Name (input_file));
      end yyrestart;

   begin -- of YYLex
      <<new_file>>
      --  this is where we enter upon encountering an end-of-file and
      --  yyWrap () indicating that we should continue processing

      if yy_init then
         if yy_start = 0 then
            yy_start := 1;      -- first start state
         end if;

         --  we put in the '\n' and start reading from [1] so that an
         --  initial match-at-newline will be true.

         yy_ch_buf (0) := ASCII.LF;
         yy_n_chars := 1;

         --  we always need two end-of-buffer characters. The first causes
         --  a transition to the end-of-buffer state. The second causes
         --  a jam in that state.

         yy_ch_buf (yy_n_chars) := YY_END_OF_BUFFER_CHAR;
         yy_ch_buf (yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;

         yy_eof_has_been_seen := False;

         yytext_ptr := 1;
         yy_c_buf_p := yytext_ptr;
         yy_hold_char := yy_ch_buf (yy_c_buf_p);
         yy_init := False;
      end if; -- yy_init

      loop                -- loops until end-of-file is reached


         yy_cp := yy_c_buf_p;

         --  support of yytext
         yy_ch_buf (yy_cp) := yy_hold_char;

         --  yy_bp points to the position in yy_ch_buf of the start of the
         --  current run.
         yy_bp := yy_cp;
         yy_current_state := yy_start;
         if yy_ch_buf (yy_bp - 1) = ASCII.LF then
            yy_current_state := yy_current_state + 1;
         end if;
         loop
               yy_c := yy_ec (yy_ch_buf (yy_cp));
               if yy_accept (yy_current_state) /= 0 then
                  yy_last_accepting_state := yy_current_state;
                  yy_last_accepting_cpos := yy_cp;
               end if;
               while yy_chk (yy_base (yy_current_state) + yy_c) /= yy_current_state loop
                  yy_current_state := yy_def (yy_current_state);
                  if yy_current_state >= 220 then
                     yy_c := yy_meta (yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
            if yy_current_state = 219 then
                exit;
            end if;
         end loop;
         yy_cp := yy_last_accepting_cpos;
         yy_current_state := yy_last_accepting_state;

   <<next_action>>
         yy_act := yy_accept (yy_current_state);
         YY_DO_BEFORE_ACTION;
         YY_USER_ACTION;

         if aflex_debug then  -- output acceptance info. for (-d) debug mode
            Text_IO.Put (Standard_Error, "  -- Aflex.YYLex accept rule #");
            Text_IO.Put (Standard_Error, Integer'Image (yy_act));
            Text_IO.Put_Line (Standard_Error, "(""" & YYText & """)");
         end if;


   <<do_action>>   -- this label is used only to access EOF actions
         case yy_act is
            when 0 => -- must backtrack
            -- undo the effects of YY_DO_BEFORE_ACTION
            yy_ch_buf (yy_cp) := yy_hold_char;
            yy_cp := yy_last_accepting_cpos;
            yy_current_state := yy_last_accepting_state;
            goto next_action;



         when 1 =>
--# line 57 "ascan.l"
             indented_code := True; 

         when 2 =>
--# line 58 "ascan.l"
             linenum := linenum + 1; ECHO;
                -- treat as a comment;
            

         when 3 =>
--# line 61 "ascan.l"
             linenum := linenum + 1; ECHO; 

         when 4 =>
--# line 62 "ascan.l"
             return SCDECL; 

         when 5 =>
--# line 63 "ascan.l"
             return XSCDECL; 

         when 6 =>
--# line 64 "ascan.l"
             return USCDECL; 

         when 7 =>
--# line 65 "ascan.l"
             return OPTDECL; 

         when 8 =>
--# line 67 "ascan.l"
             return WHITESPACE; 

         when 9 =>
--# line 69 "ascan.l"
            
            sectnum := 2;
            misc.line_directive_out;
            ENTER(SECT2PROLOG);
            return SECTEND;
            

         when 10 =>
--# line 76 "ascan.l"
            
            Ada.Text_IO.Put( Standard_Error, "old-style lex command at line " );
            int_io.put( Standard_Error, linenum );
            Ada.Text_IO.Put( Standard_Error, " ignored:" );
            text_io.new_line( Standard_Error );
            Ada.Text_IO.Put( Standard_Error, ASCII.HT );
            Ada.Text_IO.Put( Standard_Error, yytext(1..YYLength) );
            linenum := linenum + 1;
            

         when 11 =>
--# line 86 "ascan.l"
            
            nmstr := vstr(yytext(1..YYLength));
            didadef := False;
            ENTER(PICKUPDEF);
            

         when 12 =>
--# line 92 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return UNAME;
            

         when 13 =>
--# line 96 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 14 =>
--# line 99 "ascan.l"
             linenum := linenum + 1;
              -- allows blank lines in section 1;
            

         when 15 =>
--# line 102 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 16 =>
--# line 103 "ascan.l"
             misc.synerr( "illegal character" );ENTER(RECOVER);

         when 17 =>
--# line 105 "ascan.l"
             null;
              -- separates name and definition;
            

         when 18 =>
--# line 109 "ascan.l"
            
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
            

         when 19 =>
--# line 126 "ascan.l"
            
            if not didadef then
                misc.synerr( "incomplete name definition" );
            end if;
            ENTER(0);
            linenum := linenum + 1;
            

         when 20 =>
--# line 134 "ascan.l"
             linenum := linenum + 1;
              ENTER(0);
              nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 21 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_cp - 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 140 "ascan.l"
            
            linenum := linenum + 1;
            ACTION_ECHO;
            MARK_END_OF_PROLOG;
            ENTER(SECT2);
            

         when 22 =>
--# line 147 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

   when YY_END_OF_BUFFER +SECT2PROLOG + 1 
 =>
--# line 149 "ascan.l"
 MARK_END_OF_PROLOG;
              return End_Of_Input;
            

         when 24 =>
--# line 153 "ascan.l"
             linenum := linenum + 1;
              -- allow blank lines in sect2;

            -- this rule matches indented lines which
            -- are not comments.
         when 25 =>
--# line 158 "ascan.l"
            
            misc.synerr("indented code found outside of action");
            linenum := linenum + 1;
            

         when 26 =>
--# line 163 "ascan.l"
             ENTER(SC); return ( '<' ); 

         when 27 =>
--# line 164 "ascan.l"
             return ( '^' );  

         when 28 =>
--# line 165 "ascan.l"
             ENTER(QUOTE); return ( '"' ); 

         when 29 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 166 "ascan.l"
             ENTER(NUM); return ( '{' ); 

         when 30 =>
--# line 167 "ascan.l"
             ENTER(BRACEERROR); 

         when 31 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 168 "ascan.l"
             return '$'; 

         when 32 =>
--# line 170 "ascan.l"
             continued_action := True;
              linenum := linenum + 1;
              return Newline;
            

         when 33 =>
--# line 175 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 34 =>
--# line 177 "ascan.l"
            
            -- this rule is separate from the one below because
            -- otherwise we get variable trailing context, so
            -- we can't build the scanner using -f,F

            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            

         when 35 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_cp - 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 188 "ascan.l"
            
            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            

         when 36 =>
--# line 195 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 37 =>
--# line 197 "ascan.l"
             return EOF_OP; 

         when 38 =>
--# line 199 "ascan.l"
            
            sectnum := 3;
            ENTER(SECT3);
            return End_Of_Input;
            -- to stop the parser
            

         when 39 =>
--# line 206 "ascan.l"
            

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
            

         when 40 =>
--# line 231 "ascan.l"
            
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
            

         when 41 =>
--# line 248 "ascan.l"
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
            

         when 42 =>
--# line 262 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 43 =>
--# line 266 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 44 =>
--# line 269 "ascan.l"
             return ( ',' ); 

         when 45 =>
--# line 270 "ascan.l"
             ENTER(SECT2); return ( '>' ); 

         when 46 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 271 "ascan.l"
             ENTER(CARETISBOL); return ( '>' ); 

         when 47 =>
--# line 272 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 48 =>
--# line 275 "ascan.l"
             misc.synerr( "bad start condition name" ); 

         when 49 =>
--# line 277 "ascan.l"
             ENTER(SECT2); return '^'; 

         when 50 =>
--# line 280 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 51 =>
--# line 284 "ascan.l"
             ENTER(SECT2); return '"'; 

         when 52 =>
--# line 286 "ascan.l"
            
            misc.synerr( "missing quote" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '"';
            

         when 53 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 294 "ascan.l"
             ENTER(CCL); return '^'; 

         when 54 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 295 "ascan.l"
             return '^'; 

         when 55 =>
--# line 296 "ascan.l"
             ENTER(CCL); YYLVal := CHARACTER'POS('-'); return ( CHAR ); 

         when 56 =>
--# line 297 "ascan.l"
             ENTER(CCL);
              tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 57 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 303 "ascan.l"
             return '-'; 

         when 58 =>
--# line 304 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 59 =>
--# line 308 "ascan.l"
             ENTER(SECT2); return ']'; 

         when 60 =>
--# line 311 "ascan.l"
            
            YYLVal := misc.myctoi( vstr(yytext(1..YYLength)) );
            return NUMBER;
            

         when 61 =>
--# line 316 "ascan.l"
             return ','; 

         when 62 =>
--# line 317 "ascan.l"
             ENTER(SECT2); return '}'; 

         when 63 =>
--# line 319 "ascan.l"
            
            misc.synerr( "bad character inside {}'s" );
            ENTER(SECT2);
            return '}';
            

         when 64 =>
--# line 325 "ascan.l"
            
            misc.synerr( "missing }" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '}';
            

         when 65 =>
--# line 333 "ascan.l"
             misc.synerr( "bad name in {}'s" ); ENTER(SECT2); 

         when 66 =>
--# line 334 "ascan.l"
             misc.synerr( "missing }" );
              linenum := linenum + 1;
              ENTER(SECT2);
            

         when 67 =>
--# line 339 "ascan.l"
             bracelevel := bracelevel + 1; 

         when 68 =>
--# line 340 "ascan.l"
             bracelevel := bracelevel - 1; 

         when 69 =>
--# line 341 "ascan.l"
             ACTION_ECHO; 

         when 70 =>
--# line 342 "ascan.l"
             ACTION_ECHO; 

         when 71 =>
--# line 343 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 72 =>
--# line 344 "ascan.l"
             ACTION_ECHO;
                  -- character constant;
            

         when 73 =>
--# line 348 "ascan.l"
             ACTION_ECHO; ENTER(ACTION_STRING); 

         when 74 =>
--# line 350 "ascan.l"
            
            linenum := linenum + 1;
            ACTION_ECHO;
            if bracelevel = 0 then
                text_io.new_line ( temp_action_file );
                ENTER(SECT2);
                    end if;
            

         when 75 =>
--# line 358 "ascan.l"
             ACTION_ECHO; 

         when 76 =>
--# line 360 "ascan.l"
             ACTION_ECHO; 

         when 77 =>
--# line 361 "ascan.l"
             ACTION_ECHO; 

         when 78 =>
--# line 362 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 79 =>
--# line 363 "ascan.l"
             ACTION_ECHO; ENTER(ACTION); 

         when 80 =>
--# line 364 "ascan.l"
             ACTION_ECHO; 

         when 81 =>
--# line 367 "ascan.l"
            
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            return ( CHAR );
            

         when 82 =>
--# line 372 "ascan.l"
            
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            ENTER(CCL);
            return CHAR;
            

         when 83 =>
--# line 379 "ascan.l"
             if check_yylex_here then
                return End_Of_Input;
              else
                ECHO;
              end if;
            

         when 84 =>
--# line 385 "ascan.l"
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
            --  undo the effects of YY_DO_BEFORE_ACTION
            yy_ch_buf (yy_cp) := yy_hold_char;

            yytext_ptr := yy_bp;

            case yy_get_next_buffer is
               when EOB_ACT_END_OF_FILE =>
                  if yyWrap then
                     --  note: because we've taken care in
                     --  yy_get_next_buffer() to have set up yytext,
                     --  we can now set up yy_c_buf_p so that if some
                     --  total hoser (like aflex itself) wants
                     --  to call the scanner after we return the
                     --  End_Of_Input, it'll still work - another
                     --  End_Of_Input will get returned.

                     yy_c_buf_p := yytext_ptr;

                     yy_act := YY_STATE_EOF ((yy_start - 1) / 2);

                     goto do_action;
                  else
                     --  start processing a new file
                     yy_init := True;
                     goto new_file;
                  end if;

               when EOB_ACT_RESTART_SCAN =>
                  yy_c_buf_p := yytext_ptr;
                  yy_hold_char := yy_ch_buf (yy_c_buf_p);

               when EOB_ACT_LAST_MATCH =>
                  yy_c_buf_p := yy_n_chars;
                  yy_current_state := yy_get_previous_state;
                  yy_cp := yy_c_buf_p;
                  yy_bp := yytext_ptr;
                  goto next_action;
            end case; --  case yy_get_next_buffer()

         when others =>
            Text_IO.Put ("action # ");
            Text_IO.Put (Integer'Image (yy_act));
            Text_IO.New_Line;
            raise AFLEX_INTERNAL_ERROR;
         end case; --  case (yy_act)
      end loop; --  end of loop waiting for end of file
   end YYLex;
--# line 385 "ascan.l"
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

