private package Parse_Goto is


   type Rule        is new Natural;
   type Nonterminal is new Integer;

   type Small_Integer is range -32_000 .. 32_000;
   subtype Small_Nonterminal is Nonterminal range -32_000 .. 32_000;

   type Goto_Entry is record
      Nonterm  : Small_Nonterminal;
      Newstate : Small_Integer;
   end record;

   --  pragma suppress(index_check);

   type Row is new Integer range -1 .. Integer'Last;

   type Goto_Parse_Table is array (Row range <>) of Goto_Entry;

   Goto_Matrix : constant Goto_Parse_Table :=
      ((-1, -1)  -- Dummy Entry.
      --  State  0
      , (-3, 1), (-2, 2)
      --  State  1
      , (-4, 3)
      --  State  3
      , (-8, 10), (-5, 9)
      --  State  9
      , (-6, 17)
      --  State  17
      , (-7, 24)
      --  State  18
      , (-9, 25)
      --  State  19
      , (-10, 30)
      --  State  20
      , (-10, 31)
      --  State  24
      , (-19, 45), (-18, 43), (-17, 41), (-16, 42), (-13, 37)
      , (-12, 35), (-11, 51)
      --  State  35
      , (-19, 45), (-18, 43), (-17, 41), (-16, 42), (-13, 58)
            --  State  36
      , (-19, 45), (-18, 43), (-17, 41), (-16, 42), (-13, 61)
            --  State  37
      , (-14, 63)
      --  State  40
      , (-15, 66)
      --  State  41
      , (-19, 45), (-18, 43), (-16, 69)
      --  State  42
      , (-19, 45), (-18, 70)
      --  State  47
      , (-20, 75)
      --  State  48
      , (-19, 45), (-18, 43), (-17, 41), (-16, 42), (-13, 76)
            --  State  50
      , (-21, 77)
      --  State  58
      , (-14, 81)
      --  State  59
      , (-19, 45), (-18, 43), (-17, 41), (-16, 42), (-13, 82)
            --  State  61
      , (-14, 83)
      --  State  64
      , (-19, 45), (-18, 43), (-16, 84)
      --  State  69
      , (-19, 45), (-18, 70)
      --  State  78
      , (-21, 93)
      --  State  82
      , (-14, 94)
      --  State  84
      , (-19, 45), (-18, 70)
      );

   --  The offset vector
   Goto_Offset : constant array (0 .. 103) of Row :=
      (0,
      2, 3, 3, 5, 5, 5, 5, 5, 5, 6,
      6, 6, 6, 6, 6, 6, 6, 7, 8, 9,
      10, 10, 10, 10, 17, 17, 17, 17, 17, 17,
      17, 17, 17, 17, 17, 22, 27, 28, 28, 28,
      29, 32, 34, 34, 34, 34, 34, 35, 40, 40,
      41, 41, 41, 41, 41, 41, 41, 41, 42, 47,
      47, 48, 48, 48, 51, 51, 51, 51, 51, 53,
      53, 53, 53, 53, 53, 53, 53, 53, 54, 54,
      54, 54, 55, 55, 57, 57, 57, 57, 57, 57,
      57, 57, 57, 57, 57, 57, 57, 57, 57, 57,
      57, 57, 57);

   Rule_Length : constant array (Rule range 0 .. 60) of Natural := (2,
      5, 0, 5, 5, 5, 5, 4, 5, 3, 0, 2, 1, 1, 1, 1, 1, 3, 1, 1, 4, 0, 0, 4,
      3, 3, 2, 2, 1, 1, 3, 3, 1, 1, 1, 0, 3, 2, 1, 2, 2, 1, 2, 2, 2, 6, 5,
      4, 1, 1, 1, 3, 3, 1, 3, 4, 4, 2, 0, 2, 0);

   Get_LHS_Rule : constant array (Rule range 0 .. 60) of Nonterminal := (-1,
       -2, -3, -4, -4, -4, -4, -4, -4, -4, -4, -4, -10, -10, -5,
       -8, -8, -9, -9, -9, -6, -6, -7, -11, -11, -11, -11, -11, -11,
       -11, -12, -15, -15, -15, -14, -14, -13, -13, -13, -17, -16, -16, -18,
       -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -19, -19, -21,
       -21, -21, -20, -20);

end Parse_Goto;
