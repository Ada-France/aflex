-- Handle Foreign Command
--
-- This procedure supports the use of the VAX/VMS Foreign Command facility
-- in a way similar to that used by the VAX C runtime argc/argv mechanism.
--
-- The program is to be 'installed as a foreign command':
--
--    $ foo :== $disk:[directories]foo
--
-- after which the parameters to a command such as
--
--    $ foo -x bar
--
-- are obtainable.
--
-- In this case, Handle_Argument is called as:
--
--    Handle_Argument (Argument_count'First, "-x");
--    Handle_Argument (Argument_Count'First + 1, "bar");
--
-- As with VAX C,
--    (a) one level of quotes '"' is stripped.
--    (b) arguments not in quotes are converted to lower-case (so, if you
--        need upper-case, you _must_ quote the argument).
--    (c) only white space delimits arguments, so "-x" and -"x" are the same.
--
-- 2.9.92 sjw; orig

generic

  type Argument_Count is range <>;

  with procedure Handle_Argument (Count : Argument_Count; Argument : String);

procedure Handle_Foreign_Command;
