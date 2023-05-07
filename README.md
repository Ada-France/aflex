# Aflex

[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/aflex.json)](https://alire.ada.dev/crates/aflex)
[![Build Status](https://img.shields.io/endpoint?url=https://porion.vacs.fr/porion/api/v1/projects/aflex/badges/build.json)](https://porion.vacs.fr/porion/projects/view/aflex/summary)
[![License](http://img.shields.io/badge/license-UCI-blue.svg)](LICENSE)


Aflex is a lexical analyzer generating tool similar to the Unix tool lex.

The first implementation was written by John Self of the Arcadia project
at the University of California, Irvine.  The last version that was released
appeared to be the aflex 1.4a released in 1994.

Aflex was used and improved by P2Ada, the Pascal to Ada translator.
This version of Aflex is derived from the P2Ada aflex implementation
released in August 2010.

This version brings a number of improvements:

- Aflex generates the spec and body files as separate files so that
  there is no need to use gnatchop to split the DFA and IO files.
- Aflex uses the lex file name to generate the package name and
  it supports child package.

## Version 1.6 - May 2023

- Fix #2: Missing `Input_Line` function when `-E` option is used
- Support the flex options `%option output`, `%option nooutput`, `%option yywrap`, `%option noinput`,
  `%option noyywrap`, `%option unput`, `%option nounput`, `%option bufsize=NNN` to better control the
  generated `_IO` package.
- Aflex templates provide more control for tuning the code generation and
  they are embedded with [Advanced Resource Embedder](https://gitlab.com/stcarrez/resource-embedder)
- Support to define Ada code block in the scanner that is inserted in the generated scanner
- New option -P to generate a private Ada package for DFA and IO
- New directive `%option reentrant` and `%yyvar` to generate a recursive scanner
- New directive `%yydecl` to allow passing parameters to `YYLex`
  or change the default function name
- Reformat code using `gnatpp`

## Version 1.5.2021 - Dec 2021

- Fix crash when the scanner file uses characters in range 128..255,
- Fixed various compilation warnings,
- Use `gprbuild` to build and support `alr`,
- Reduced number of style compilation warnings in generated code

## Version 1.5.2017 - Jan 2017

- Aflex now supports the *%option* definition in lex files to control the scanner.
  The following keywords are recognized: *case-insensitive*, *casefull*, *case-insensitive*,
  *caseless*, *debug*, *interactive*, *full*.

# Build

```
  make
```

# Install
```
  make install prefix=/usr
```

# Example
```
  aflex doc/example.l
  gnatmake example.ada
```

# Articles and Documentation

* Man page: [aflex (1)](https://github.com/Ada-France/aflex/blob/master/doc/aflex.md)

* [Aflex 1.5 and Ayacc 1.3.0](https://blog.vacs.fr/vacs/blogs/post.html?post=2021/12/18/Aflex-1.5-and-Ayacc-1.3.0)
  explains how to use Aflex and Ayacc together, 
  [Aflex 1.5 et Ayacc 1.3.0](https://www.ada-france.org/adafr/blogs/post.html?post=2021/12/19/Aflex-1.5-et-Ayacc-1.3.0)
  is the French translation.

  
