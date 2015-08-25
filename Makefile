#
# (C) Copyright 2007-2010
#
# Kong Dekun <kongdekun999@gmail.com>
#
# Makefile - To make my life easier.
#

ROOTDIR = $(CURDIR)
export ROOTDIR


GITURL0=$(shell grep -Ee "^[[:space:]]{1}url = .*$$" .git/config | \
	awk '{print $$3;}' )
GITBAREMODE=$(shell if echo $(GITURL0) | \
	grep -qEe "/work\.git$$"; then echo 1; else echo 0; fi; )
ifeq ($(GITBAREMODE),1)
	GITURL=$(subst /work.git,,$(GITURL0))/
	GITURLSUFFIX=".git"
else
	GITURL=$(shell echo $(GITURL0) | sed s/\\/$$//g)/
	GITURLSUFFIX=
endif
export GITURL GITBAREMODE GITURLSUFFIX

#SUBDIRS = 

include $(CURDIR)/dirs.mk

