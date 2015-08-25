#
# (C) Copyright 2010
#
# Kong Dekun <kongdekun999@gmail.com>
#
# dirs.mk - To make my life easier.
#

MAKEFLAGS += --no-print-directory -r

REPDIR=$(subst $(ROOTDIR),,$(CURDIR)/)
ifeq ($(GITBAREMODE),1)
	REPNAME=$(shell echo $(REPDIR) | sed s/^\\///g | sed s/\\/$$//g | \
				sed s/\\//_/g | sed s/.$$/\&_/g )
else
	REPNAME=$(shell echo $(REPDIR) | sed s/^\\///g )
endif

.PHONY : $(SUBDIRS)

all:
	@for dir in $(SUBDIRS) ; do \
		if [ -f $$dir/Makefile ]; then \
			$(MAKE) -C $$dir ; \
		fi \
	done

localinstall: all
	@for dir in $(SUBDIRS) ; do \
		if [ -f $$dir/Makefile ]; then \
			$(MAKE) -C $$dir localinstall ; \
		fi \
	done

list:
	@for dir in $(SUBDIRS) ; do \
		if [ -f $$dir/Makefile ]; then \
			$(MAKE) -C $$dir list ; \
		fi \
	done

clean:
	@for dir in $(SUBDIRS) ; do \
		if [ -f $$dir/Makefile ]; then \
			$(MAKE) -C $$dir clean ; \
		fi \
	done

distclean:
	@for dir in $(SUBDIRS) ; do \
		if [ -f $$dir/Makefile ]; then \
			$(MAKE) -C $$dir distclean ; \
		fi \
	done
	@rm -f tags

tag:
	@ctags -R . >/dev/null 2>&1

