
-- TITLE external_file_manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION opens external files for other functions
-- NOTES This package opens external files, and thus may be system dependent
--       because of limitations on file names.
--       This version is for the VADS 5.5 Ada development system.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/file_managerB.a,v 1.5 90/01/12 15:19:58 self Exp Locker: self $ 
--*************************************************************************** 
--          This file is subject to the Arcadia License Agreement. 
--
--                      (see notice in aflex.a)
--
--*************************************************************************** 

with MISC_DEFS, TSTRING, TEXT_IO, MISC; use MISC_DEFS, TSTRING, TEXT_IO, MISC; 

package body EXTERNAL_FILE_MANAGER is 

-- FIX comment about compiler dependent

  subtype SUFFIX_TYPE is STRING(1 .. 3); 

  function ADA_SUFFIX return SUFFIX_TYPE is 
  begin
    return "ada"; 
  end ADA_SUFFIX; 

  function Five(S:String) return String is
  begin
    if S'Length <= 5 then
      return S;
    else
      return S(S'First..S'First+4);
    end if;
  end Five;

  procedure GET_IO_FILE(F : in out FILE_TYPE) is 
  begin
    if (LEN(INFILENAME) /= 0) then 
      CREATE(F, OUT_FILE, Five(STR(MISC.BASENAME)) & "_io." & ADA_SUFFIX); 
    else 
      CREATE(F, OUT_FILE, "af_yy_io." & ADA_SUFFIX); 
    end if; 
  exception
    when USE_ERROR | NAME_ERROR => 
      MISC.AFLEXFATAL("could not create IO package file"); 
  end GET_IO_FILE; 

  procedure GET_DFA_FILE(F : in out FILE_TYPE) is 
  begin
    if (LEN(INFILENAME) /= 0) then 
      CREATE(F, OUT_FILE, Five(STR(MISC.BASENAME)) & "_df." & ADA_SUFFIX); 
    else 
      CREATE(F, OUT_FILE, "af_yy_df." & ADA_SUFFIX); 
    end if; 
  exception
    when USE_ERROR | NAME_ERROR => 
      MISC.AFLEXFATAL("could not create DFA package file"); 
  end GET_DFA_FILE; 

  procedure GET_SCANNER_FILE(F : in out FILE_TYPE) is 
    OUTFILE_NAME : VSTRING; 
  begin
    if (LEN(INFILENAME) /= 0) then 

      -- give out infile + ada_suffix
      OUTFILE_NAME := MISC.BASENAME & "." & ADA_SUFFIX; 
    else 
      OUTFILE_NAME := VSTR("af_yy." & ADA_SUFFIX); 
    end if; 

    CREATE(F, OUT_FILE, STR(OUTFILE_NAME)); 
    SET_OUTPUT(F); 
  exception
    when NAME_ERROR | USE_ERROR => 
      MISC.AFLEXFATAL("can't create scanner file " & OUTFILE_NAME); 
  end GET_SCANNER_FILE; 

  procedure GET_BACKTRACK_FILE(F : in out FILE_TYPE) is 
  begin
    CREATE(F, OUT_FILE, "aflex.bkt"); 
  exception
    when USE_ERROR | NAME_ERROR => 
      MISC.AFLEXFATAL("could not create backtrack file"); 
  end GET_BACKTRACK_FILE; 

  procedure INITIALIZE_FILES is 
  begin
     CREATE(STANDARD_ERROR,OUT_FILE,"CON");
  end INITIALIZE_FILES; 

end EXTERNAL_FILE_MANAGER; 
