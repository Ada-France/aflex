pragma Style_Checks (Off);
package Parse_Goto is

    type Small_Integer is range -32_000 .. 32_000;

    type Goto_Entry is record
        Nonterm  : Small_Integer;
        Newstate : Small_Integer;
    end record;

  --pragma suppress(index_check);

    subtype Row is Integer range -1 .. Integer'Last;

    type Goto_Parse_Table is array (Row range <>) of Goto_Entry;

    Goto_Matrix : constant Goto_Parse_Table :=
       ((-1,-1)  -- Dummy Entry.
-- State  0
,(-3,1),(-2,2)
-- State  1
,(-4,3)
-- State  3
,(-8,10),(-5,9)
-- State  9
,(-6,14)
-- State  14
,(-7,18)
-- State  15
,(-9,19)
-- State  16
,(-10,24)
-- State  17
,(-10,25)
-- State  18
,(-19,36),(-18,34),(-17,32),(-16,33),(-13,28),(-12,26),(-11,42)
-- State  26
,(-19,36),(-18,34),(-17,32),(-16,33),(-13,47)
-- State  27
,(-19,36),(-18,34),(-17,32),(-16,33),(-13,50)
-- State  28
,(-14,52)
-- State  31
,(-15,55)
-- State  32
,(-19,36),(-18,34),(-16,58)
-- State  33
,(-19,36),(-18,59)
-- State  38
,(-20,64)
-- State  39
,(-19,36),(-18,34),(-17,32),(-16,33),(-13,65)
-- State  41
,(-21,66)
-- State  47
,(-14,70)
-- State  48
,(-19,36),(-18,34),(-17,32),(-16,33),(-13,71)
-- State  50
,(-14,72)
-- State  53
,(-19,36),(-18,34),(-16,73)
-- State  58
,(-19,36),(-18,59)
-- State  67
,(-21,82)
-- State  71
,(-14,83)
-- State  73
,(-19,36),(-18,59)
);
--  The offset vector
GOTO_OFFSET : array (0.. 92) of Integer :=
(0,
2,3,3,5,5,5,5,5,5,6,6,6,6,6,7,8,9,
10,17,17,17,17,17,17,17,17,22,27,28,28,28,29,32,34,
34,34,34,34,35,40,40,41,41,41,41,41,41,42,47,47,48,
48,48,51,51,51,51,51,53,53,53,53,53,53,53,53,53,54,
54,54,54,55,55,57,57,57,57,57,57,57,57,57,57,57,57,
57,57,57,57,57,57, 57);

subtype Rule        is Natural;
subtype Nonterminal is Integer;

   Rule_Length : array (Rule range  0 ..  56) of Natural := (2,
5,0,5,5,5,0,2,1,1,1,1,1,3,1,1,4,0,0,4,3,3,2,2,1,1,3,3,1,1,1,0,3,2,1,2,2,1,
2,2,2,6,5,4,1,1,1,3,3,1,3,4,4,2,0,2,0);
   Get_LHS_Rule: array (Rule range  0 ..  56) of Nonterminal := (-1,
-2,-3,-4,-4,-4,-4,-4,-10,-10,-5,-8,-8,-9,-9,
-9,-6,-6,-7,-11,-11,-11,-11,-11,-11,-11,-12,-15,-15,
-15,-14,-14,-13,-13,-13,-17,-16,-16,-18,-18,-18,-18,-18,
-18,-18,-18,-18,-18,-18,-18,-19,-19,-21,-21,-21,-20,-20);
end Parse_Goto;
