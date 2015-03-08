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
,(-6,13)
-- State  13
,(-7,16)
-- State  14
,(-9,17)
-- State  15
,(-10,22)
-- State  16
,(-19,33),(-18,31),(-17,29),(-16,30),(-13,25),(-12,23),(-11,39)
-- State  23
,(-19,33),(-18,31),(-17,29),(-16,30),(-13,43)
-- State  24
,(-19,33),(-18,31),(-17,29),(-16,30),(-13,46)
-- State  25
,(-14,48)
-- State  28
,(-15,51)
-- State  29
,(-19,33),(-18,31),(-16,54)
-- State  30
,(-19,33),(-18,55)
-- State  35
,(-20,60)
-- State  36
,(-19,33),(-18,31),(-17,29),(-16,30),(-13,61)
-- State  38
,(-21,62)
-- State  43
,(-14,66)
-- State  44
,(-19,33),(-18,31),(-17,29),(-16,30),(-13,67)
-- State  46
,(-14,68)
-- State  49
,(-19,33),(-18,31),(-16,69)
-- State  54
,(-19,33),(-18,55)
-- State  63
,(-21,78)
-- State  67
,(-14,79)
-- State  69
,(-19,33),(-18,55)
);
--  The offset vector
GOTO_OFFSET : array (0.. 88) of Integer :=
(0,
2,3,3,5,5,5,5,5,5,6,6,6,6,7,8,9,16,
16,16,16,16,16,16,21,26,27,27,27,28,31,33,33,33,33,
33,34,39,39,40,40,40,40,40,41,46,46,47,47,47,50,50,
50,50,50,52,52,52,52,52,52,52,52,52,53,53,53,53,54,
54,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,56,
56,56, 56);

subtype Rule        is Natural;
subtype Nonterminal is Integer;

   Rule_Length : array (Rule range  0 ..  55) of Natural := (2,
5,0,5,5,0,2,1,1,1,1,1,3,1,1,4,0,0,4,3,3,2,2,1,1,3,3,1,1,1,0,3,2,1,2,2,1,2,
2,2,6,5,4,1,1,1,3,3,1,3,4,4,2,0,2,0);
   Get_LHS_Rule: array (Rule range  0 ..  55) of Nonterminal := (-1,
-2,-3,-4,-4,-4,-4,-10,-10,-5,-8,-8,-9,-9,-9,
-6,-6,-7,-11,-11,-11,-11,-11,-11,-11,-12,-15,-15,-15,
-14,-14,-13,-13,-13,-17,-16,-16,-18,-18,-18,-18,-18,-18,
-18,-18,-18,-18,-18,-18,-19,-19,-21,-21,-21,-20,-20);
end Parse_Goto;
