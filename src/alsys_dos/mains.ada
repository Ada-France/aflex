
-- TITLE main body
-- AUTHOR: John Self (UCI)
-- DESCRIPTION driver routines for aflex.  Calls drivers for all
-- high level routines from other packages.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/mainS.a,v 1.5 90/01/12 15:20:14 self Exp Locker: self $ 
--*************************************************************************** 
--          This file is subject to the Arcadia License Agreement. 
--
--                      (see notice in aflex.a)
--
--*************************************************************************** 

-- aflex - tool to generate fast lexical analyzers
package MAIN_BODY is 
  procedure AFLEXEND(STATUS : in INTEGER); 
  procedure AFLEXINIT; 
  procedure READIN; 
  procedure SET_UP_INITIAL_ALLOCATIONS; 
  AFLEX_TERMINATE    : exception; 
  TERMINATION_STATUS : INTEGER; 
end MAIN_BODY; 
