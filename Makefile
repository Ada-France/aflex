AFLEX_BUILD=distrib
GNATMAKE=gnatmake
GNATCLEAN=gnatclean
GPRBUILD=gprbuild
GPRPATH=aflex.gpr
PROCESSORS=1

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = $(INSTALL) -m 755

MAKE_ARGS=-XAFLEX_BUILD=${AFLEX_BUILD} -XPROCESSORS=$(PROCESSORS)

prefix = /usr/local
bindir = ${prefix}/bin
mandir = ${prefix}/share/man

all build:
	$(GPRBUILD) -p -P "$(GPRPATH)" $(MAKE_ARGS)

# Not intended for manual invocation.
# Invoked if automatic builds are enabled.
# Analyzes only on those sources that have changed.
# Does not build executables.
autobuild:
	$(GNATMAKE) -gnatc -c -k  -P "$(GPRPATH)" $(MAKE_ARGS)

# Clean the root project of all build products.
clean:
	-$(GNATCLEAN) -q -P "$(GPRPATH)"
	-@rm -rf tests
	-@rm -f example_io.* example example.* example_dfa.*
	-@rm -f doc/aflex_user_man.aux doc/aflex_user_man.dvi doc/aflex_user_man.toc

# Check *all* sources for errors, even those not changed.
# Does not build executables.
analyze:
	$(GNATMAKE) -f  -gnatc -c -k  -P "$(GPRPATH)" $(MAKE_ARGS)

# Clean, then build executables for all mains defined by the project.
rebuild: clean build

install:
	mkdir -p $(DESTDIR)${bindir}
	mkdir -p $(DESTDIR)$(mandir)/man1
	$(INSTALL_PROGRAM) bin/aflex $(DESTDIR)${bindir}
	$(INSTALL) man/man1/aflex.1 $(DESTDIR)$(mandir)/man1/aflex.1


# Targets to rebuild some files from ascan.l and parse.y
lexer:	  bin/aflex
	cd src && ../bin/aflex -mi ascan.l
	cd src && gnatchop -w ascan.ada && rm ascan.ada

parser:
	cd src && ayacc -s -E -C -n 300 -e .ada parse.y
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

example: doc/example.l bin/aflex
	bin/aflex -s doc/example.l
	mv example.ada example.adb
	gnatmake example

options: doc/options.l bin/aflex
	bin/aflex -s doc/options.l
	mv options.ada options.adb
	gnatmake options

# Used for Aflex development only: rebuild the embedded templates from `templates/*.ad[bs]` files.
generate:
	@ERRORS=`sed -f templates/check.sed templates/*.ads templates/*.adb` ; \
	if test "T$$ERRORS" = "T"; then \
	   are -o src --rule=are-package.xml --no-type-declaration --var-access --content-only . ; \
	else \
	   echo "Invalid %if <option>, %else or %end option in template:"; \
	   echo $$ERRORS; \
           exit 1 ; \
	fi
