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

-- TITLE command line interface
-- AUTHOR: John Self (UCI)
-- DESCRIPTION command line interface body for use with
-- the Telesoft TeleGen2 Sun Ada 1.3a system.
-- NOTES this file is system dependent
-- $Header: /co/ua/self/arcadia/aflex/ada/src/telesoft/RCS/command_lineB.ada,v 1.1 90/01/12 15:13:59 self Exp Locker: self $ 

with TSTRING; use TSTRING; 
with SYSTEM; 
package body COMMAND_LINE_INTERFACE is 

  procedure INITIALIZE_COMMAND_LINE is 
    POSITION : INTEGER; 
    ARG_LEN  : INTEGER; 
    ARGUMENT : STRING(1 .. 1000); 

    function GET_ARGUMENT(PARAMETER_1 : in INTEGER; 
                          PARAMETER_2 : in SYSTEM.ADDRESS) return INTEGER; 

    pragma INTERFACE(UNIX, GET_ARGUMENT); 
  begin
    POSITION := 0; 
    loop
      ARG_LEN := GET_ARGUMENT(POSITION, ARGUMENT'ADDRESS); 
      if (ARG_LEN = 0) then 
        exit; 
      end if; 
      ARGV(POSITION) := VSTR(ARGUMENT(1 .. ARG_LEN)); 
      POSITION := POSITION + 1; 
    end loop; 
    ARGC := POSITION; 
  end INITIALIZE_COMMAND_LINE; 
end COMMAND_LINE_INTERFACE; 
