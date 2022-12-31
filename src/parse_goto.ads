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
      , (-6, 15)
      --  State  15
      , (-7, 20)
      --  State  16
      , (-9, 21)
      --  State  17
      , (-10, 26)
      --  State  18
      , (-10, 27)
      --  State  20
      , (-19, 39), (-18, 37), (-17, 35), (-16, 36), (-13, 31)
      , (-12, 29), (-11, 45)
      --  State  29
      , (-19, 39), (-18, 37), (-17, 35), (-16, 36), (-13, 50)
            --  State  30
      , (-19, 39), (-18, 37), (-17, 35), (-16, 36), (-13, 53)
            --  State  31
      , (-14, 55)
      --  State  34
      , (-15, 58)
      --  State  35
      , (-19, 39), (-18, 37), (-16, 61)
      --  State  36
      , (-19, 39), (-18, 62)
      --  State  41
      , (-20, 67)
      --  State  42
      , (-19, 39), (-18, 37), (-17, 35), (-16, 36), (-13, 68)
            --  State  44
      , (-21, 69)
      --  State  50
      , (-14, 73)
      --  State  51
      , (-19, 39), (-18, 37), (-17, 35), (-16, 36), (-13, 74)
            --  State  53
      , (-14, 75)
      --  State  56
      , (-19, 39), (-18, 37), (-16, 76)
      --  State  61
      , (-19, 39), (-18, 62)
      --  State  70
      , (-21, 85)
      --  State  74
      , (-14, 86)
      --  State  76
      , (-19, 39), (-18, 62)
      );

   --  The offset vector
   Goto_Offset : constant array (0 .. 95) of Row :=
      (0,
      2, 3, 3, 5, 5, 5, 5, 5, 5, 6,
      6, 6, 6, 6, 6, 7, 8, 9, 10, 10,
      17, 17, 17, 17, 17, 17, 17, 17, 17, 22,
      27, 28, 28, 28, 29, 32, 34, 34, 34, 34,
      34, 35, 40, 40, 41, 41, 41, 41, 41, 41,
      42, 47, 47, 48, 48, 48, 51, 51, 51, 51,
      51, 53, 53, 53, 53, 53, 53, 53, 53, 53,
      54, 54, 54, 54, 55, 55, 57, 57, 57, 57,
      57, 57, 57, 57, 57, 57, 57, 57, 57, 57,
      57, 57, 57, 57, 57);

   Rule_Length : constant array (Rule range 0 .. 57) of Natural := (2,
      5, 0, 5, 5, 5, 4, 0, 2, 1, 1, 1, 1, 1, 3, 1, 1, 4, 0, 0, 4, 3, 3, 2,
      2, 1, 1, 3, 3, 1, 1, 1, 0, 3, 2, 1, 2, 2, 1, 2, 2, 2, 6, 5, 4, 1, 1,
      1, 3, 3, 1, 3, 4, 4, 2, 0, 2, 0);

   Get_LHS_Rule : constant array (Rule range 0 .. 57) of Nonterminal := (-1,
       -2, -3, -4, -4, -4, -4, -4, -4, -10, -10, -5, -8, -8, -9,
       -9, -9, -6, -6, -7, -11, -11, -11, -11, -11, -11, -11, -12, -15,
       -15, -15, -14, -14, -13, -13, -13, -17, -16, -16, -18, -18, -18, -18,
       -18, -18, -18, -18, -18, -18, -18, -18, -19, -19, -21, -21, -21, -20,
       -20);

end Parse_Goto;
