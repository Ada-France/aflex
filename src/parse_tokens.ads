package Parse_Tokens is


  subtype YYSType is Integer;

   YYLVal, YYVal : YYSType;
   type Token is
        (End_Of_Input, Error, Char, Number,
         Sectend, Scdecl, Xscdecl,
         Whitespace, Name, Prevccl,
         Eof_Op, Uscdecl, Optdecl,
         Yydecl, Yyvar, Uname,
         Optvar, Yycodeblock, Newline,
         '^', '<', '>',
         ',', '$', '|',
         '/', '*', '+',
         '?', '{', '}',
         '.', '"', '(',
         ')', '[', ']',
         '-');

   Syntax_Error : exception;

end Parse_Tokens;
