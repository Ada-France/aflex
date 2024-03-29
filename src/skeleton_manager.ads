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

-- TITLE skeleton manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION outputs skeleton sections when called by gen.
-- NOTES allows use of internal or external skeleton
-- $Header: /co/ua/self/arcadia/aflex/ada/src/RCS/skeleton_managerS.a,v 1.3 90/01/12 15:20:38 self Exp Locker: self $

package Skeleton_Manager is
   procedure Skelout;
   procedure Set_External_Skeleton;
end Skeleton_Manager;
