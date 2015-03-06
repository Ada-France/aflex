-- Handle Foreign Command
--
-- 2.9.92 sjw; orig

with Lib;
with Condition_Handling;
with System;

procedure Handle_Foreign_Command is

  function Get_Foreign return String;
  function To_Lower (C : Character) return Character;

  function Get_Foreign return String is
    Status : Condition_Handling.Cond_Value_Type;
    S : String (1 .. 255);
    L : System.Unsigned_Word;
  begin
    Lib.Get_Foreign (Status, Resultant_String => S, Resultant_Length => L);
    return S (1 .. Natural (L));
  end Get_Foreign;

  function To_Lower (C : Character) return Character is
    Lower_Case : constant array ('A' .. 'Z') of Character
      := ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
          'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
  begin
    if C in Lower_Case'Range then
      return Lower_Case (C);
    end if;
    return C;
  end To_Lower;

begin

  declare

    Raw_Command : constant String := Get_Foreign;

    subtype String_Position is Natural range 0 .. Raw_Command'Last + 1;
    subtype Substring is String (Raw_Command'Range);

    Raw_Position : String_Position := Raw_Command'First;

    Argument : Substring;
    Arg_Position : String_Position;

    Arg_Count : Argument_Count := Argument_Count'First;

  begin

    Arguments :
    loop

      exit Arguments when not (Raw_Position in Raw_Command'Range);

      if Raw_Command (Raw_Position) = ' ' then

        Raw_Position := Raw_Position + 1; -- DCL removes tabs

      else

        Arg_Position := 0;

        One_Argument :
        loop

          exit One_Argument when not (Raw_Position in Raw_Command'Range);
          exit One_Argument when Raw_Command (Raw_Position) = ' ';

          if Raw_Command (Raw_Position) /= '"' then

            Arg_Position := Arg_Position + 1;
            Argument (Arg_Position) :=
                  To_Lower (Raw_Command (Raw_Position));
            Raw_Position := Raw_Position + 1;

          else

            Raw_Position := Raw_Position + 1;

            Quoted_Part :
            loop

              exit One_Argument
                      when not (Raw_Position in Raw_Command'Range);

              if Raw_Command (Raw_Position) /= '"' then

                Arg_Position := Arg_Position + 1;
                Argument (Arg_Position) := Raw_Command (Raw_Position);
                Raw_Position := Raw_Position + 1;

              elsif Raw_Position + 1 in Raw_Command'Range
                          and then Raw_Command (Raw_Position + 1) = '"' then

                      -- double quote, -> one
                Arg_Position := Arg_Position + 1;
                Argument (Arg_Position) := '"';
                Raw_Position := Raw_Position + 2;

              else

                      -- terminating '"'
                Raw_Position := Raw_Position + 1;
                exit Quoted_Part;

              end if;

            end loop Quoted_Part;

          end if;

        end loop One_Argument;

        Handle_Argument
            (Count => Arg_Count,
             Argument => Argument (Argument'First .. Arg_Position));

        exit Arguments when Arg_Count = Argument_Count'Last;
          -- Maybe an exception would be more appropriate here!

        Arg_Count := Arg_Count + 1;

      end if;

    end loop Arguments;

  end;

end Handle_Foreign_Command;
