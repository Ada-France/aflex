-- TITLE command line interface
-- AUTHOR: Simon Wright
-- DESCRIPTION command line interface body for use with VAX/VMS
-- NOTES this file is system dependent

with Tstring;
with Handle_Foreign_Command;

package body Command_Line_Interface is

  subtype Argument_Number is Integer range 1 .. Max_Number_Args;

  procedure Handle (N : Argument_Number; A : String);

  procedure Process_Command_Line is new Handle_Foreign_Command
    (Argument_Count => Argument_Number,
     Handle_Argument => Handle);

  procedure Handle (N : Argument_Number; A : String) is
  begin
    Argv (N) := Tstring.Vstr (A);
    Argc := N + 1;
  end Handle;

  procedure Initialize_Command_Line is
  begin
    Argc := 1;
    Argv (0) := Tstring.Vstr ("Aflex");
    Process_Command_Line;
  end Initialize_Command_Line;

end Command_Line_Interface;
