/*
 Copyright (c) 1990 Regents of the University of California.
 All rights reserved.

 This software was developed by John Self of the Arcadia project
 at the University of California, Irvine.

 Redistribution and use in source and binary forms are permitted
 provided that the above copyright notice and this paragraph are
 duplicated in all such forms and that any documentation,
 advertising materials, and other materials related to such
 distribution and use acknowledge that the software was developed
 by the University of California, Irvine.  The name of the
 University may not be used to endorse or promote products derived
 from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
*/

/* -------------------------------------------------------------------- */
/*               -- C routine Get_Argument --                           */
/* -------------------------------------------------------------------- */

short get_argument (position, arg_ptr)

short  position; /* position number of argument to be returned */
char  *arg_ptr;  /* pointer to string in which to store argument */

{
    extern int ada__argc_save;    /* number of command line arguments */
    extern char **ada__argv_save; /* pointers to command line arguments */

    short strndx;  /* loop counter/string index */
    char  c;       /* temporary character */

    /* check argument position number */
    if (position > ada__argc_save - 1) return (0);

    /* one pass for every character in the parameter */
    /* until the null character at the end of the    */
    /* parameter is found                            */
    for (strndx = 0 ; c = ada__argv_save[position][strndx] ; strndx++)
            arg_ptr[strndx] = c;

    return (strndx); /* return the length of the string */
}
