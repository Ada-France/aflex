## Template integration

Before Aflex 1.6, Aflex used templates that were hard-coded in the `Template_Manager`
package and several comments such as `UMASS CODES` or `END OF UMASS CODES` where
used to condtionally emit or skip some template code.  This implementation was
difficult to maintain and introducing new condition was a challenge.

The Aflex templates are now separated from the Aflex source code to make
them easier to edit.  An Aflex template supports very simple transformations
to keep the implementation small and easy to manage.  The following basic
transformations are supported:

- `%if, %else, %end` conditions are used to decide to emit or drop some portion,
- `%yydecl` pattern is expanded according to the `%yydecl` declaration in the scanner file
  or the default `YYLex` function declaration,
- `%yytype` pattern is replaced by the content of the `%yytype {}` code block if there is one,
- `%yyinit` pattern is replaced by the content of the `%yyinit {}` code block if there is one,
- `%yyaction` pattern is replaced by the content of the `%yyaction {}` code block if there is one,
- `%yywrap` pattern is replaced by the content of the `%yywrap {}` code block if there is one,
- ${NAME} specific patterns are replaced by names that depend on the source grammar.
- ${YYLEX} patterns are replaced by the `YYLex` function name

The `%` must appear at beginning of the line and a `%` condition that is not
recognized will generate a `Program_Error` when the template is expanded.

## Conditional generation

The Aflex template condition is a very basic mechanism that uses fixed
patterns to identify a condition.  A condition starts with `%if` followed by
a single space and the keyword followed by the end of line.
The following conditions are supported:

| Condition        | Description                                                |
|------------------|------------------------------------------------------------|
| %if echo         | Generate the default ECHO rule (can be disabled by using -s option) |
| %if minimalist   | Avoid emitting use and with clause to Ada.Text_IO (Aflex -m option is passed) |
| %if private      | Generate Ada `private` package (Aflex -P option is passed) |
| %if output       | Support `Output` in `_IO` package (can be disabled by using the `%option nooutput`) |
| %if interactive  | Scanner in interactive mode (Aflex -I option is passed) |
| %if error        | Scanner in improved error support mode (Aflex -E option is passed) |
| %if debug        | Scanner in debug mode (Aflex -d option) |
| %if yylineno     | Support `yylineno` generation (enabled by using the `%option yylineno`) |
| %if unput        | Support `Unput` in `_IO` package (can be disabled by using the `%option nounput`) |
| %if yywrap       | Support `yyWrap` in `_IO` package (can be disabled by using the `%option noyywrap`) |
| %if yytype       | Define if the source file contains a `%yytype {}` code block |
| %if yyaction     | Define if the source file contains a `%yyaction {}` code block |

Note:
- the template expander raises the `Program_Error` exception when a `%` pattern is not recognized.
  The sed script `templates/check.sed` is executed when the templates are embedded in the Ada source
  to verify that all known conditions are correct.  If a new condition is added, it must also be
  defined in that sed script.

## Variable replacement

A very basic variable replacement is implemented for the template.
The following string patterns are replaced:

| Pattern   | Description                                         |
|-----------|-----------------------------------------------------|
| ${NAME}   | The name of the Ada lexer package that is generated |
| ${YYLEX}  | The name of the scanner function.  The default is `YYLex` and it can be overriden by using the `%yydecl` definition in the scanner file |
| ${YYVAR}  | The name of the YYLex context variable for a reentrant scanner |
| ${YYBUFSIZE} | The value of `YY_READ_BUF_SIZE` configured with `%option bufsize=NNN` (default 75_000) |

## Build

The template files `templates/*.ads` and `templates/*.adb` are embedded in the Aflex
binary within the `Template_Manager.Templates` package.  Each template file is represented
by an array of String and is accessed through an Ada declaration.

```
package Template_Manager.Templates is

   type Content_Array is array (Positive range <>) of access constant String;
   type Content_Access is access constant Content_Array;

   body_dfa : aliased constant Content_Array;
   body_io : aliased constant Content_Array;
   spec_dfa : aliased constant Content_Array;
   spec_io : aliased constant Content_Array;
...
end Template_Manager.Templates;
```

The `src/template_manager-templates.ads` file is generated from the template files.
The generation is using the [Advanced Resource Embedder](https://gitlab.com/stcarrez/resource-embedder)
tool.  The `are` binary must be available in the `PATH` and the generation is done by running:

```
make generate
```

