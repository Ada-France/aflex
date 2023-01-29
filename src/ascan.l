--  Copyright (c) 1990 Regents of the University of California.
--  All rights reserved.
--
--  This software was developed by John Self of the Arcadia project
--  at the University of California, Irvine.
--
--  Redistribution and use in source and binary forms are permitted
--  provided that the above copyright notice and this paragraph are
--  duplicated in all such forms and that any documentation,
--  advertising materials, and other materials related to such
--  distribution and use acknowledge that the software was developed
--  by the University of California, Irvine.  The name of the
--  University may not be used to endorse or promote products derived
--  from this software without specific prior written permission.
--  THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
--  IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
--  WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

--  TITLE scanner specification file
--  AUTHOR: John Self (UCI)
--  DESCRIPTION regular expressions and actions matching tokens
--             that aflex expects to find in its input.
--  NOTES input to aflex (NOT alex.)  It uses exclusive start conditions
--       and case insensitive scanner generation available only in aflex
--       (or flex if you use C.)
--       generate scanner using the command 'aflex -is ascan.l'
--  $Header: C:/CVSROOT/afay/aflex/src/ascan.l,v 1.3 2004/10/23 22:06:12 Grands Exp $ 
--
--  2022/12/31 Stephane Carrez
--  + Add "%yydecl" to control the declaration of YYLex function
--  2017/01/08 Stephane Carrez
--  + Add "%option" to support flex controlling options
--  2004/10/16 Thierry Bernier
--  + Add "%unit" to support Ada-95 parent/child units
--  + Less -gnatwa warnings

%option yylineno

%x SECT2 SECT2PROLOG SECT3 PICKUPDEF SC CARETISBOL NUM QUOTE
%x FIRSTCCL CCL ACTION RECOVER BRACEERROR CODEBLOCK_MATCH_BRACE
%x ACTION_STRING
%x YYDECL_STRING

WS      [ \t\f]+
OPTWS       [ \t\f]*
NOT_WS      [^ \t\f\n]
NL          \r?\n

-- To be aflex'ed using "-i" : case insensitive
NAME        [a-z_][a-z_0-9-]*
NOT_NAME    [^a-z_\n]+
NUM         [0-9]+

DOT     "."
UNAME       {NAME}({DOT}{NAME})+

SCNAME      {NAME}
OPTVAR      {NAME}={NUM}

ESCSEQ      \\([^\n]|[0-9]{1,3})

%%

^{WS}           { indented_code := True; }
^#.*\n          { linenum := linenum + 1; ECHO;
                -- treat as a comment;
            }
^{OPTWS}"--".*\n    { linenum := linenum + 1; ECHO; }
^"%s"(tart)?        { return SCDECL; }
^"%x"           { return XSCDECL; }
^"%u"(nit)?     { return USCDECL; }
^"%o"(ption)?   { return OPTDECL; }
^"%yydecl"?{WS}+  { ENTER(YYDECL_STRING); return YYDECL; }
^"%yyvar"       { return YYVAR; }

{WS}            { return WHITESPACE; }
{OPTVAR}        { nmstr := vstr(yytext(1..YYLength)); return OPTVAR; }
^%yytype{WS}?"{"{WS}? {
                  Open_Code_Block (Template_Manager.Get_Filename (Template_Manager.YYTYPE_CODE));
                  ENTER(CODEBLOCK_MATCH_BRACE);
}
^%yyaction{WS}?"{"{WS}? {
                  Open_Code_Block (Template_Manager.Get_Filename (Template_Manager.YYACTION_CODE));
                  ENTER(CODEBLOCK_MATCH_BRACE);
}
^%yywrap{WS}?"{"{WS}? {
                  Open_Code_Block (Template_Manager.Get_Filename (Template_Manager.YYWRAP_CODE));
                  ENTER(CODEBLOCK_MATCH_BRACE);
}
^%yyinit{WS}?"{"{WS}? {
                  Open_Code_Block (Template_Manager.Get_Filename (Template_Manager.YYINIT_CODE));
                  ENTER(CODEBLOCK_MATCH_BRACE);
}

^"%%".*         {
            sectnum := 2;
            misc.line_directive_out;
            ENTER(SECT2PROLOG);
            return SECTEND;
            }

^%[a-z]+{WS}?"{"{WS}? {
               misc.synerr ("unrecognized code block");
               ENTER(CODEBLOCK_MATCH_BRACE);
            }

^"%"[^%sux]" ".*\n  {
            Ada.Text_IO.Put( Standard_Error, "old-style lex command at line " );
            int_io.put( Standard_Error, linenum );
            Ada.Text_IO.Put( Standard_Error, " ignored:" );
            text_io.new_line( Standard_Error );
            Ada.Text_IO.Put( Standard_Error, ASCII.HT );
            Ada.Text_IO.Put( Standard_Error, yytext(1..YYLength) );
            linenum := linenum + 1;
            }

^{NAME}         {
            nmstr := vstr(yytext(1..YYLength));
            didadef := False;
            ENTER(PICKUPDEF);
            }

{UNAME}         { nmstr := vstr(yytext(1..YYLength));
              return UNAME;
            }

{SCNAME}        { nmstr := vstr(yytext(1..YYLength));
              return NAME;
            }
^{OPTWS}\n      { linenum := linenum + 1;
              -- allows blank lines in section 1;
            }
{OPTWS}\n       { linenum := linenum + 1; return Newline; }
.           { misc.synerr( "illegal character" );ENTER(RECOVER);}
<YYDECL_STRING>.* {
               nmstr := vstr(yytext(1..YYLength));
               ENTER(0);
               return NAME;
            }
<PICKUPDEF>{WS}     { null;
              -- separates name and definition;
            }

<PICKUPDEF>{NOT_WS}.*   {
            nmdef := vstr(yytext(1..YYLength));

            i := tstring.len( nmdef );
            while ( i >= tstring.first ) loop
                if ( (CHAR(nmdef,i) /= ' ') and
                 (CHAR(nmdef,i) /= ASCII.HT) ) then
                exit;
                end if;
                i := i - 1;
            end loop;

                        sym.ndinstal( nmstr,
                tstring.slice(nmdef, tstring.first, i) );
            didadef := True;
            }

<PICKUPDEF>\n       {
            if not didadef then
                misc.synerr( "incomplete name definition" );
            end if;
            ENTER(0);
            linenum := linenum + 1;
            }

<RECOVER>.*\n       { linenum := linenum + 1;
              ENTER(0);
              nmstr := vstr(yytext(1..YYLength));
              return NAME;
            }

<SECT2PROLOG>.*\n/{NOT_WS}  {
            linenum := linenum + 1;
            ACTION_ECHO;
            MARK_END_OF_PROLOG;
            ENTER(SECT2);
            }

<SECT2PROLOG>.*\n   { linenum := linenum + 1; ACTION_ECHO; }

<SECT2PROLOG><<EOF>>    { MARK_END_OF_PROLOG;
              return End_Of_Input;
            }

<SECT2>^{OPTWS}\n   { linenum := linenum + 1;
              -- allow blank lines in sect2;}
            
            -- this rule matches indented lines which
            -- are not comments.
<SECT2>^{WS}{NOT_WS}"--".*\n    {
            misc.synerr("indented code found outside of action");
            linenum := linenum + 1;
            }

<SECT2>"<"      { ENTER(SC); return ( '<' ); }
<SECT2>^"^"     { return ( '^' ); } 
<SECT2>\"       { ENTER(QUOTE); return ( '"' ); }
<SECT2>"{"/[0-9]        { ENTER(NUM); return ( '{' ); }
<SECT2>"{"[^0-9\n][^}\n]*   { ENTER(BRACEERROR); }
<SECT2>"$"/[ \t\n]  { return '$'; }

<SECT2>{WS}"|".*\n  { continued_action := True;
              linenum := linenum + 1;
              return Newline;
            }

<SECT2>^{OPTWS}"--".*\n { linenum := linenum + 1; ACTION_ECHO; }

<SECT2>{WS}     {
            -- this rule is separate from the one below because
            -- otherwise we get variable trailing context, so
            -- we can't build the scanner using -{f,F}

            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            }

<SECT2>{OPTWS}/\n   {
            bracelevel := 0;
            continued_action := False;
            ENTER(ACTION);
            return Newline;
            }

<SECT2>^{OPTWS}\n   { linenum := linenum + 1; return Newline; }

<SECT2>"<<EOF>>"    { return EOF_OP; }

<SECT2>^"%%".*      {
            sectnum := 3;
            ENTER(SECT3);
            return End_Of_Input;
            -- to stop the parser
            }

<SECT2>"["([^\\\]\n]|{ESCSEQ})+"]"  {

            nmstr := vstr(yytext(1..YYLength));

            -- check to see if we've already encountered this ccl
                        cclval := sym.ccllookup( nmstr );
            if ( cclval /= 0 ) then
                YYLVal := cclval;
                cclreuse := cclreuse + 1;
                return PREVCCL;
            else
                -- we fudge a bit.  We know that this ccl will
                -- soon be numbered as lastccl + 1 by cclinit
                sym.cclinstal( nmstr, lastccl + 1 );

                -- push back everything but the leading bracket
                -- so the ccl can be rescanned

                PUT_BACK_STRING(nmstr, 1);

                ENTER(FIRSTCCL);
                return '[';
            end if;
            }

<SECT2>"{"{NAME}"}" {
            nmstr := vstr(yytext(1..YYLength));
            -- chop leading and trailing brace
            tmpbuf := slice(vstr(yytext(1..YYLength)),
                                2, YYLength-1);

            nmdefptr := sym.ndlookup( tmpbuf );
            if ( nmdefptr = NUL ) then
                misc.synerr( "undefined {name}" );
            else
                -- push back name surrounded by ()'s
                unput(')');
                PUT_BACK_STRING(nmdefptr, 0);
                unput('(');
            end if;
            }

<SECT2>[/|*+?.()]   { tmpbuf := vstr(yytext(1..YYLength));
              case tstring.CHAR(tmpbuf,1) is
                when '/' => return '/';
                when '|' => return '|';
                when '*' => return '*';
                when '+' => return '+';
                when '?' => return '?';
                when '.' => return '.';
                when '(' => return '(';
                when ')' => return ')';
                when others =>
                    misc.aflexerror("error in aflex case");
              end case;
            }
<SECT2>.        { tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            }
<SECT2>\n       { linenum := linenum + 1; return Newline; }


<SC>","         { return ( ',' ); }
<SC>">"         { ENTER(SECT2); return ( '>' ); }
<SC>">"/"^"     { ENTER(CARETISBOL); return ( '>' ); }
<SC>{SCNAME}        { nmstr := vstr(yytext(1..YYLength));
              return NAME;
            }
<SC>.           { misc.synerr( "bad start condition name" ); }

<CARETISBOL>"^"     { ENTER(SECT2); return '^'; }


<QUOTE>[^"\n]       { tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            }
<QUOTE>\"       { ENTER(SECT2); return '"'; }

<QUOTE>\n       {
            misc.synerr( "missing quote" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '"';
            }


<FIRSTCCL>"^"/[^-\n]    { ENTER(CCL); return '^'; }
<FIRSTCCL>"^"/-     { return '^'; }
<FIRSTCCL>-     { ENTER(CCL); YYLVal := CHARACTER'POS('-'); return ( CHAR ); }
<FIRSTCCL>.     { ENTER(CCL);
              tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            }

<CCL>-/[^\]\n]      { return '-'; }
<CCL>[^\]\n]        { tmpbuf := vstr(yytext(1..YYLength));
              YYLVal := CHARACTER'POS(CHAR(tmpbuf,1));
              return CHAR;
            }
<CCL>"]"        { ENTER(SECT2); return ']'; }


<NUM>[0-9]+     {
            YYLVal := misc.myctoi( vstr(yytext(1..YYLength)) );
            return NUMBER;
            }

<NUM>","            { return ','; }
<NUM>"}"            { ENTER(SECT2); return '}'; }

<NUM>.          {
            misc.synerr( "bad character inside {}'s" );
            ENTER(SECT2);
            return '}';
            }

<NUM>\n         {
            misc.synerr( "missing }" );
            ENTER(SECT2);
            linenum := linenum + 1;
            return '}';
            }


<BRACEERROR>"}"     { misc.synerr( "bad name in {}'s" ); ENTER(SECT2); }
<BRACEERROR>\n      { misc.synerr( "missing }" );
              linenum := linenum + 1;
              ENTER(SECT2);
            }

<ACTION>"{"     { bracelevel := bracelevel + 1; }
<ACTION>"}"     { bracelevel := bracelevel - 1; }
<ACTION>[^a-z_{}"'/\n]+ { ACTION_ECHO; }
<ACTION>{NAME}      { ACTION_ECHO; }
<ACTION>"--".*\n    { linenum := linenum + 1; ACTION_ECHO; }
<ACTION>"'"([^'\\\n]|\\.)*"'"   { ACTION_ECHO;
                  -- character constant;
            }

<ACTION>\"      { ACTION_ECHO; ENTER(ACTION_STRING); }

<ACTION>\n      {
            linenum := linenum + 1;
            ACTION_ECHO;
            if bracelevel = 0 then
                text_io.new_line ( temp_action_file );
                ENTER(SECT2);
                    end if;
            }
<ACTION>.       { ACTION_ECHO; }

<ACTION_STRING>[^"\\\n]+    { ACTION_ECHO; }
<ACTION_STRING>\\.  { ACTION_ECHO; }
<ACTION_STRING>\n   { linenum := linenum + 1; ACTION_ECHO; }
<ACTION_STRING>\"   { ACTION_ECHO; ENTER(ACTION); }
<ACTION_STRING>.    { ACTION_ECHO; }


<SECT2,QUOTE,CCL>{ESCSEQ}   {
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            return ( CHAR );
            }

<FIRSTCCL>{ESCSEQ}  {
            YYLVal := CHARACTER'POS(misc.myesc( vstr(yytext(1..YYLength)) ));
            ENTER(CCL);
            return CHAR;
            }


<SECT3>.*(\n?)      { if check_yylex_here then
                return End_Of_Input;
              else
                ECHO;
              end if;
            }

<CODEBLOCK_MATCH_BRACE>"}"     {
                if Code_Block_Active then
                   Ada.Text_IO.Close (Code_Block_File);
                   Code_Block_Active := False;
                end if;
                ENTER(0);
                return YYCODEBLOCK;
            }

<CODEBLOCK_MATCH_BRACE>"{"     {
                --  brace_depth++;
                if Code_Block_Active then
                   Ada.Text_IO.Put (Code_Block_File, YYText);
                end if;
            }

<CODEBLOCK_MATCH_BRACE>{NL}    {
                Linenum := Linenum + 1;
                if Code_Block_Active then
                   Ada.Text_IO.New_Line (Code_Block_File);
                end if;
            }

<CODEBLOCK_MATCH_BRACE>([^{}\r\n\[\]]+)|[^{}\r\n]  {
                Linenum := Linenum + 1; 
                if Code_Block_Active then
                   Ada.Text_IO.Put (Code_Block_File, YYText);
                end if;
            }

<CODEBLOCK_MATCH_BRACE><<EOF>>     {
                misc.synerr ("unmatched '{' at line" & Natural'Image (Code_Block_Start));
                if Code_Block_Active then
                   Ada.Text_IO.Close (Code_Block_File);
                end if;
                ENTER(0);
                return YYCODEBLOCK;
            }

%%
with Parse_Tokens;
package scanner is
   call_yylex : Boolean := False;
   function get_token return Parse_Tokens.Token;
end scanner;

pragma Warnings (Off);
with Ada.Text_Io;
with misc_defs, misc, sym, parse_tokens, int_io;
with tstring, ascan_dfa, ascan_io;
with Template_Manager;
use misc_defs, parse_tokens, tstring;
use ascan_dfa, ascan_io;
package body scanner is

   use Ada;
   use Ada.Text_IO;

   beglin : Boolean := False;
   i, bracelevel: Integer;
   Code_Block_File   : Ada.Text_IO.File_Type;
   Code_Block_Start  : Natural;
   Code_Block_Active : Boolean := False;

   procedure Open_Code_Block (Name : in String) is
   begin
      Code_Block_Start := YYlineno + 1;
      Code_Block_Active := True;
      Ada.Text_IO.Open (Code_Block_File, Ada.Text_IO.Append_File, Name);

   exception
      when Name_Error =>
         Ada.Text_IO.Create (Code_Block_File, Ada.Text_IO.Append_File, Name);
   end Open_Code_Block;

   function get_token return Token is
      toktype : Token;
      didadef, indented_code : Boolean;
      cclval : Integer;
      nmdefptr : vstring;
      nmdef, tmpbuf : vstring;

      procedure ACTION_ECHO is
      begin
         Ada.Text_IO.Put (temp_action_file, yytext(1 .. YYLength));
      end ACTION_ECHO;

      procedure MARK_END_OF_PROLOG is
      begin
         Ada.Text_IO.Put (temp_action_file, "%%%% end of prolog");
         Ada.Text_IO.New_Line (temp_action_file);
      end MARK_END_OF_PROLOG;

      procedure PUT_BACK_STRING(str : vstring; start : Integer) is
      begin
         for i in reverse start + 1 .. tstring.len (str) loop
            unput (CHAR (str, i));
         end loop;
      end PUT_BACK_STRING;

      function check_yylex_here return Boolean is
      begin
         return ( (yytext'length >= 2) and then
                ((yytext(1) = '#') and (yytext(2) = '#')));
      end check_yylex_here;

##
   begin

      if (call_yylex) then
         toktype := YYLex;
         call_yylex := False;
         return toktype;
      end if;

      if ( eofseen ) then
         toktype := End_Of_Input;
      else
         toktype := YYLex;
      end if;

      -- this tracing code allows easy tracing of aflex runs
      if (trace) then
         Ada.Text_IO.New_Line (Standard_Error);
         Ada.Text_IO.Put (Standard_Error, "toktype = :" );
         Ada.Text_IO.Put (Standard_Error, Token'Image (toktype));
         Ada.Text_IO.Put_line (Standard_Error, ":" );
      end if;

      if ( toktype = End_Of_Input ) then
         eofseen := True;

         if sectnum = 1 then
            misc.synerr ("unexpected EOF");
            sectnum := 2;
            toktype := SECTEND;
         elsif sectnum = 2 then
            sectnum := 3;
            toktype := SECTEND;
         end if;
      end if;
    
      if trace then
         if beglin then
            Int_IO.Put (Standard_Error, num_rules + 1);
            Ada.Text_IO.Put (Standard_Error, ASCII.HT);
            beglin := False;
         end if;

         case toktype is
            when '<' | '>'|'^'|'$'|'"'|'['|']'|'{'|'}'|'|'|'('|
                 ')'|'-'|'/'|'?'|'.'|'*'|'+'|',' =>
               Ada.Text_IO.Put (Standard_Error, Token'Image (toktype));

            when NEWLINE =>
               Ada.Text_IO.New_Line (Standard_Error);
               if sectnum = 2 then
                  beglin := True;
               end if;

            when SCDECL =>
               Ada.Text_IO.Put (Standard_Error, "%s");

            when XSCDECL =>
               Ada.Text_IO.Put (Standard_Error, "%x");

            when WHITESPACE =>
               Ada.Text_IO.Put (Standard_Error, " ");

            when SECTEND =>
               Ada.Text_IO.Put_line (Standard_Error, "%%");

               --  we set beglin to be true so we'll start
               --  writing out numbers as we echo rules.  aflexscan() has
               --  already assigned sectnum

               if sectnum = 2 then
                  beglin := True;
               end if;

            when NAME =>
               Ada.Text_IO.Put (Standard_Error, ''');
               Ada.Text_IO.Put (Standard_Error, YYText);
               Ada.Text_IO.Put (Standard_Error, ''');

            when CHAR =>
               if ( (YYLVal < CHARACTER'POS(' ')) or
                  (YYLVal = CHARACTER'POS(ASCII.DEL)) ) then
                  Ada.Text_IO.Put (Standard_Error, '\');
                  Int_IO.Put (Standard_Error, YYLVal);
                  Ada.Text_IO.Put (Standard_Error, '\');
               else
                  Ada.Text_IO.Put (Standard_Error, Token'Image (toktype));
               end if;

            when NUMBER =>
               Int_IO.Put (Standard_Error, YYLVal);

            when OPTDECL =>
               Ada.Text_IO.Put (Standard_Error, "%option ");
               Ada.Text_IO.Put (Standard_Error, YYText);
               Ada.Text_IO.Put (Standard_Error, ''');

            when YYDECL =>
               Ada.Text_IO.Put (Standard_Error, "%yydecl ");
               Ada.Text_IO.Put (Standard_Error, YYText);
               Ada.Text_IO.Put (Standard_Error, ''');

            when YYCODEBLOCK =>
               Ada.Text_IO.Put (Standard_Error, "%<code> {");
               Ada.Text_IO.Put (Standard_Error, YYText);
               Ada.Text_IO.Put (Standard_Error, '}');

            when PREVCCL =>
               Ada.Text_IO.Put (Standard_Error, '[');
               Int_IO.Put (Standard_Error, YYLVal);
               Ada.Text_IO.Put (Standard_Error, ']');

            when End_Of_Input =>
               Ada.Text_IO.Put (Standard_Error, "End Marker");

            when others =>
               Ada.Text_IO.Put (Standard_Error, "Something weird:");
               Ada.Text_IO.Put_line (Standard_Error, Token'Image (toktype));
         end case;
      end if;
      return toktype;
   end get_token;

end scanner;
