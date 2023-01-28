-- Copyright (c) 1990 Regents of the University of California.
-- All rights reserved.
--
-- This software was developed by John Self of the Arcadia project
-- at the University of California, Irvine.
--
-- Redistribution and use in source and binary forms are permitted
-- provided that the above copyright notice and this paragraph are
-- duplicated in all such forms and that any documentation,
-- advertising materials, and other materials related to such
-- distribution and use acknowledge that the software was developed
-- by the University of California, Irvine.  The name of the
-- University may not be used to endorse or promote products derived
-- from this software without specific prior written permission.
-- THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
-- IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

-- TITLE miscellaneous definitions
-- AUTHOR: John Self (UCI)
-- DESCRIPTION contains all global variables used in aflex.
--             also some subprograms which are commonly used.
-- NOTES The real purpose of this file is to contain all miscellaneous
--       items (functions, MACROS, variables definitions) which were at the
--       top level of flex.
-- $Header: /co/ua/self/arcadia/alex/ada/RCS/misc_defsS.a,v 1.8 90/01/04 13:39:
-- 33 self Exp Locker: self $

with Text_Io, Tstring;
use Text_Io, Tstring;

package Misc_Defs is

-- UMASS CODES :
   Ayacc_Extension_Flag : Boolean := False;
   -- Indicates whether or not aflex generated codes will be
   -- used by Ayacc extension. Ayacc extension has more power
   -- in error recovery. True means that generated codes will
   -- be used by Ayacc extension.
-- END OF UMASS CODES.

   -- various definitions that were in parse.y
   Pat, Scnum, Eps, Headcnt, Trailcnt, Anyccl, Lastchar, Actvp,
   Rulelen                                                       : Integer;
   Trlcontxt, Xcluflg, Cclsorted, Varlength, Variable_Trail_Rule : Boolean;

   Madeany : Boolean := False;  -- whether we've made the '.' character class
   Previous_Continued_Action : Boolean; -- whether the previous rule's action wa
   -- s '|'

   -- maximum line length we'll have to deal with
   Maxline : constant Integer := 1_024;

   -- These typees are needed for the various allocators.
   type Unbounded_Int_Array is array (Integer range <>) of Integer;
   type Int_Ptr is access Unbounded_Int_Array;
   type Int_Star is access Integer;
   type Unbounded_Int_Star_Array is array (Integer range <>) of Int_Ptr;
   type Int_Star_Ptr is access Unbounded_Int_Star_Array;
   type Unbounded_Vstring_Array is array (Integer range <>) of Vstring;
   type Vstring_Ptr is access Unbounded_Vstring_Array;
   type Boolean_Array is array (Integer range <>) of Boolean;
   type Boolean_Ptr is access Boolean_Array;
   type Char_Array is array (Integer range <>) of Character;
   type Char_Ptr is access Char_Array;

   -- different types of states; values are useful as masks, as well, for
   -- routines like check_trailing_context()

   type State_Enum is (STATE_NORMAL, STATE_TRAILING_CONTEXT);

   type Unbounded_State_Enum_Array is array (Integer range <>) of State_Enum;
   type State_Enum_Ptr is access Unbounded_State_Enum_Array;

   -- different types of rules
   type Rule_Enum is (RULE_NORMAL, RULE_VARIABLE);

   type Unbounded_Rule_Enum_Array is array (Integer range <>) of Rule_Enum;
   type Rule_Enum_Ptr is access Unbounded_Rule_Enum_Array;

   type Dfaacc_Type is record
      Dfaacc_Set   : Int_Ptr;
      Dfaacc_State : Integer;
   end record;

   type Unbounded_Dfaacc_Array is array (Integer range <>) of Dfaacc_Type;
   type Dfaacc_Ptr is access Unbounded_Dfaacc_Array;

   -- maximum size of file name

   Filenamesize : constant Integer := 1_024;

   -- special chk[] values marking the slots taking by end-of-buffer and action
   -- numbers

   Eob_Position    : constant Integer := -1;
   Action_Position : constant Integer := -2;

   -- number of data items per line for -f output
   Numdataitems : constant Integer := 10;

   -- number of lines of data in -f output before inserting a blank line for
   -- readability.

   Numdatalines : constant Integer := 10;

   -- transition_struct_out() definitions
   Trans_Struct_Print_Length : constant Integer := 15;

   -- returns true if an nfa state has an epsilon out-transition slot
   -- that can be used.  This definition is currently not used.

   function Free_Epsilon (State : in Integer) return Boolean;

   -- returns true if an nfa state has an epsilon out-transition character
   -- and both slots are free

   function Super_Free_Epsilon (State : in Integer) return Boolean;

   -- maximum number of NFA states that can comprise a DFA state.  It's real
   -- big because if there's a lot of rules, the initial state will have a
   -- huge epsilon closure.

   Initial_Max_Dfa_Size   : constant Integer := 750;
   Max_Dfa_Size_Increment : constant Integer := 750;

-- a note on the following masks.  They are used to mark accepting numbers
-- as being special.  As such, they implicitly limit the number of accepting
-- numbers (i.e., rules) because if there are too many rules the rule numbers
-- will overload the mask bits.  Fortunately, this limit is \large/ (0x2000 ==
-- 8192) so unlikely to actually cause any problems.  A check is made in
-- new_rule() to ensure that this limit is not reached.

   -- mask to mark a trailing context accepting number
   -- #define YY_TRAILING_MASK 0x2000
   Yy_Trailing_Mask : constant Integer := 16#2000#;

-- mask to mark the accepting number of the "head" of a trailing context rule
-- #define YY_TRAILING_HEAD_MASK 0x4000
   Yy_Trailing_Head_Mask : constant Integer := 16#4000#;

   -- maximum number of rules, as outlined in the above note
   Max_Rule : constant Integer := Yy_Trailing_Mask - 1;

-- NIL must be 0.  If not, its special meaning when making equivalence classes
-- (it marks the representative of a given e.c.) will be unidentifiable

   Nil : constant Integer := 0;

   Jam           : constant Integer := -1; -- to mark a missing DFA transition
   No_Transition : constant Integer := Nil;
   Unique : constant Integer := -1; -- marks a symbol as an e.c. representative
   Infinity      : constant Integer := -1; -- for x{5,} constructions

   -- size of input alphabet - should be size of ASCII set (extended to cover a full byte)
   Csize : constant Integer := 255;

   Initial_Max_Ccls : constant Integer :=
     100; -- max number of unique character
   --  classes
   Max_Ccls_Increment : constant Integer := 100;

   -- size of table holding members of character classes
   Initial_Max_Ccl_Tbl_Size   : constant Integer := 500;
   Max_Ccl_Tbl_Size_Increment : constant Integer := 250;
   Initial_Max_Rules          : constant Integer := 100;
   -- default maximum number of rules
   Max_Rules_Increment : constant Integer := 100;

   Initial_Mns : constant Integer :=
     2_000; -- default maximum number of nfa stat
   -- es
   Mns_Increment : constant Integer :=
     1_000; -- amount to bump above by if it's
   -- not enough

   Initial_Max_Dfas : constant Integer :=
     1_000; -- default maximum number of dfa
   --  states
   Max_Dfas_Increment : constant Integer := 1_000;

   Jamstate_Const : constant Integer :=
     -32_766; -- marks a reference to the sta
   -- te that always jams

   -- enough so that if it's subtracted from an NFA state number, the result
   -- is guaranteed to be negative

   Marker_Difference : constant Integer := 32_000;
   Maximum_Mns       : constant Integer := 31_999;

   -- maximum number of nxt/chk pairs for non-templates
   Initial_Max_Xpairs   : constant Integer := 2_000;
   Max_Xpairs_Increment : constant Integer := 2_000;

   -- maximum number of nxt/chk pairs needed for templates
   Initial_Max_Template_Xpairs   : constant Integer := 2_500;
   Max_Template_Xpairs_Increment : constant Integer := 2_500;

   Sym_Epsilon : constant Integer :=
     0; -- to mark transitions on the symbol eps
   -- ilon

   Initial_Max_Scs : constant Integer :=
     40; -- maximum number of start conditio
   -- ns
   Max_Scs_Increment : constant Integer := 40; -- amount to bump by if it's not
   -- enough

   One_Stack_Size : constant Integer :=
     500; -- stack of states with only one ou
   -- t-transition
   Same_Trans : constant Integer := -1; -- transition is the same as "default"
   -- entry for state

   -- the following percentages are used to tune table compression:
   --
   -- the percentage the number of out-transitions a state must be of the
   -- number of equivalence classes in order to be considered for table
   -- compaction by using protos

   Proto_Size_Percentage : constant Integer := 15;

   -- the percentage the number of homogeneous out-transitions of a state
   -- must be of the number of total out-transitions of the state in order
   -- that the state's transition table is first compared with a potential
   -- template of the most common out-transition instead of with the first
   --proto in the proto queue

   Check_Com_Percentage : constant Integer := 50;

   -- the percentage the number of differences between a state's transition
   -- table and the proto it was first compared with must be of the total
   -- number of out-transitions of the state in order to keep the first
   -- proto as a good match and not search any further

   First_Match_Diff_Percentage : constant Integer := 10;

   -- the percentage the number of differences between a state's transition
   -- table and the most similar proto must be of the state's total number
   -- of out-transitions to use the proto as an acceptable close match

   Acceptable_Diff_Percentage : constant Integer := 50;

   -- the percentage the number of homogeneous out-transitions of a state
   -- must be of the number of total out-transitions of the state in order
   -- to consider making a template from the state

   Template_Same_Percentage : constant Integer := 60;

   -- the percentage the number of differences between a state's transition
   -- table and the most similar proto must be of the state's total number
   -- of out-transitions to create a new proto from the state

   New_Proto_Diff_Percentage : constant Integer := 20;

   -- the percentage the total number of out-transitions of a state must be
   -- of the number of equivalence classes in order to consider trying to
   -- fit the transition table into "holes" inside the nxt/chk table.

   Interior_Fit_Percentage : constant Integer := 15;

   -- size of region set aside to cache the complete transition table of
   -- protos on the proto queue to enable quick comparisons

   Prot_Save_Size : constant Integer := 2_000;

   Msp : constant Integer :=
     50; -- maximum number of saved protos (protos on th
   -- e proto queue)

   -- maximum number of out-transitions a state can have that we'll rummage
   -- around through the interior of the internal fast table looking for a
   -- spot for it

   Max_Xtions_Full_Interior_Fit : constant Integer := 4;

   -- maximum number of rules which will be reported as being associated
   -- with a DFA state

   Max_Assoc_Rules : constant Integer := 100;

-- number that, if used to subscript an array, has a good chance of producing
-- an error; should be small enough to fit into a short

   Bad_Subscript : constant Integer := -32_767;

   -- Declarations for global variables.

   -- variables for symbol tables:
   -- sctbl - start-condition symbol table
   -- ndtbl - name-definition symbol table
   -- ccltab - character class text symbol table

   type Hash_Entry;
   type Hash_Link is access Hash_Entry;
   type Hash_Entry is record
      Prev, Next    : Hash_Link;
      Name, Str_Val : Vstring;
      Int_Val       : Integer;
   end record;

   type Hash_Table is array (Integer range <>) of Hash_Link;

   Name_Table_Hash_Size : constant Integer := 101;
   Start_Cond_Hash_Size : constant Integer := 101;
   Ccl_Hash_Size        : constant Integer := 101;

   subtype Ndtbl_Type is Hash_Table (0 .. Name_Table_Hash_Size - 1);
   Ndtbl : Ndtbl_Type;
   subtype Sctbl_Type is Hash_Table (0 .. Start_Cond_Hash_Size - 1);
   Sctbl : Sctbl_Type;
   subtype Ccltab_Type is Hash_Table (0 .. Ccl_Hash_Size);
   Ccltab : Ccltab_Type;

   -- variables for flags:
   -- printstats - if true (-v), dump statistics
   -- syntaxerror - true if a syntax error has been found
   -- eofseen - true if we've seen an eof in the input file
   -- ddebug - if true (-d), make a "debug" scanner
   -- trace - if true (-T), trace processing
   -- spprdflt - if true (-s), suppress the default rule
   -- interactive - if true (-I), generate an interactive scanner
   -- caseins - if true (-i), generate a case-insensitive scanner
   -- useecs - if true (-ce flag), use equivalence classes
   -- fulltbl - if true (-cf flag), don't compress the DFA state table
   -- usemecs - if true (-cm flag), use meta-equivalence classes
   -- gen_line_dirs - if true (i.e., no -L flag), generate #line directives
   -- performance_report - if true (i.e., -p flag), generate a report relating
   --   to scanner performance
   -- backtrack_report - if true (i.e., -b flag), generate "lex.backtrack" file
   --   listing backtracking states
   -- continued_action - true if this rule's action is to "fall through" to
   --                    the next rule's action (i.e., the '|' action)

   Printstats, Ddebug, Spprdflt, Interactive, Caseins, Useecs, Fulltbl,
   Usemecs, Gen_Line_Dirs, Performance_Report, Backtrack_Report, Trace,
   Eofseen, Continued_Action, Private_Package : Boolean;

   --  Generate support for yylineno
   Use_Yylineno : Boolean;

   --  When true, don't emit the Unput and YYunput methods in _IO package.
   No_Unput : Boolean;

   --  When true, don't emit the Output methods in _IO package.
   No_Output : Boolean;

   --  When true, don't emit the Input method in the _IO package.
   No_Input  : Boolean;

   --  When true, don't emit the YYWrap support in _IO package.
   No_YYWrap : Boolean;

   --  Use the reentrant templates to generate a recursive parser.
   Reentrant : Boolean;

   --  '-m' minimalist option is used.
   Minimalist_With : Boolean;

   --  The default IO buffer size (can be changed with %option bufsize=NNN).
   YYBuf_Size  : Natural := 75_000;

   Syntaxerror : Boolean;

   -- variables used in the aflex input routines:
   -- datapos - characters on current output line
   -- dataline - number of contiguous lines of data in current data
   --    statement.  Used to generate readable -f output
   -- skelfile - the skeleton file
   -- yyin - input file
   -- temp_action_file - temporary file to hold actions
   -- backtrack_file - file to summarize backtracking states to
   -- infilename - name of input file
   -- linenum - current input line number

   Datapos, Dataline, Linenum : Integer;

   Skelfile, Yyin, Temp_Action_File, Backtrack_File, Def_File : File_Type;
   Infilename                                                 : Vstring;

   -- variables for stack of states having only one out-transition:
   -- onestate - state number
   -- onesym - transition symbol
   -- onenext - target state
   -- onedef - default base entry
   -- onesp - stack pointer

   Onestate, Onesym, Onenext,
   Onedef : array (0 .. One_Stack_Size - 1) of Integer;
   Onesp  : Integer;

   -- variables for nfa machine data:
   -- current_mns - current maximum on number of NFA states
   -- num_rules - number of the last accepting state; also is number of
   --             rules created so far
   -- current_max_rules - current maximum number of rules
   -- lastnfa - last nfa state number created
   -- firstst - physically the first state of a fragment
   -- lastst - last physical state of fragment
   -- finalst - last logical state of fragment
   -- transchar - transition character
   -- trans1 - transition state
   -- trans2 - 2nd transition state for epsilons
   -- accptnum - accepting number
   -- assoc_rule - rule associated with this NFA state (or 0 if none)
   -- state_type - a STATE_xxx type identifying whether the state is part
   --              of a normal rule, the leading state in a trailing context
   --              rule (i.e., the state which marks the transition from
   --              recognizing the text-to-be-matched to the beginning of
   --              the trailing context), or a subsequent state in a trailing
   --              context rule
   -- rule_type - a RULE_xxx type identifying whether this a a ho-hum
   --             normal rule or one which has variable head & trailing
   --             context
   -- rule_linenum - line number associated with rule

   Current_Mns, Num_Rules, Current_Max_Rules, Lastnfa  : Integer;
   Firstst, Lastst, Finalst, Transchar, Trans1, Trans2 : Int_Ptr;
   Accptnum, Assoc_Rule, Rule_Linenum                  : Int_Ptr;
   Rule_Type                                           : Rule_Enum_Ptr;
   State_Type                                          : State_Enum_Ptr;

   -- global holding current type of state we're making

   Current_State_Enum : State_Enum;

   -- true if the input rules include a rule with both variable-length head
   -- and trailing context, false otherwise

   Variable_Trailing_Context_Rules : Boolean;

   -- variables for protos:
   -- numtemps - number of templates created
   -- numprots - number of protos created
   -- protprev - backlink to a more-recently used proto
   -- protnext - forward link to a less-recently used proto
   -- prottbl - base/def table entry for proto
   -- protcomst - common state of proto
   -- firstprot - number of the most recently used proto
   -- lastprot - number of the least recently used proto
   -- protsave contains the entire state array for protos

   Numtemps, Numprots, Firstprot, Lastprot : Integer;
   Protprev, Protnext, Prottbl, Protcomst  : array (0 .. Msp - 1) of Integer;
   Protsave : array (0 .. Prot_Save_Size - 1) of Integer;

   -- variables for managing equivalence classes:
   -- numecs - number of equivalence classes
   -- nextecm - forward link of Equivalence Class members
   -- ecgroup - class number or backward link of EC members
   -- nummecs - number of meta-equivalence classes (used to compress
   --   templates)
   -- tecfwd - forward link of meta-equivalence classes members
   -- * tecbck - backward link of MEC's

   Numecs, Nummecs : Integer;
   subtype C_Size_Array is Unbounded_Int_Array (0 .. Csize);
   type C_Size_Bool_Array is array (0 .. Csize) of Boolean;
   Nextecm, Ecgroup, Tecfwd, Tecbck : C_Size_Array;

   -- variables for start conditions:
   -- lastsc - last start condition created
   -- current_max_scs - current limit on number of start conditions
   -- scset - set of rules active in start condition
   -- scbol - set of rules active only at the beginning of line in a s.c.
   -- scxclu - true if start condition is exclusive
   -- sceof - true if start condition has EOF rule
   -- scname - start condition name
   -- actvsc - stack of active start conditions for the current rule

   Lastsc, Current_Max_Scs : Integer;
   Scset, Scbol            : Int_Ptr;
   Scxclu, Sceof           : Boolean_Ptr;
   Actvsc                  : Int_Ptr;
   Scname                  : Vstring_Ptr;

   -- variables for dfa machine data:
   -- current_max_dfa_size - current maximum number of NFA states in DFA
   -- current_max_xpairs - current maximum number of non-template xtion pairs
   -- current_max_template_xpairs - current maximum number of template pairs
   -- current_max_dfas - current maximum number DFA states
   -- lastdfa - last dfa state number created
   -- nxt - state to enter upon reading character
   -- chk - check value to see if "nxt" applies
   -- tnxt - internal nxt table for templates
   -- base - offset into "nxt" for given state
   -- def - where to go if "chk" disallows "nxt" entry
   -- tblend - last "nxt/chk" table entry being used
   -- firstfree - first empty entry in "nxt/chk" table
   -- dss - nfa state set for each dfa
   -- dfasiz - size of nfa state set for each dfa
   -- dfaacc - accepting set for each dfa state (or accepting number, if
   --    -r is not given)
   -- accsiz - size of accepting set for each dfa state
   -- dhash - dfa state hash value
   -- numas - number of DFA accepting states created; note that this
   --    is not necessarily the same value as num_rules, which is the analogous
   --    value for the NFA
   -- numsnpairs - number of state/nextstate transition pairs
   -- jambase - position in base/def where the default jam table starts
   -- jamstate - state number corresponding to "jam" state
   -- end_of_buffer_state - end-of-buffer dfa state number

   Current_Max_Dfa_Size, Current_Max_Xpairs      : Integer;
   Current_Max_Template_Xpairs, Current_Max_Dfas : Integer;
   Lastdfa, Lasttemp                             : Integer;
   Nxt, Chk, Tnxt                                : Int_Ptr;
   Base, Def, Dfasiz                             : Int_Ptr;
   Tblend, Firstfree                             : Integer;
   Dss                                           : Int_Star_Ptr;
   Dfaacc                                        : Dfaacc_Ptr;

   -- type declaration for dfaacc_type moved above

   Accsiz, Dhash                                             : Int_Ptr;
   End_Of_Buffer_State, Numsnpairs, Jambase, Jamstate, Numas : Integer;

   -- variables for ccl information:
   -- lastccl - ccl index of the last created ccl
   -- current_maxccls - current limit on the maximum number of unique ccl's
   -- cclmap - maps a ccl index to its set pointer
   -- ccllen - gives the length of a ccl
   -- cclng - true for a given ccl if the ccl is negated
   -- cclreuse - counts how many times a ccl is re-used
   -- current_max_ccl_tbl_size - current limit on number of characters needed
   --    to represent the unique ccl's
   -- ccltbl - holds the characters in each ccl - indexed by cclmap

   Current_Max_Ccl_Tbl_Size, Lastccl, Current_Maxccls, Cclreuse : Integer;
   Cclmap, Ccllen, Cclng                                        : Int_Ptr;

   Ccltbl : Char_Ptr;

   -- variables for miscellaneous information:
   -- starttime - real-time when we started
   -- endtime - real-time when we ended
   -- nmstr - last NAME scanned by the scanner
   -- sectnum - section number currently being parsed
   -- nummt - number of empty nxt/chk table entries
   -- hshcol - number of hash collisions detected by snstods
   -- dfaeql - number of times a newly created dfa was equal to an old one
   -- numeps - number of epsilon NFA states created
   -- eps2 - number of epsilon states which have 2 out-transitions
   -- num_reallocs - number of times it was necessary to realloc() a group
   --              of arrays
   -- tmpuses - number of DFA states that chain to templates
   -- totnst - total number of NFA states used to make DFA states
   -- peakpairs - peak number of transition pairs we had to store internally
   -- numuniq - number of unique transitions
   -- numdup - number of duplicate transitions
   -- hshsave - number of hash collisions saved by checking number of states
   -- num_backtracking - number of DFA states requiring back-tracking
   -- bol_needed - whether scanner needs beginning-of-line recognition

   Nmstr                                                      : Vstring;
   Sectnum, Nummt, Hshcol, Dfaeql, Numeps, Eps2, Num_Reallocs : Integer;
   Tmpuses, Totnst, Peakpairs, Numuniq, Numdup, Hshsave       : Integer;
   Num_Backtracking                                           : Integer;
   Bol_Needed                                                 : Boolean;

   function Allocate_Integer_Array (Size : in Integer) return Int_Ptr;

   function Allocate_Int_Ptr_Array (Size : in Integer) return Int_Star_Ptr;

   function Allocate_Vstring_Array (Size : in Integer) return Vstring_Ptr;

   function Allocate_Dfaacc_Union (Size : in Integer) return Dfaacc_Ptr;

   function Allocate_Character_Array (Size : in Integer) return Char_Ptr;

   function Allocate_Rule_Enum_Array (Size : in Integer) return Rule_Enum_Ptr;

   function Allocate_State_Enum_Array
     (Size : in Integer) return State_Enum_Ptr;

   function Allocate_Boolean_Array (Size : in Integer) return Boolean_Ptr;

   procedure Reallocate_Integer_Array
     (Arr : in out Int_Ptr; Size : in Integer);

   procedure Reallocate_Int_Ptr_Array
     (Arr : in out Int_Star_Ptr; Size : in Integer);

   procedure Reallocate_Vstring_Array
     (Arr : in out Vstring_Ptr; Size : in Integer);

   procedure Reallocate_Dfaacc_Union
     (Arr : in out Dfaacc_Ptr; Size : in Integer);

   procedure Reallocate_Character_Array
     (Arr : in out Char_Ptr; Size : in Integer);

   procedure Reallocate_Rule_Enum_Array
     (Arr : in out Rule_Enum_Ptr; Size : in Integer);

   procedure Reallocate_State_Enum_Array
     (Arr : in out State_Enum_Ptr; Size : in Integer);

   procedure Reallocate_Boolean_Array
     (Arr : in out Boolean_Ptr; Size : in Integer);

end Misc_Defs;
