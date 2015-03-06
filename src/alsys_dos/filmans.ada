
-- TITLE external_file_manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION opens external files for other functions
-- NOTES This package opens external files, and thus may be system dependent
--       because of limitations on file names.
--       This version is for the VADS 5.5 Ada development system.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/file_managerS.a,v 1.4 90/01/12 15:20:00 self Exp Locker: self $ 
--*************************************************************************** 
--          This file is subject to the Arcadia License Agreement. 
--
--                      (see notice in aflex.a)
--
--*************************************************************************** 

with TEXT_IO; use TEXT_IO; 
package EXTERNAL_FILE_MANAGER is 
  STANDARD_ERROR:FILE_TYPE;
  procedure GET_IO_FILE(F : in out FILE_TYPE); 
  procedure GET_DFA_FILE(F : in out FILE_TYPE); 
  procedure GET_SCANNER_FILE(F : in out FILE_TYPE); 
  procedure GET_BACKTRACK_FILE(F : in out FILE_TYPE); 
  procedure INITIALIZE_FILES; 
end EXTERNAL_FILE_MANAGER; 
