#
# (C) Copyright 2010
# Hu Chunlin <chunlin.hu@gmail.com>
#
# files.mk - To make my life easier.
#

LOCALINSTALLPATH=$(HOME)/local

MAKEFLAGS += --no-print-directory -r

ifeq ($(D),)
	D = 0
	export D
endif

ifeq ($(T),1)
CROSSPREFIX=$(CROSS_COMPILE)
endif

CFLAGS=-Wall -Werror -fPIC -D__STDC_CONSTANT_MACROS
SLFLAGS=
ifeq ($(D),0)
CFLAGS += -O2 -DNDEBUG
else
ifeq ($(D),s)
CFLAGS += -Os -DNDEBUG
else
CFLAGS += -g
endif
endif
CFLAGS += -DSYS_LOG_LEVEL=$D $(DAPMFLAG) $(DAP_DBG_M_FLAG)
ifneq ($(T),1)
CFLAGS += -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
endif
ifneq ($(NOPCAP),1)
CFLAGS += -DHAVE_PCAP
SLFLAGS += -lpcap
endif
ifneq ($(NOBZIP2),1)
CFLAGS += -DHAVE_BZIP2
SLFLAGS += -lbz2
endif
ifneq ($(NOZLIB),1)
CFLAGS += -DHAVE_ZLIB
SLFLAGS += -lz
endif
ifneq ($(DAPVERSION),)
CFLAGS += -DDAP_VERSION=\"$(DAPVERSION)\"
endif
ifeq ($(TCMALLOC),1)
CFLAGS += -DHAVE_TCMALLOC
SLFLAGS += -ltcmalloc
endif
ifeq ($(PROFILER),1)
CFLAGS += -DHAVE_PROFILER
SLFLAGS += -lprofiler
endif
SLFLAGS += -ldl -lpthread -lrt

ifeq ($(V),1)
Q=
else
Q=@
endif

CC=$(CROSSPREFIX)gcc
CPP=$(CROSSPREFIX)g++
AR=$(CROSSPREFIX)ar
ECHO=/bin/echo -e

REPDIR=$(subst $(ROOTDIR),,$(CURDIR)/)


#-------------------------------------------------------------------------------
# That's our default target when none is given on the command line
#-------------------------------------------------------------------------------
.PHONY: all
all: $(library) $(mexe) $(exe) $(uexe)
	@echo > /dev/null

localinstall: $(library) $(mexe) $(exe) $(uexe)
	@install -d $(LOCALINSTALLPATH)/include
	@if [ "x$(libheaders)" != "x" ]; then \
		$(ECHO) -n "Installing"; \
		for file in $(libheaders); do \
			$(ECHO) -n " $$file"; \
			install $$file $(LOCALINSTALLPATH)/include; \
		done; \
		$(ECHO); \
	fi
	@install -d $(LOCALINSTALLPATH)/lib
	@if [ "x$(library)" != "x" ]; then \
		$(ECHO) -n "Installing"; \
		for file in $(library); do \
			$(ECHO) -n " $$file"; \
			install $$file $(LOCALINSTALLPATH)/lib; \
		done; \
		$(ECHO); \
	fi
	@install -d $(LOCALINSTALLPATH)/bin
	@if [ "x$(mexe)$(exe)$(uexe)" != "x" ]; then \
		$(ECHO) -n "Installing"; \
		for file in $(mexe) $(exe) $(uexe); do \
			$(ECHO) -n " $$file"; \
			install $$file $(LOCALINSTALLPATH)/bin; \
			if [ -f $$file.static ]; then \
				install $$file.static $(LOCALINSTALLPATH)/bin; \
			fi \
		done; \
		$(ECHO); \
	fi

populate_repository:
	@echo > /dev/null

compile_environment: $(library) $(mexe) $(exe) $(uexe)
	@if [ "x$(ROOTDIR)" != "x" ]; then \
		install -d $(ROOTDIR)/dapenv$(REPDIR) ; \
		echo "`git rev-parse --verify HEAD` $(REPDIR)" >> $(ROOTDIR)/dapenv/version ; \
		if [ "x$(libheaders)$(mexe)$(exe)$(uexe)" != "x" ]; then \
			for file in $(libheaders) $(mexe) $(exe) $(uexe); do \
				install $$file $(ROOTDIR)/dapenv/$(REPDIR); \
				if [ -f $$file.static ]; then \
					install $$file.static $(ROOTDIR)/dapenv/$(REPDIR); \
				fi \
			done; \
		fi; \
		if [ "x$(library)" != "x" ]; then \
			for file in $(library); do \
				install $$file $(ROOTDIR)/dapenv/$(REPDIR); \
				install `echo $$file | sed s/.so$$/.a/` $(ROOTDIR)/dapenv/$(REPDIR); \
			done; \
		fi \
	fi

update_environment:
	@echo "Repository $(REPDIR): managed by git, skipped."

runtime_environment: $(library) $(mexe) $(exe) $(uexe)
	@if [ "x$(ROOTDIR)" != "x" ]; then \
		install -d $(ROOTDIR)/dap/bin ; \
		if [ "x$(mexe)$(exe)$(uexe)" != "x" ]; then \
			for file in $(mexe) $(exe) $(uexe); do \
				install $$file $(ROOTDIR)/dap/bin; \
				if [ -f $$file.static ]; then \
					install $$file.static $(ROOTDIR)/dap/bin; \
				fi \
			done; \
		fi; \
		install -d $(ROOTDIR)/dap/lib ; \
		if [ "x$(library)" != "x" ]; then \
			for file in $(library); do \
				install $$file $(ROOTDIR)/dap/lib; \
			done; \
		fi; \
	fi

list:
	@if [ "x$(library)" != "x" ]; then \
		for file in $(library); do \
			echo "library $$file" >> $(ROOTDIR)/binaries.dat ; \
		done; \
	fi
	@if [ "x$(mexe)$(exe)$(uexe)" != "x" ]; then \
		for file in $(mexe) $(exe) $(uexe); do \
			echo "executable $$file" >> $(ROOTDIR)/binaries.dat ; \
		done; \
	fi

#-------------------------------------------------------------------------------
# Miscellaneous
#-------------------------------------------------------------------------------
tag:
	@ctags -R . >/dev/null 2>&1

clean:
	@rm -f $(library) $(mexe) $(exe) $(uexe) $(tempfiles)
	@rm -f $(ROOTDIR)/binaries.dat
	@find . -type f -a \( -name "*.o" -o -name "*.dep" -o -name "*.log" \
		-o -name "*.bak" -o -name "core*" -o -name "*.a" -o -name "*.static" \) -delete

distclean: clean
	@rm -f tags

#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------
$(library): $(libobjs)
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\tGenerating shared library: $@"; \
	fi
	$(Q)$(CPP) -shared -o $@ $(libobjs) $(LIBDEPS) $(SLFLAGS)
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\tGenerating static library: ${@:.so=.a}"; \
	fi
	$(Q)$(AR) -rs ${@:.so=.a} $(libobjs) >/dev/null 2>/dev/null

$(exe): %: %.o $(ROOTDIR)/$(APBLDINFOOBJ)
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\tGenerating executable: $@"; \
	fi
	$(Q)$(CPP) -o $@ $< $(ROOTDIR)/$(APBLDINFOOBJ) $(LIBS) $(SLFLAGS)
	$(Q)$(CPP) -o $@.static $< $(ROOTDIR)/$(APBLDINFOOBJ) $(SLIBS) $(SLFLAGS)

$(mexe): %: $(ROOTDIR)/$(APBLDINFOOBJ)
	@$(MAKE) mexe_target=$@ mexe_objects="$($@-objs)" $@_rule

$(mexe_target)_rule: $(mexe_objects)
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\tGenerating executable: $(mexe_target)"; \
	fi
	$(Q)$(CPP) -o $(mexe_target) $(mexe_objects) $(ROOTDIR)/$(APBLDINFOOBJ) $(LIBS) $(SLFLAGS)
	$(Q)$(CPP) -o $(mexe_target).static $(mexe_objects) $(ROOTDIR)/$(APBLDINFOOBJ) $(SLIBS) $(SLFLAGS)
	@echo "$(mexe_target): $(mexe_objects) $(ROOTDIR)/$(APBLDINFOOBJ)" > $(mexe_target).dep

%.o: %.c
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\t(CC) $<"; \
	fi
	$(Q)$(CC) $(CFLAGS) $(EXTRACFLAGS) $(IPATH) -c -o $@ $<
	@echo -n "`dirname $@`/" > $@.dep
	@$(CC) $(CFLAGS) $(EXTRACFLAGS) $(IPATH) -MM $< >> $@.dep
	@cp -f $@.dep $@.dep.tmp; \
		sed -e 's/.*://' -e 's/\\$$//' $@.dep.tmp | fmt -1 | \
			sed -e 's/^ *//' -e 's/$$/:/' >> $@.dep; \
		rm -f $@.dep.tmp

%.o: %.cpp
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\t(CPP) $<"; \
	fi
	$(Q)$(CPP) $(CFLAGS) $(EXTRACFLAGS) $(IPATH) -c -o $@ $<
	@echo -n "`dirname $@`/" > $@.dep
	@$(CPP) $(CFLAGS) $(EXTRACFLAGS) $(IPATH) -MM $< >> $@.dep
	@cp -f $@.dep $@.dep.tmp; \
		sed -e 's/.*://' -e 's/\\$$//' $@.dep.tmp | fmt -1 | \
			sed -e 's/^ *//' -e 's/$$/:/' >> $@.dep; \
		rm -f $@.dep.tmp

%.c: %.y
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\t(BISON) $<"; \
	fi
	$(Q)bison -o $@ -d $<

%.c: %.l
	@if [ ! -z $(Q) ]; then \
		$(ECHO) "\t(FLEX) $<"; \
	fi
	$(Q)flex -o $@ $<

