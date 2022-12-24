-- UNIT: generic package spec of VSTRINGS
--
-- FILES: vstring_spec.a in publiclib
--        related file is vstring_body.a in publiclib
--
-- PURPOSE:  An implementation of the abstract data type "variable-length
--           string."
--
-- DESCRIPTION:  This package provides a private type VSTRING.  VSTRING objects
--               are "strings" that have a length between zero and LAST, where
--               LAST is the generic parameter supplied in the package
--               instantiation.
--
--               In addition to the type VSTRING, a subtype and two constants
--               are declared.  The subtype STRINDEX is an index to a VSTRING,
--               The STRINDEX constant FIRST is an index to the first character
--               of the string, and the VSTRING constant NUL is a VSTRING of
--               length zero.  NUL is the default initial value of a VSTRING.
--
--               The following sets of functions, procedures, and operators
--               are provided as operations on the type VSTRING:
--
--               ATTRIBUTE FUNCTIONS:  LEN, MAX, STR, CHAR
--                 The attribute functions return the characteristics of
--                 a VSTRING.
--
--               COMPARISON OPERATORS: "=", "/=", "<", ">", "<=", ">="
--                 The comparison operators are the same as for the predefined
--                 type STRING.
--
--               INPUT/OUTPUT PROCEDURES: GET, GET_LINE, PUT, PUT_LINE
--
--                 The input/output procedures are similar to those for the
--                 predefined type STRING, with the following exceptions:
--
--                   - GET has an optional parameter LENGTH, which indicates
--                     the number of characters to get (default is LAST).
--
--                   - GET_LINE does not have a parameter to return the length
--                     of the string (the LEN function should be used instead).
--
--               EXTRACTION FUNCTIONS: SLICE, SUBSTR, DELETE
--                 The SLICE function returns the slice of a VSTRING between
--                 two indices (equivalent to STR(X)(A .. B)).
--
--                 SUBSTR returns a substring of a VSTRING taken from a given
--                 index and extending a given length.
--
--                 The DELETE function returns the VSTRING which results from
--                 removing the slice between two indices.
--
--               EDITING FUNCTIONS: INSERT, APPEND, REPLACE
--                 The editing functions return the VSTRING which results from
--                 inserting, appending, or replacing at a given index with a
--                 VSTRING, STRING, or CHARACTER.  The index must be in the
--                 current range of the VSTRING; i.e., zero cannot be used.
--
--               CONCATENATION OPERATOR:  "&"
--                 The concatenation operator is the same as for the type
--                 STRING.  It should be used instead of APPEND when the
--                 APPEND would always be after the last character.
--
--               POSITION FUNCTIONS: INDEX, RINDEX
--                 The position functions return an index to the Nth occurrence
--                 of a VSTRING, STRING, or CHARACTER from the front or back
--                 of a VSTRING.  Zero is returned if the search is not
--                 successful.
--
--               CONVERSION FUNCTIONS AND OPERATOR: VSTR, CONVERT, "+"
--                 VSTR converts a STRING or a CHARACTER to a VSTRING.
--
--                 CONVERT is a generic function which can be instantiated to
--                 convert from any given variable-length string to another,
--                 provided the FROM type has a function equivelent to STR
--                 defined for it, and that the TO type has a function equiv-
--                 elent to VSTR defined for it.  This provides a means for
--                 converting between VSTRINGs declared in separate instant-
--                 iations of VSTRINGS.  When instantiating CONVERT for
--                 VSTRINGs, the STR and VSTR functions are implicitly defined,
--                 provided that they have been made visible (by a use clause).
--
--                 Note:  CONVERT is NOT implicitly associated with the type
--                 VSTRING declared in this package (since it would not be a
--                 derivable function (see RM 3.4(11))).
--
--                 Caution:  CONVERT cannot be instantiated directly with the
--                 names VSTR and STR, since the name of the subprogram being
--                 declared would hide the generic parameters with the same
--                 names (see RM 8.3(16)).  CONVERT can be instantiated with
--                 the operator "+", and any instantiation of CONVERT can
--                 subsequently be renamed VSTR or STR.
--
--                 Example:  Given two VSTRINGS instantiations X and Y:
--                   function "+" is new X.CONVERT(X.VSTRING, Y.VSTRING);
--                   function "+" is new X.CONVERT(Y.VSTRING, X.VSTRING);
--
--                   (Y.CONVERT could have been used in place of X.CONVERT)
--
--                   function VSTR(A : X.VSTRING) return Y.VSTRING renames "+";
--                   function VSTR(A : Y.VSTRING) return X.VSTRING renames "+";
--
--                 "+" is equivelent to VSTR.  It is supplied as a short-hand
--                 notation for the function.  The "+" operator cannot immed-
--                 iately follow the "&" operator; use ... & (+ ...) instead.
pragma Page;

--  DISCUSSION:
--
--      This package implements the type "variable-length string" (vstring)
--      using generics.  The alternative approaches are to use a discriminant
--      record in which the discriminant controls the length of a STRING inside
--      the record, or a record containing an access type which points to a
--      string, which can be deallocated and reallocated when necessary.
--
--      Advantages of this package:
--        * The other approaches force the vstring to be a limited private
--          type.  Thus, their vstrings cannot appear on the left side of
--          the assignment operator; ie., their vstrings cannot be given
--          initial values or values by direct assignment.  This package
--          uses a private type; therefore, these things can be done.
--
--        * The other approach stores the vstring in a string whose length
--          is determined dynamically.  This package uses a fixed length
--          string.  This difference might be reflected in faster and more
--          consistent execution times (this has NOT been verified).
--
--      Disadvantages of this package:
--        * Different instantiations must be used to declare vstrings with
--          different maximum lengths (this may be desirable, since
--          CONSTRAINT_ERROR will be raised if the maximum is exceeded).
--
--        * A second declaration is required to give the type declared by
--          the instantiation a name other than "VSTRING."
--
--        * The storage required for a vstring is determined by the generic
--          parameter LAST and not the actual length of its contents.  Thus,
--          each object is allocated the maximum amount of storage, regardless
--          of its actual size.
--
--  MISCELLANEOUS:
--     Constraint checking is done explicitly in the code; thus, it cannot
--     be suppressed.  On the other hand, constraint checking is not lost
--     if pragma suppress is supplied to the compilation (-S option)
--     (The robustness of the explicit constraint checking has NOT been
--     determined).
--
--     Compiling with the optimizer (-O option) may significantly reduce
--     the size (and possibly execution time) of the resulting executable.
--
--     Compiling an instantiation of VSTRINGS is roughly equivelent to
--     recompiling VSTRINGS.  Since this takes a significant amount of time,
--     and the instantiation does not depend on any other library units,
--     it is STRONGLY recommended that the instantiation be compiled
--     separately, and thus done only ONCE.
--
--  USAGE: with VSTRINGS;
--         package package_name is new VSTRINGS(maximum_length);
-- .......................................................................... --
pragma Page;

with Text_Io; use Text_Io;
generic
   Last : Natural;
package Vstrings is

   subtype Strindex is Natural;
   First : constant Strindex := Strindex'First + 1;
   type Vstring is private;
   Nul : constant Vstring;

-- Attributes of a VSTRING

   function Len (From : Vstring) return Strindex;
--  function MAX(FROM : VSTRING) return STRINDEX;
   function Str (From : Vstring) return String;
   function Char
     (From : Vstring; Position : Strindex := First) return Character;

-- Comparisons

   function "<" (Left : Vstring; Right : Vstring) return Boolean;
   function ">" (Left : Vstring; Right : Vstring) return Boolean;
   function "<=" (Left : Vstring; Right : Vstring) return Boolean;
   function ">=" (Left : Vstring; Right : Vstring) return Boolean;
   -- "=" and "/=" are predefined

-- Input/Output

   procedure Put (File : in File_Type; Item : in Vstring);
   procedure Put (Item : in Vstring);

   procedure Put_Line (File : in File_Type; Item : in Vstring);
   procedure Put_Line (Item : in Vstring);

   procedure Get
     (File : in File_Type; Item : out Vstring; Length : in Strindex := Last);
   procedure Get (Item : out Vstring; Length : in Strindex := Last);

   procedure Get_Line (File : in File_Type; Item : in out Vstring);
   procedure Get_Line (Item : in out Vstring);

-- Extraction

   function Slice (From : Vstring; Front, Back : Strindex) return Vstring;
   function Substr (From : Vstring; Start, Length : Strindex) return Vstring;
   function Delete (From : Vstring; Front, Back : Strindex) return Vstring;

-- Editing

   function Insert
     (Target : Vstring; Item : Vstring; Position : Strindex := First)
      return Vstring;
   function Insert
     (Target : Vstring; Item : String; Position : Strindex := First)
      return Vstring;
   function Insert
     (Target : Vstring; Item : Character; Position : Strindex := First)
      return Vstring;

   function Append
     (Target : Vstring; Item : Vstring; Position : Strindex) return Vstring;
   function Append
     (Target : Vstring; Item : String; Position : Strindex) return Vstring;
   function Append
     (Target : Vstring; Item : Character; Position : Strindex) return Vstring;

   function Append (Target : Vstring; Item : Vstring) return Vstring;
   function Append (Target : Vstring; Item : String) return Vstring;
   function Append (Target : Vstring; Item : Character) return Vstring;

   function Replace
     (Target : Vstring; Item : Vstring; Position : Strindex := First)
      return Vstring;
   function Replace
     (Target : Vstring; Item : String; Position : Strindex := First)
      return Vstring;
   function Replace
     (Target : Vstring; Item : Character; Position : Strindex := First)
      return Vstring;

-- Concatenation

   function "&" (Left : Vstring; Right : Vstring) return Vstring;
   function "&" (Left : Vstring; Right : String) return Vstring;
   function "&" (Left : Vstring; Right : Character) return Vstring;
   function "&" (Left : String; Right : Vstring) return Vstring;
   function "&" (Left : Character; Right : Vstring) return Vstring;

-- Determine the position of a substring

   function Index
     (Whole : Vstring; Part : Vstring; Occurrence : Natural := 1)
      return Strindex;
   function Index
     (Whole : Vstring; Part : String; Occurrence : Natural := 1)
      return Strindex;
   function Index
     (Whole : Vstring; Part : Character; Occurrence : Natural := 1)
      return Strindex;

   function Rindex
     (Whole : Vstring; Part : Vstring; Occurrence : Natural := 1)
      return Strindex;
   function Rindex
     (Whole : Vstring; Part : String; Occurrence : Natural := 1)
      return Strindex;
   function Rindex
     (Whole : Vstring; Part : Character; Occurrence : Natural := 1)
      return Strindex;

-- Conversion from other associated types

   function Vstr (From : String) return Vstring;
   function Vstr (From : Character) return Vstring;
   function "+" (From : String) return Vstring;
   function "+" (From : Character) return Vstring;

   generic
      type From is private;
      type To is private;
      with function Str (X : From) return String is <>;
      with function Vstr (Y : String) return To is <>;
   function Convert (X : From) return To;

   pragma Page;

private
   type Vstring is record
      Len   : Strindex               := Strindex'First;
      Value : String (First .. Last) := (others => ASCII.NUL);
   end record;

   Nul : constant Vstring := (Strindex'First, (others => ASCII.NUL));
end Vstrings;
--
-- .......................................................................... --
--
-- DISTRIBUTION AND COPYRIGHT:
--
-- This software is released to the Public Domain (note:
--   software released to the Public Domain is not subject
--   to copyright protection).
-- Restrictions on use or distribution:  NONE
--
-- DISCLAIMER:
--
-- This software and its documentation are provided "AS IS" and
-- without any expressed or implied warranties whatsoever.
-- No warranties as to performance, merchantability, or fitness
-- for a particular purpose exist.
--
-- Because of the diversity of conditions and hardware under
-- which this software may be used, no warranty of fitness for
-- a particular purpose is offered.  The user is advised to
-- test the software thoroughly before relying on it.  The user
-- must assume the entire risk and liability of using this
-- software.
--
-- In no event shall any person or organization of people be
-- held responsible for any direct, indirect, consequential
-- or inconsequential damages or lost profits.

-- UNIT: generic package body of VSTRINGS
--
-- FILES: vstring_body.a in publiclib
--        related file is vstring_spec.a in publiclib
--
-- PURPOSE:  An implementation of the abstract data type "variable-length
--           string."
--
-- DESCRIPTION:  This package provides a private type VSTRING.  VSTRING objects
--               are "strings" that have a length between zero and LAST, where
--               LAST is the generic parameter supplied in the package
--               instantiation.
--
--               In addition to the type VSTRING, a subtype and two constants
--               are declared.  The subtype STRINDEX is an index to a VSTRING,
--               The STRINDEX constant FIRST is an index to the first character
--               of the string, and the VSTRING constant NUL is a VSTRING of
--               length zero.  NUL is the default initial value of a VSTRING.
--
--               The following sets of functions, procedures, and operators
--               are provided as operations on the type VSTRING:
--
--               ATTRIBUTE FUNCTIONS:  LEN, MAX, STR, CHAR
--                 The attribute functions return the characteristics of
--                 a VSTRING.
--
--               COMPARISON OPERATORS: "=", "/=", "<", ">", "<=", ">="
--                 The comparison operators are the same as for the predefined
--                 type STRING.
--
--               INPUT/OUTPUT PROCEDURES: GET, GET_LINE, PUT, PUT_LINE
--
--                 The input/output procedures are similar to those for the
--                 predefined type STRING, with the following exceptions:
--
--                   - GET has an optional parameter LENGTH, which indicates
--                     the number of characters to get (default is LAST).
--
--                   - GET_LINE does not have a parameter to return the length
--                     of the string (the LEN function should be used instead).
--
--               EXTRACTION FUNCTIONS: SLICE, SUBSTR, DELETE
--                 The SLICE function returns the slice of a VSTRING between
--                 two indices (equivalent to STR(X)(A .. B)).
--
--                 SUBSTR returns a substring of a VSTRING taken from a given
--                 index and extending a given length.
--
--                 The DELETE function returns the VSTRING which results from
--                 removing the slice between two indices.
--
--               EDITING FUNCTIONS: INSERT, APPEND, REPLACE
--                 The editing functions return the VSTRING which results from
--                 inserting, appending, or replacing at a given index with a
--                 VSTRING, STRING, or CHARACTER.  The index must be in the
--                 current range of the VSTRING; i.e., zero cannot be used.
--
--               CONCATENATION OPERATOR:  "&"
--                 The concatenation operator is the same as for the type
--                 STRING.  It should be used instead of APPEND when the
--                 APPEND would always be after the last character.
--
--               POSITION FUNCTIONS: INDEX, RINDEX
--                 The position functions return an index to the Nth occurrence
--                 of a VSTRING, STRING, or CHARACTER from the front or back
--                 of a VSTRING.  Zero is returned if the search is not
--                 successful.
--
--               CONVERSION FUNCTIONS AND OPERATOR: VSTR, CONVERT, "+"
--                 VSTR converts a STRING or a CHARACTER to a VSTRING.
--
--                 CONVERT is a generic function which can be instantiated to
--                 convert from any given variable-length string to another,
--                 provided the FROM type has a function equivelent to STR
--                 defined for it, and that the TO type has a function equiv-
--                 elent to VSTR defined for it.  This provides a means for
--                 converting between VSTRINGs declared in separate instant-
--                 iations of VSTRINGS.  When instantiating CONVERT for
--                 VSTRINGs, the STR and VSTR functions are implicitly defined,
--                 provided that they have been made visible (by a use clause).
--
--                 Note:  CONVERT is NOT implicitly associated with the type
--                 VSTRING declared in this package (since it would not be a
--                 derivable function (see RM 3.4(11))).
--
--                 Caution:  CONVERT cannot be instantiated directly with the
--                 names VSTR and STR, since the name of the subprogram being
--                 declared would hide the generic parameters with the same
--                 names (see RM 8.3(16)).  CONVERT can be instantiated with
--                 the operator "+", and any instantiation of CONVERT can
--                 subsequently be renamed VSTR or STR.
--
--                 Example:  Given two VSTRINGS instantiations X and Y:
--                   function "+" is new X.CONVERT(X.VSTRING, Y.VSTRING);
--                   function "+" is new X.CONVERT(Y.VSTRING, X.VSTRING);
--
--                   (Y.CONVERT could have been used in place of X.CONVERT)
--
--                   function VSTR(A : X.VSTRING) return Y.VSTRING renames "+";
--                   function VSTR(A : Y.VSTRING) return X.VSTRING renames "+";
--
--                 "+" is equivelent to VSTR.  It is supplied as a short-hand
--                 notation for the function.  The "+" operator cannot immed-
--                 iately follow the "&" operator; use ... & (+ ...) instead.
pragma Page;

--  DISCUSSION:
--
--      This package implements the type "variable-length string" (vstring)
--      using generics.  The alternative approaches are to use a discriminant
--      record in which the discriminant controls the length of a STRING inside
--      the record, or a record containing an access type which points to a
--      string, which can be deallocated and reallocated when necessary.
--
--      Advantages of this package:
--        * The other approaches force the vstring to be a limited private
--          type.  Thus, their vstrings cannot appear on the left side of
--          the assignment operator; ie., their vstrings cannot be given
--          initial values or values by direct assignment.  This package
--          uses a private type; therefore, these things can be done.
--
--        * The other approach stores the vstring in a string whose length
--          is determined dynamically.  This package uses a fixed length
--          string.  This difference might be reflected in faster and more
--          consistent execution times (this has NOT been verified).
--
--      Disadvantages of this package:
--        * Different instantiations must be used to declare vstrings with
--          different maximum lengths (this may be desirable, since
--          CONSTRAINT_ERROR will be raised if the maximum is exceeded).
--
--        * A second declaration is required to give the type declared by
--          the instantiation a name other than "VSTRING."
--
--        * The storage required for a vstring is determined by the generic
--          parameter LAST and not the actual length of its contents.  Thus,
--          each object is allocated the maximum amount of storage, regardless
--          of its actual size.
--
--  MISCELLANEOUS:
--     Constraint checking is done explicitly in the code; thus, it cannot
--     be suppressed.  On the other hand, constraint checking is not lost
--     if pragma suppress is supplied to the compilation (-S option)
--     (The robustness of the explicit constraint checking has NOT been
--     determined).
--
--     Compiling with the optimizer (-O option) may significantly reduce
--     the size (and possibly execution time) of the resulting executable.
--
--     Compiling an instantiation of VSTRINGS is roughly equivelent to
--     recompiling VSTRINGS.  Since this takes a significant amount of time,
--     and the instantiation does not depend on any other library units,
--     it is STRONGLY recommended that the instantiation be compiled
--     separately, and thus done only ONCE.
--
--  USAGE: with VSTRINGS;
--         package package_name is new VSTRINGS(maximum_length);
-- .......................................................................... --
pragma Page;
