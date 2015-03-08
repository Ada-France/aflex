MODE=distrib
GNATMAKE=gnatmake
GNATCLEAN=gnatclean
GPRPATH=aflex.gpr

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = $(INSTALL) -m 755

MAKE_ARGS=-XMODE=${MODE}

prefix = /usr/local
bindir = ${prefix}/bin
mandir = ${prefix}/share/man

all build:
	$(GNATMAKE) -p -P "$(GPRPATH)" $(MAKE_ARGS)

# Not intended for manual invocation.
# Invoked if automatic builds are enabled.
# Analyzes only on those sources that have changed.
# Does not build executables.
autobuild:
	$(GNATMAKE) -gnatc -c -k  -P "$(GPRPATH)" $(MAKE_ARGS)

# Clean the root project of all build products.
clean:
	-$(GNATCLEAN) -q -P "$(GPRPATH)"
	-rm -rf tests

# Check *all* sources for errors, even those not changed.
# Does not build executables.
analyze:
	$(GNATMAKE) -f  -gnatc -c -k  -P "$(GPRPATH)" $(MAKE_ARGS)

# Clean, then build executables for all mains defined by the project.
rebuild: clean build

install:
	$(INSTALL_PROGRAM) bin/aflex ${bindir}
	$(INSTALL) doc/aflex.man $(mandir)/man1/aflex.1


# Targets to rebuild some files from ascan.l and parse.y
lexer:	  bin/aflex
	cd src && ../bin/aflex -mi ascan.l
	cd src && gnatchop -w ascan.ada && rm ascan.ada

parser:
	cd src && ayacc -s -n 300 -e .ada parse.y
	cd src && gnatchop -w parse.ada && rm parse.ada

test:
	mkdir -p tests
	cp src/ascan.l tests/ascan.l
	cd tests && ../bin/aflex -mi ascan.l && gnatchop -w ascan.ada
	@echo -n "Checking generated spec..."
	@(cd tests && cmp scanner.ads ../src/scanner.ads && echo "OK") || (echo "FAILED")
	@echo -n "Checking generated body..."
	@(cd tests && cmp scanner.adb ../src/scanner.adb && echo "OK") || (echo "FAILED")
	@echo -n "Checking generated DFA spec..."
	@(cd tests && cmp ascan_dfa.ads ../src/ascan_dfa.ads && echo "OK") || (echo "FAILED")
	@echo -n "Checking generated DFA body..."
	@(cd tests && cmp ascan_dfa.adb ../src/ascan_dfa.adb && echo "OK") || (echo "FAILED")
	@echo -n "Checking generated IO spec..."
	@(cd tests && cmp ascan_io.ads ../src/ascan_io.ads && echo "OK") || (echo "FAILED")
	@echo -n "Checking generated IO body..."
	@(cd tests && cmp ascan_io.adb ../src/ascan_io.adb && echo "OK") || (echo "FAILED")
