# Aflex

[![Build Status](https://img.shields.io/jenkins/s/http/jenkins.vacs.fr/Aflex.svg)](http://jenkins.vacs.fr/job/Aflex/)
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

## Version 1.6 - Under development

- New option -P to generate a private Ada package for DFA and IO
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

