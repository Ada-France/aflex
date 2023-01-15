--  %option full
%option case-insensitive

LOWER    [a-z]
UPPER    [A-Z]

%%

{LOWER}+       { Lower_Case := Lower_Case + 1;
                 Text_IO.Put (To_Upper_Case(Options_DFA.YYText)); }

          -- convert all alphabetic words in lower case
          -- to upper case

{UPPER}+       { Upper_Case := Upper_Case + 1;
                 Text_IO.Put (Options_DFA.YYText); }

          -- write uppercase word as is

\n             { Text_IO.New_Line;}

.              { Text_IO.Put (Options_DFA.YYText); }
                 -- write anything else as is

%%
with Ada.Command_Line;
with Ada.Characters.Handling;
procedure Options is

   type Token is (End_of_Input, Error);

   Tok        : Token;
   Lower_Case : Natural := 0;   --  frequency of lower case words
   Upper_Case : Natural := 0;   --  frequency of upper case words

   function To_Upper_Case (Word : String) return String
     renames Ada.Characters.Handling.To_Upper;

   --  function YYlex will go here!!
##

begin
   Options_IO.Open_Input (Ada.Command_Line.Argument (1));

   Read_Input :
   loop
      Tok := YYLex;
      exit Read_Input when Tok = End_of_Input;
   end loop Read_Input;

   Text_IO.New_Line;
   Text_IO.Put_Line ("Number of lowercase words is => " &
                     Integer'Image (Lower_Case));
   Text_IO.Put_Line ("Number of uppercase words is => " &
                     Integer'Image (Upper_Case));
end Options;
