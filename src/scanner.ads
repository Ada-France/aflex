--  Warning: This lexical scanner is automatically generated by AFLEX.
--           It is useless to modify it. Change the ".Y" & ".L" files instead.
with Text_IO; use Text_IO;
with ascan_dfa; use ascan_dfa; 
with ascan_io; use ascan_io; 
--# line 1 "ascan.l"
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
-- TITLE scanner specification file
-- AUTHOR: John Self (UCI)
-- DESCRIPTION regular expressions and actions matching tokens
--             that aflex expects to find in its input.
-- NOTES input to aflex (NOT alex.)  It uses exclusive start conditions
--       and case insensitive scanner generation available only in aflex
--       (or flex if you use C.)
--       generate scanner using the command 'aflex -is ascan.l'
-- $Header: C:/CVSROOT/afay/aflex/src/ascan.l,v 1.3 2004/10/23 22:06:12 Grands Exp $ 
--
-- 2004/10/16 Thierry Bernier
-- + Add "%unit" to support Ada-95 parent/child units
-- + Less -gnatwa warnings
-- To be aflex'ed using "-i" : case insensitive
--# line 53 "ascan.l"


with text_io; use text_io;
with misc_defs, misc, sym, parse_tokens, int_io;
with tstring, ascan_dfa, ascan_io, external_file_manager;
use misc_defs, parse_tokens, tstring;
use ascan_dfa, ascan_io, external_file_manager;

package scanner is
    call_yylex : boolean := false;
    function get_token return Token;
end scanner;
