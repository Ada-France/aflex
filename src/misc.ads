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

-- TITLE  miscellaneous aflex routines
-- AUTHOR: John Self (UCI)
-- DESCRIPTION
-- NOTES contains functions used in various places throughout aflex.
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/miscS.a,v 1.9 90/01/12 15:20:19 self Exp Locker: self $
--
-- 2004/10/16 Thierry Bernier
-- + Add support for Ada95 parent/child units

with Misc_Defs, Tstring, Text_Io;
package Misc is
   use Misc_Defs;
   use Tstring;
   use Text_Io;
   procedure Action_Out;
   procedure Bubble (V : in Int_Ptr; N : in Integer);
   function Clower (C : in Integer) return Integer;
   procedure Cshell (V : in out Char_Array; N : in Integer);
   procedure Dataend;
   procedure Dataflush;
   procedure Dataflush (File : in File_Type);
   function Aflex_Gettime return Vstring;
   procedure Aflexerror (Msg : in Vstring);
   procedure Aflexerror (Msg : in String);
   function All_Upper (Str : in Vstring) return Boolean;
   function All_Lower (Str : in Vstring) return Boolean;
   procedure Aflexfatal (Msg : in Vstring);
   procedure Aflexfatal (Msg : in String);
   procedure Line_Directive_Out;
   procedure Line_Directive_Out (Output_File_Name : in File_Type);
   procedure Mk2data (Value : in Integer);
   procedure Mk2data (File : in File_Type; Value : in Integer);
   procedure Mkdata (Value : in Integer);
   function Myctoi (Num_Array : in Vstring) return Integer;
   function Myesc (Arr : in Vstring) return Character;
   function Otoi (Str : in Vstring) return Character;
   function Readable_Form (C : in Character) return Vstring;
   procedure Synerr (Str : in String);
   procedure Transition_Struct_Out (Element_V, Element_N : in Integer);
   function Set_Yy_Trailing_Head_Mask (Src : in Integer) return Integer;
   function Check_Yy_Trailing_Head_Mask (Src : in Integer) return Integer;
   function Set_Yy_Trailing_Mask (Src : in Integer) return Integer;
   function Check_Yy_Trailing_Mask (Src : in Integer) return Integer;
   function Islower (C : in Character) return Boolean;
   function Isupper (C : in Character) return Boolean;
   function Isdigit (C : in Character) return Boolean;
   function Tolower (C : in Integer) return Integer;
   function Basename return Vstring;
   procedure Set_Unitname (Str : in Vstring);
   function Unitname return Vstring;
   function Package_Name return String;
   procedure Set_Filename (Str : in Vstring);
   procedure Set_Option (Opt : in Vstring);
   procedure Set_YYDecl (Str : in Vstring);
   procedure Set_YYVar (Str : in Vstring);
   function Get_YYLex_Declaration return String;
   function Get_YYLex_Name return String;
   function Get_YYVar_Name return String;
end Misc;
