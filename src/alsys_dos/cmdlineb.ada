
-- TITLE command line interface
-- AUTHOR: John Self (UCI)
-- DESCRIPTION command line interface body for use with the VERDIX VADS system.
-- NOTES this file is system dependent
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/command_lineB.a,v 1.3 90/01/12 15:19:44 self Exp Locker: self $ 
--*************************************************************************** 
--          This file is subject to the Arcadia License Agreement. 
--
--                      (see notice in aflex.a)
--
--*************************************************************************** 

with TSTRING; use TSTRING; 
with DOS; use DOS;
package body COMMAND_LINE_INTERFACE is 
  procedure INITIALIZE_COMMAND_LINE is 
  begin
    ARGC := 2;
    ARGV(0) := VSTR("");
    ARGV(1) := VSTR(GET_PARMS);
  end INITIALIZE_COMMAND_LINE; 
end COMMAND_LINE_INTERFACE; 
