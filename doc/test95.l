%unit Foo

LOWER    [a-z]
UPPER    [A-Z]

%%

{LOWER}+       { Lower_Case := Lower_Case + 1; 
                 Put(To_Upper_Case(Foo.DFA.YYText)); }

{UPPER}+       { Upper_Case := Upper_Case + 1;
                 Put(To_Lower_Case (Foo.DFA.YYText)); }

\n             { New_Line;}

.              { Put(Foo.DFA.YYText); }

%%

with Ada.Command_Line, Foo;
procedure Test_Aflex is
  use Ada.Command_Line;
begin
  if Argument_Count = 1 then
    Foo.Parse (Argument(1));
  else
    Foo.Parse ("../../doc/test.l");
  end if;
end;


package Foo is
  procedure Parse (File : in String);
end;


with Ada.Characters.Handling;

with Text_IO, Foo.IO, Foo.DFA;
use  Text_IO, Foo.IO, Foo.DFA;

package body Foo is

  use Ada.Characters.Handling;

  type Token is (End_of_Input, Error);

  Tok        : Token;
  Lower_Case : Natural := 0;
  Upper_Case : Natural := 0;

  function To_Upper_Case (Word : String) return String is
    Temp : String(Word'Range);
  begin
    for I in Word'Range loop Temp(i) := To_Upper (Word(i)); end loop;
    return Temp;
  end;

  function To_Lower_Case (Word : String) return String is
    Temp : String(Word'Range);
  begin
    for I in Word'Range loop Temp(i) := To_Lower (Word(i)); end loop;
    return Temp;
  end;
  

-- function YYlex will go here!!
##

  procedure Parse (File : in String) is
  begin
    IO.Open_Input (File);
    loop
      Tok := YYLex;
      exit when Tok = End_of_Input;
    end loop;
    New_Line;
    Put_Line ("Number of lowercase words is" & Natural'Image(Lower_Case));
    Put_Line ("Number of uppercase words is" & Natural'Image(Upper_Case));
  end;

end;

