# Makefile,v
# Copyright (c) INRIA 2007-2017

TOP=.
include $(TOP)/config/Makefile

WD=$(shell pwd)
DESTDIR=
RM=rm

SYSDIRS= pa_deriving_protobuf

TESTDIRS= tests

PACKAGES := pa_ppx.utils,pa_ppx.base,pa_ppx.import,pa_ppx.deriving

all test: sys
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) all; cd ..; done

sys: plugins

plugins:
	set -e; for i in $(SYSDIRS); do cd $$i; $(MAKE) all; cd ..; done

doc: all
	set -e; for i in $(SYSDIRS); do cd $$i; $(MAKE) doc; cd ..; done
	rm -rf docs
	tools/make-docs pa_ppx_deriving_protobuf docs
	make -C doc html

install: sys
	$(OCAMLFIND) remove pa_ppx_deriving_protobuf || true
	$(OCAMLFIND) install pa_ppx_deriving_protobuf local-install/lib/pa_ppx_deriving_protobuf/*

uninstall:
	$(OCAMLFIND) remove pa_ppx_deriving_protobuf || true

clean::
	set -e; for i in $(SYSDIRS) $(TESTDIRS); do cd $$i; $(MAKE) clean; cd ..; done
	rm -rf docs local-install

depend:
	set -e; for i in $(SYSDIRS) $(TESTDIRS); do cd $$i; $(MAKE) depend; cd ..; done
