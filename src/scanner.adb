
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
      YY_END_OF_BUFFER : constant := 87;
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
      YYDECL_STRING : constant := 15;
      yy_accept : constant array (0 .. 232) of Short :=
          (0,
        0,    0,    0,    0,    0,    0,   85,   85,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
       18,   18,   87,   17,    9,   16,   14,    1,   15,   17,
       17,   17,   12,   44,   36,   37,   30,   44,   43,   28,
       44,   44,   44,   36,   26,   44,   44,   29,   86,   24,
       85,   85,   20,   19,   21,   50,   86,   46,   47,   49,
       51,   65,   66,   63,   62,   64,   52,   54,   53,   52,
       58,   57,   58,   58,   60,   60,   60,   61,   71,   76,
       75,   77,   71,   77,   72,   69,   70,   86,   22,   68,

       67,   78,   80,   81,   82,   18,    9,   16,   14,    0,
        1,   15,    0,    0,    2,    0,   10,    7,    4,    6,
        5,    0,    0,   12,   36,   37,    0,   33,    0,    0,
        0,   83,   83,   32,   31,   32,    0,   36,   26,    0,
        0,   40,    0,    0,   24,   23,   85,   85,   20,   19,
       48,   49,   62,   84,   84,   55,   56,   59,   71,    0,
       74,    0,   71,   72,    0,   22,   78,   79,   18,   13,
        0,   10,    0,    0,    0,    8,    8,    0,    0,    3,
        0,   34,    0,   41,    0,   83,   32,   32,   42,    0,
        0,    0,   40,    0,   35,   84,   71,   73,    0,   13,

        0,   11,    0,    0,    0,    8,    0,    0,    0,    0,
        0,    0,    0,    0,    6,    0,    0,    0,    0,   27,
        0,   27,    0,   27,    0,    4,    0,    0,    7,    0,
       39,    0
       );

      yy_ec : constant array (ASCII.NUL .. Character'Last) of Short := (0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    4,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    5,    1,    6,    7,    8,    9,    1,   10,   11,
       11,   11,   11,   12,   13,   14,   15,   16,   16,   16,
       16,   16,   16,   16,   16,   16,   16,    1,    1,   17,
        1,   18,   11,    1,   24,   23,   25,   26,   27,   28,
       23,   23,   29,   23,   23,   30,   23,   31,   32,   33,
       23,   34,   35,   36,   37,   23,   23,   38,   39,   23,
       19,   20,   21,   22,   23,    1,   24,   23,   25,   26,

       27,   28,   23,   23,   29,   23,   23,   30,   23,   31,
       32,   33,   23,   34,   35,   36,   37,   23,   23,   38,
       39,   23,   40,   41,   42,    1,    1,    1,    1,    1,
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

      yy_meta : constant array (0 .. 42) of Short :=
          (0,
        1,    2,    3,    2,    2,    4,    1,    1,    1,    5,
        1,    1,    6,    7,    5,    6,    1,    1,    1,    8,
        9,    1,   10,   10,   10,   10,   10,   10,   10,   10,
       10,   10,   10,   10,   10,   10,   10,   10,   10,    5,
        1,   11
       );

      yy_base : constant array (0 .. 278) of Short :=
          (0,
        0,   42,   83,  123,  748,  747,  715,  710,  102,  106,
      164,    0,  685,  681,  204,  205,   93,  113,  136,  206,
      141,  209,  247,    0,  699,  673,  109,  111,  115,  207,
      672,  536,  538, 1003,  229, 1003,  523,  288, 1003,  533,
      205,  522,  520, 1003,  292, 1003, 1003,   90, 1003,  516,
      512,  515,  333,  374, 1003,  521,  516, 1003,  525,    0,
      524, 1003,    0,  155, 1003, 1003, 1003, 1003,  504,    0,
     1003, 1003, 1003, 1003,  509, 1003, 1003, 1003, 1003,  508,
     1003, 1003,  507,  509, 1003,    0,  498, 1003,    0, 1003,
     1003,  110,  496, 1003,    0, 1003, 1003,  502, 1003, 1003,

     1003,    0, 1003, 1003,    0,    0,  300, 1003,  488,    0,
      304, 1003,  443,  452, 1003,  432,    0,  117,  400,  404,
     1003,  378,  431,  419,  386, 1003,  427, 1003,  402,  126,
      202, 1003,  410,    0, 1003,  415,  412,  391, 1003,  411,
      212,    0,  420,  419,    0, 1003,  418, 1003,    0,  234,
     1003,    0,  404, 1003,  403, 1003, 1003, 1003,    0,  225,
     1003,    0,  457,    0,  415, 1003,    0, 1003,    0,  402,
      411,    0,  377,  388,  382,  308,  316,  384,  406, 1003,
      405, 1003,  375, 1003,  295,  390,    0,    0, 1003,  392,
      311,  319,    0,  400, 1003,  386,    0, 1003,  499,  387,

      395, 1003,  363,  350,  300,  323,  304,  302,  365,  326,
      320,  297,  209,  188, 1003,  186,  137,  278,  149, 1003,
      145, 1003,  138, 1003,   86, 1003,   85,   83, 1003,  395,
     1003, 1003,  540,  551,  562,  573,  584,  595,  606,  617,
      628,  639,  650,  661,  667,  677,  688,  694,  704,  715,
      726,  737,  748,  759,  770,  776,  786,  797,  808,  819,
      828,  834,  844,  855,  866,  877,   80,  888,  899,  910,
      921,  931,  942,  948,  958,  969,  980,  991
       );

      yy_def : constant array (0 .. 278) of Short :=
          (0,
      232,  232,  233,  233,  234,  234,  235,  235,  236,  236,
      232,   11,  237,  237,  238,  238,  239,  239,  240,  240,
      241,  241,  232,   23,  242,  242,  237,  237,  243,  243,
      244,  244,  232,  232,  232,  232,  245,  232,  232,  246,
      247,  232,  248,  232,  232,  232,  232,  232,  232,  232,
      249,  250,  232,  251,  232,  232,  232,  232,  252,  253,
      254,  232,  255,  232,  232,  232,  232,  232,  232,  256,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  250,
      232,  232,  257,  258,  232,  259,  250,  232,  260,  232,
      232,  261,  260,  232,  262,  232,  232,  263,  232,  232,

      232,  264,  232,  232,  265,  266,  232,  232,  245,  267,
      232,  232,  232,  246,  232,  232,  268,  232,  232,  232,
      232,  232,  269,  248,  232,  232,  270,  232,  232,  249,
      249,  232,  232,  271,  232,  271,  232,  251,  232,  232,
      270,  272,  273,  252,  253,  232,  254,  232,  255,  232,
      232,  256,  232,  232,  232,  232,  232,  232,  260,  261,
      232,  261,  232,  262,  263,  232,  264,  232,  266,  274,
      275,  268,  232,  232,  232,  232,  275,  232,  269,  232,
      270,  232,  232,  232,  249,  232,  271,  136,  232,  232,
      273,  270,  272,  273,  232,  232,  163,  232,  163,  274,

      275,  232,  232,  232,  232,  275,  232,  232,  249,  276,
      277,  278,  232,  232,  232,  232,  232,  249,  276,  232,
      277,  232,  278,  232,  232,  232,  232,  232,  232,  232,
      232,    0,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232
       );

      yy_nxt : constant array (0 .. 1045) of Short :=
          (0,
       34,   35,   36,   35,   35,   34,   34,   34,   34,   34,
       34,   34,   34,   34,   34,   34,   34,   34,   34,   34,
       34,   34,   37,   37,   37,   37,   37,   37,   37,   37,
       37,   37,   37,   37,   37,   37,   37,   37,   37,   34,
       34,   34,   34,   38,   39,   38,   38,   34,   40,   34,
       41,   34,   34,   34,   42,   34,   34,   34,   34,   34,
       34,   34,   34,   34,   43,   43,   43,   43,   43,   43,
       43,   43,   43,   43,   43,   43,   43,   43,   43,   43,
       43,   34,   34,   34,   45,   46,   45,   45,   47,  170,
       48,  128,  128,   49,  128,   78,   49,   49,   79,   50,

      231,   51,   52,   64,   65,   64,   64,   64,   65,   64,
       64,  100,   80,  100,  230,   78,  229,  103,   79,  161,
      104,  171,   53,   49,   54,   55,   54,   54,   47,  162,
       48,   56,   80,   49,  105,   57,   49,   49,   67,   50,
      224,   51,   52,   67,   58,  131,  184,  222,   82,  173,
      101,  220,  101,   86,  228,   83,  150,   84,  150,  150,
       87,   88,   53,   49,   66,   66,   67,   66,   66,   66,
       66,   66,   66,   66,   66,   68,   66,   66,   66,   66,
       66,   69,   66,   66,   66,   66,   70,   70,   70,   70,
       70,   70,   70,   70,   70,   70,   70,   70,   70,   70,

       70,   70,   70,   66,   66,   66,   73,   73,   67,  103,
      227,   67,  104,  117,  182,   74,   74,  185,   82,   75,
       75,   86,  130,  226,  192,   83,  105,   84,   87,   88,
      107,  108,  107,  107,  161,  150,  118,  150,  150,  119,
      225,  120,  121,  122,  162,   76,   76,   89,   89,   90,
       89,   89,   91,   89,   89,   89,   92,   89,   89,   93,
       89,   94,   89,   89,   89,   89,   89,   89,   89,   95,
       95,   95,   95,   95,   95,   95,   95,   95,   95,   95,
       95,   95,   95,   95,   95,   95,   96,   89,   97,  111,
      112,  111,  111,  125,  126,  125,  125,  131,  184,  224,

      113,  107,  108,  107,  107,  111,  112,  111,  111,  176,
      209,  176,  176,  195,  131,  184,  113,  206,  202,  206,
      206,  182,  222,  211,  206,  202,  206,  206,  220,  217,
      216,  212,  127,  134,  134,  215,  134,  134,  134,  134,
      134,  134,  134,  134,  134,  134,  134,  134,  135,  134,
      134,  134,  134,  134,  134,  136,  136,  136,  136,  136,
      136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
      136,  136,  134,  134,  134,  138,  139,  138,  138,  176,
      218,  176,  177,  214,  131,  184,  140,  125,  126,  125,
      125,  213,  138,  139,  138,  138,  176,  202,  176,  176,

      110,  154,  195,  140,  210,  132,  208,  182,  180,  207,
      205,  204,  203,  202,  141,  110,  178,  166,  196,  153,
      148,  145,  195,  191,  190,  186,  127,  188,  183,  182,
      188,  141,  110,  180,  175,  174,  171,  188,  188,  188,
      188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
      188,  188,  188,  188,  115,  123,  189,  197,  197,  198,
      197,  197,  199,  197,  197,  197,  199,  197,  197,  197,
      197,  199,  197,  197,  197,  197,  197,  197,  197,  199,
      199,  199,  199,  199,  199,  199,  199,  199,  199,  199,
      199,  199,  199,  199,  199,  199,  199,  197,  199,  199,

      199,  110,  199,  199,  166,  199,  199,  199,  163,  199,
      199,  199,  199,  133,  199,  199,  199,  199,  199,  199,
      199,  157,  155,  133,  153,  151,  148,  145,  143,  142,
      133,  131,  129,  110,  123,  115,  110,  232,   67,  199,
       44,   44,   44,   44,   44,   44,   44,   44,   44,   44,
       44,   59,   59,   59,   59,   59,   59,   59,   59,   59,
       59,   59,   61,   61,   61,   61,   61,   61,   61,   61,
       61,   61,   61,   63,   63,   63,   63,   63,   63,   63,
       63,   63,   63,   63,   67,   67,   67,   67,   67,   67,
       67,   67,   67,   67,   67,   72,   72,   72,   72,   72,

       72,   72,   72,   72,   72,   72,   77,   77,   77,   77,
       77,   77,   77,   77,   77,   77,   77,   81,   81,   81,
       81,   81,   81,   81,   81,   81,   81,   81,   85,   85,
       85,   85,   85,   85,   85,   85,   85,   85,   85,   98,
       98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
      102,  102,  102,  102,  102,  102,  102,  102,  102,  102,
      102,  106,  106,  106,  106,  106,  106,  106,  106,  106,
      106,  106,  109,  109,   67,   99,  109,  114,  114,  114,
      114,  114,  114,  114,  114,  114,  114,  114,  116,  116,
      116,  116,  116,  116,  116,  116,  116,  116,  116,  124,

      124,   99,   71,  124,  130,  130,   71,  130,  130,  130,
      130,  130,   62,  130,  130,  132,  132,   62,  132,  132,
      132,  132,  132,  132,  132,  132,  137,  137,  137,  137,
      137,  137,  137,  137,  137,  137,  137,  144,  144,  144,
      144,  144,  144,  144,  144,  144,  144,  144,  146,   60,
       60,  146,  146,  146,  146,  146,  146,  146,  146,  147,
      147,  147,  147,  147,  147,  147,  147,  147,  147,  147,
      149,  149,  232,  149,  149,  149,  149,  149,  149,  149,
      149,  152,  232,  232,  232,  152,  154,  154,  232,  154,
      154,  154,  154,  154,  154,  154,  154,  156,  156,  232,

      156,  156,  156,  156,  156,  156,  156,  156,  158,  158,
      232,  158,  158,  158,  158,  158,  232,  158,  158,  159,
      159,  232,  232,  232,  159,  159,  159,  159,  160,  160,
      232,  160,  160,  160,  160,  160,  160,  160,  160,  164,
      232,  232,  232,  164,  165,  165,  165,  165,  165,  165,
      165,  165,  165,  165,  165,  167,  167,  232,  232,  167,
      167,  167,  232,  167,  167,  167,  168,  168,  232,  168,
      168,  168,  168,  168,  168,  168,  168,  169,  169,  232,
      169,  169,  169,  169,  169,  169,  169,  169,  172,  172,
      232,  172,  172,  172,  172,  172,  172,  172,  172,  179,

      179,  179,  179,  179,  179,  179,  179,  179,  179,  179,
      181,  181,  181,  181,  181,  181,  181,  181,  181,  181,
      181,  187,  187,  232,  187,  187,  187,  187,  187,  187,
      187,  193,  193,  232,  193,  193,  193,  193,  193,  193,
      193,  193,  194,  194,  194,  194,  194,  194,  194,  194,
      194,  194,  194,  200,  200,  232,  232,  200,  201,  201,
      201,  201,  201,  201,  201,  201,  201,  201,  201,  219,
      219,  219,  219,  219,  219,  219,  219,  219,  219,  219,
      221,  221,  221,  221,  221,  221,  221,  221,  221,  221,
      221,  223,  223,  223,  223,  223,  223,  223,  223,  223,

      223,  223,   33,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232
       );

      yy_chk : constant array (0 .. 1045) of Short :=
          (0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
        2,    2,    2,    2,    3,    3,    3,    3,    3,  267,
        3,   48,   48,    3,   48,   17,    3,    3,   17,    3,

      228,    3,    3,    9,    9,    9,    9,   10,   10,   10,
       10,   27,   17,   28,  227,   18,  225,   29,   18,   92,
       29,  118,    3,    3,    4,    4,    4,    4,    4,   92,
        4,    4,   18,    4,   29,    4,    4,    4,   19,    4,
      223,    4,    4,   21,    4,  130,  130,  221,   19,  118,
       27,  219,   28,   21,  217,   19,   64,   19,   64,   64,
       21,   21,    4,    4,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
       11,   11,   11,   11,   11,   11,   11,   11,   11,   11,

       11,   11,   11,   11,   11,   11,   15,   16,   20,   30,
      216,   22,   30,   41,  141,   15,   16,  131,   20,   15,
       16,   22,  131,  214,  141,   20,   30,   20,   22,   22,
       35,   35,   35,   35,  160,  150,   41,  150,  150,   41,
      213,   41,   41,   41,  160,   15,   16,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   38,
       38,   38,   38,   45,   45,   45,   45,  218,  218,  212,

       38,  107,  107,  107,  107,  111,  111,  111,  111,  176,
      185,  176,  176,  191,  185,  185,  111,  177,  177,  177,
      177,  192,  211,  191,  206,  206,  206,  206,  210,  208,
      207,  192,   45,   53,   53,  205,   53,   53,   53,   53,
       53,   53,   53,   53,   53,   53,   53,   53,   53,   53,
       53,   53,   53,   53,   53,   53,   53,   53,   53,   53,
       53,   53,   53,   53,   53,   53,   53,   53,   53,   53,
       53,   53,   53,   53,   53,   54,   54,   54,   54,  122,
      209,  122,  122,  204,  209,  209,   54,  125,  125,  125,
      125,  203,  138,  138,  138,  138,  230,  201,  230,  230,

      200,  196,  194,  138,  190,  186,  183,  181,  179,  178,
      175,  174,  173,  171,   54,  170,  122,  165,  155,  153,
      147,  144,  143,  140,  137,  133,  125,  136,  129,  127,
      136,  138,  124,  123,  120,  119,  116,  136,  136,  136,
      136,  136,  136,  136,  136,  136,  136,  136,  136,  136,
      136,  136,  136,  136,  114,  113,  136,  163,  163,  163,
      163,  163,  163,  163,  163,  163,  163,  163,  163,  163,
      163,  163,  163,  163,  163,  163,  163,  163,  163,  163,
      163,  163,  163,  163,  163,  163,  163,  163,  163,  163,
      163,  163,  163,  163,  163,  163,  163,  163,  163,  199,

      199,  109,  199,  199,   98,  199,  199,  199,   93,  199,
      199,  199,  199,   87,  199,  199,  199,  199,  199,  199,
      199,   84,   83,   80,   75,   69,   61,   59,   57,   56,
       52,   51,   50,   43,   42,   40,   37,   33,   32,  199,
      233,  233,  233,  233,  233,  233,  233,  233,  233,  233,
      233,  234,  234,  234,  234,  234,  234,  234,  234,  234,
      234,  234,  235,  235,  235,  235,  235,  235,  235,  235,
      235,  235,  235,  236,  236,  236,  236,  236,  236,  236,
      236,  236,  236,  236,  237,  237,  237,  237,  237,  237,
      237,  237,  237,  237,  237,  238,  238,  238,  238,  238,

      238,  238,  238,  238,  238,  238,  239,  239,  239,  239,
      239,  239,  239,  239,  239,  239,  239,  240,  240,  240,
      240,  240,  240,  240,  240,  240,  240,  240,  241,  241,
      241,  241,  241,  241,  241,  241,  241,  241,  241,  242,
      242,  242,  242,  242,  242,  242,  242,  242,  242,  242,
      243,  243,  243,  243,  243,  243,  243,  243,  243,  243,
      243,  244,  244,  244,  244,  244,  244,  244,  244,  244,
      244,  244,  245,  245,   31,   26,  245,  246,  246,  246,
      246,  246,  246,  246,  246,  246,  246,  246,  247,  247,
      247,  247,  247,  247,  247,  247,  247,  247,  247,  248,

      248,   25,   14,  248,  249,  249,   13,  249,  249,  249,
      249,  249,    8,  249,  249,  250,  250,    7,  250,  250,
      250,  250,  250,  250,  250,  250,  251,  251,  251,  251,
      251,  251,  251,  251,  251,  251,  251,  252,  252,  252,
      252,  252,  252,  252,  252,  252,  252,  252,  253,    6,
        5,  253,  253,  253,  253,  253,  253,  253,  253,  254,
      254,  254,  254,  254,  254,  254,  254,  254,  254,  254,
      255,  255,    0,  255,  255,  255,  255,  255,  255,  255,
      255,  256,    0,    0,    0,  256,  257,  257,    0,  257,
      257,  257,  257,  257,  257,  257,  257,  258,  258,    0,

      258,  258,  258,  258,  258,  258,  258,  258,  259,  259,
        0,  259,  259,  259,  259,  259,    0,  259,  259,  260,
      260,    0,    0,    0,  260,  260,  260,  260,  261,  261,
        0,  261,  261,  261,  261,  261,  261,  261,  261,  262,
        0,    0,    0,  262,  263,  263,  263,  263,  263,  263,
      263,  263,  263,  263,  263,  264,  264,    0,    0,  264,
      264,  264,    0,  264,  264,  264,  265,  265,    0,  265,
      265,  265,  265,  265,  265,  265,  265,  266,  266,    0,
      266,  266,  266,  266,  266,  266,  266,  266,  268,  268,
        0,  268,  268,  268,  268,  268,  268,  268,  268,  269,

      269,  269,  269,  269,  269,  269,  269,  269,  269,  269,
      270,  270,  270,  270,  270,  270,  270,  270,  270,  270,
      270,  271,  271,    0,  271,  271,  271,  271,  271,  271,
      271,  272,  272,    0,  272,  272,  272,  272,  272,  272,
      272,  272,  273,  273,  273,  273,  273,  273,  273,  273,
      273,  273,  273,  274,  274,    0,    0,  274,  275,  275,
      275,  275,  275,  275,  275,  275,  275,  275,  275,  276,
      276,  276,  276,  276,  276,  276,  276,  276,  276,  276,
      277,  277,  277,  277,  277,  277,  277,  277,  277,  277,
      277,  278,  278,  278,  278,  278,  278,  278,  278,  278,

      278,  278,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232,  232,  232,  232,  232,  232,
      232,  232,  232,  232,  232
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
               if yy_current_state >= 233 then
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
                  if yy_current_state >= 233 then
                     yy_c := yy_meta (yy_c);
                  end if;
               end loop;
               yy_current_state := yy_nxt (yy_base (yy_current_state) + yy_c);
            yy_cp := yy_cp + 1;
            if yy_current_state = 232 then
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
--# line 59 "ascan.l"
             indented_code := True; 

         when 2 =>
--# line 60 "ascan.l"
             linenum := linenum + 1; ECHO;
                -- treat as a comment;
            

         when 3 =>
--# line 63 "ascan.l"
             linenum := linenum + 1; ECHO; 

         when 4 =>
--# line 64 "ascan.l"
             return SCDECL; 

         when 5 =>
--# line 65 "ascan.l"
             return XSCDECL; 

         when 6 =>
--# line 66 "ascan.l"
             return USCDECL; 

         when 7 =>
--# line 67 "ascan.l"
             return OPTDECL; 

         when 8 =>
--# line 68 "ascan.l"
             ENTER(YYDECL_STRING); return YYDECL; 

         when 9 =>
--# line 70 "ascan.l"
             return WHITESPACE; 

         when 10 =>
--# line 72 "ascan.l"
            
            sectnum := 2;
            misc.line_directive_out;
            ENTER(SECT2PROLOG);
            return SECTEND;
            

         when 11 =>
--# line 79 "ascan.l"
            
            Ada.Text_IO.Put( Standard_Error, "old-style lex command at line " );
            int_io.put( Standard_Error, linenum );
            Ada.Text_IO.Put( Standard_Error, " ignored:" );
            text_io.new_line( Standard_Error );
            Ada.Text_IO.Put( Standard_Error, ASCII.HT );
            Ada.Text_IO.Put( Standard_Error, yytext(1..YYLength) );
            linenum := linenum + 1;
            

         when 12 =>
--# line 89 "ascan.l"
            
            nmstr := vstr(yytext(1..YYLength));
            didadef := False;
            ENTER(PICKUPDEF);
            

         when 13 =>
--# line 95 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return UNAME;
            

         when 14 =>
--# line 99 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 15 =>
--# line 102 "ascan.l"
             linenum := linenum + 1;
              -- allows blank lines in section 1;
            

         when 16 =>
--# line 105 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 17 =>
--# line 106 "ascan.l"
             misc.synerr( "illegal character" );ENTER(RECOVER);

         when 18 =>
--# line 107 "ascan.l"
            
               nmstr := vstr(yytext(1..YYLength));
               ENTER(0);
               return NAME;
            

         when 19 =>
--# line 112 "ascan.l"
             null;
              -- separates name and definition;
            

         when 20 =>
--# line 116 "ascan.l"
            
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
            

         when 21 =>
--# line 133 "ascan.l"
            
            if not didadef then
                misc.synerr( "incomplete name definition" );
            end if;
            ENTER(0);
            linenum := linenum + 1;
            

         when 22 =>
--# line 141 "ascan.l"
             linenum := linenum + 1;
              ENTER(0);
              nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 23 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_cp - 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 147 "ascan.l"
            
            linenum := linenum + 1;
            ACTION_ECHO;
            MARK_END_OF_PROLOG;
            ENTER(SECT2);
            

         when 24 =>
--# line 154 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

   when YY_END_OF_BUFFER +SECT2PROLOG + 1 
 =>
--# line 156 "ascan.l"
 MARK_END_OF_PROLOG;
              return End_Of_Input;
            

         when 26 =>
--# line 160 "ascan.l"
             linenum := linenum + 1;
              -- allow blank lines in sect2;

            -- this rule matches indented lines which
            -- are not comments.
         when 27 =>
--# line 165 "ascan.l"
            
            misc.synerr("indented code found outside of action");
            linenum := linenum + 1;
            

         when 28 =>
--# line 170 "ascan.l"
             ENTER(SC); return ( '<' ); 

         when 29 =>
--# line 171 "ascan.l"
             return ( '^' );  

         when 30 =>
--# line 172 "ascan.l"
             ENTER(QUOTE); return ( '"' ); 

         when 31 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 173 "ascan.l"
             ENTER(NUM); return ( '{' ); 

         when 32 =>
--# line 174 "ascan.l"
             ENTER(BRACEERROR); 

         when 33 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 175 "ascan.l"
             return '$'; 

         when 34 =>
--# line 177 "ascan.l"
             continued_action := True;
              linenum := linenum + 1;
              return Newline;
            

         when 35 =>
--# line 182 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 36 =>
--# line 184 "ascan.l"
            
            -- this rule is separate from the one below because
            -- otherwise we get variable trailing context, so
            -- we can't build the scanner using -f,F

            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            

         when 37 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_cp - 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 195 "ascan.l"
            
            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            

         when 38 =>
--# line 202 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 39 =>
--# line 204 "ascan.l"
             return EOF_OP; 

         when 40 =>
--# line 206 "ascan.l"
            
            sectnum := 3;
            ENTER(SECT3);
            return End_Of_Input;
            -- to stop the parser
            

         when 41 =>
--# line 213 "ascan.l"
            

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
            

         when 42 =>
--# line 238 "ascan.l"
            
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
            

         when 43 =>
--# line 255 "ascan.l"
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
            

         when 44 =>
--# line 269 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 45 =>
--# line 273 "ascan.l"
             linenum := linenum + 1; return Newline; 

         when 46 =>
--# line 276 "ascan.l"
             return ( ',' ); 

         when 47 =>
--# line 277 "ascan.l"
             ENTER(SECT2); return ( '>' ); 

         when 48 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 278 "ascan.l"
             ENTER(CARETISBOL); return ( '>' ); 

         when 49 =>
--# line 279 "ascan.l"
             nmstr := vstr(yytext(1..YYLength));
              return NAME;
            

         when 50 =>
--# line 282 "ascan.l"
             misc.synerr( "bad start condition name" ); 

         when 51 =>
--# line 284 "ascan.l"
             ENTER(SECT2); return '^'; 

         when 52 =>
--# line 287 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 53 =>
--# line 291 "ascan.l"
             ENTER(SECT2); return '"'; 

         when 54 =>
--# line 293 "ascan.l"
            
            misc.synerr( "missing quote" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '"';
            

         when 55 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 301 "ascan.l"
             ENTER(CCL); return '^'; 

         when 56 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 302 "ascan.l"
             return '^'; 

         when 57 =>
--# line 303 "ascan.l"
             ENTER(CCL); YYLVal := CHARACTER'POS('-'); return ( CHAR ); 

         when 58 =>
--# line 304 "ascan.l"
             ENTER(CCL);
              tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 59 =>
            yy_ch_buf (yy_cp) := yy_hold_char; -- undo effects of setting up yytext
            yy_cp := yy_bp + 1;
            yy_c_buf_p := yy_cp;
            YY_DO_BEFORE_ACTION; -- set up yytext again
--# line 310 "ascan.l"
             return '-'; 

         when 60 =>
--# line 311 "ascan.l"
             tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            

         when 61 =>
--# line 315 "ascan.l"
             ENTER(SECT2); return ']'; 

         when 62 =>
--# line 318 "ascan.l"
            
            YYLVal := misc.myctoi( vstr(yytext(1..YYLength)) );
            return NUMBER;
            

         when 63 =>
--# line 323 "ascan.l"
             return ','; 

         when 64 =>
--# line 324 "ascan.l"
             ENTER(SECT2); return '}'; 

         when 65 =>
--# line 326 "ascan.l"
            
            misc.synerr( "bad character inside {}'s" );
            ENTER(SECT2);
            return '}';
            

         when 66 =>
--# line 332 "ascan.l"
            
            misc.synerr( "missing }" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '}';
            

         when 67 =>
--# line 340 "ascan.l"
             misc.synerr( "bad name in {}'s" ); ENTER(SECT2); 

         when 68 =>
--# line 341 "ascan.l"
             misc.synerr( "missing }" );
              linenum := linenum + 1;
              ENTER(SECT2);
            

         when 69 =>
--# line 346 "ascan.l"
             bracelevel := bracelevel + 1; 

         when 70 =>
--# line 347 "ascan.l"
             bracelevel := bracelevel - 1; 

         when 71 =>
--# line 348 "ascan.l"
             ACTION_ECHO; 

         when 72 =>
--# line 349 "ascan.l"
             ACTION_ECHO; 

         when 73 =>
--# line 350 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 74 =>
--# line 351 "ascan.l"
             ACTION_ECHO;
                  -- character constant;
            

         when 75 =>
--# line 355 "ascan.l"
             ACTION_ECHO; ENTER(ACTION_STRING); 

         when 76 =>
--# line 357 "ascan.l"
            
            linenum := linenum + 1;
            ACTION_ECHO;
            if bracelevel = 0 then
                text_io.new_line ( temp_action_file );
                ENTER(SECT2);
                    end if;
            

         when 77 =>
--# line 365 "ascan.l"
             ACTION_ECHO; 

         when 78 =>
--# line 367 "ascan.l"
             ACTION_ECHO; 

         when 79 =>
--# line 368 "ascan.l"
             ACTION_ECHO; 

         when 80 =>
--# line 369 "ascan.l"
             linenum := linenum + 1; ACTION_ECHO; 

         when 81 =>
--# line 370 "ascan.l"
             ACTION_ECHO; ENTER(ACTION); 

         when 82 =>
--# line 371 "ascan.l"
             ACTION_ECHO; 

         when 83 =>
--# line 374 "ascan.l"
            
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            return ( CHAR );
            

         when 84 =>
--# line 379 "ascan.l"
            
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            ENTER(CCL);
            return CHAR;
            

         when 85 =>
--# line 386 "ascan.l"
             if check_yylex_here then
                return End_Of_Input;
              else
                ECHO;
              end if;
            

         when 86 =>
--# line 392 "ascan.l"
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
              YY_END_OF_BUFFER + ACTION_STRING + 1 |
              YY_END_OF_BUFFER + YYDECL_STRING + 1 =>
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
--# line 392 "ascan.l"
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

