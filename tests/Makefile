# Makefile,v
# Copyright (c) INRIA 2007-2017

WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile

PACKAGEPREFIX=pa_ppx.

DESTDIR=
RM=rm

LAUNCH=env TOP=$(TOP) $(TOP)/tools/LAUNCH
OCAMLFIND=$(LAUNCH) ocamlfind
NOT_OCAMLFIND=$(LAUNCH) not-ocamlfind
MKCAMLP5=$(LAUNCH) mkcamlp5
PACKAGES := $(PACKAGES),ounit2,fmt,pcre,rresult,compiler-libs.common,sexplib,uint,pa_ppx.utils

PPXPACKAGES:=ppx_deriving.show,ppx_deriving_protobuf

PAPACKAGES:=$(PAPACKAGES),pa_ppx_deriving_protobuf

ALL_PACKAGES := $(PACKAGES),$(PAPACKAGES),$(PPXPACKAGES)

CMO=
CMI := $(CMO:.cmo=.cmi)
CMX := $(CMO:.cmo=.cmx)

TESTS= \
	test_syntax.ppx.byte \
	test_syntax.byte \


all test: $(CMO) $(TESTS) $(TESTS:.byte=)

% : %.byte
	mkdir -p _build && ./$<

test_%.byte: test_%.ml
	rm -f test_syntax_pappx.ml
	cppo -D PAPPX $< > $<.pappx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),$(PAPACKAGES),camlp5.pr_o \
	-syntax camlp5o $<.pappx.ml \
	| perl -p -e 's,#.*$$,,' \
	> $<.pappx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) $(WARNERR) -package $(PACKAGES),$(PAPACKAGES) \
	-linkpkg -syntax camlp5o -impl $<.pappx.ml -o $@

test_%.ppx.byte: test_%.ml
	cppo -U PAPPX $< > $<.ppx.ml
	$(NOT_OCAMLFIND) preprocess -package $(PACKAGES),ounit2,$(PPXPACKAGES) $<.ppx.ml > $<.ppx.ppo
	$(OCAMLFIND) ocamlc $(DEBUG) -custom $(WARNERR) -package $(PACKAGES),ounit2,$(PPXPACKAGES),ppx_deriving_protobuf.runtime -linkpkg $<.ppx.ml -o $@

clean::
	rm -f *.corrected *.pappx.ml *.ppx.ml *.ppo.*

EXTERNAL := $(shell $(OCAMLFIND) query -predicates byte -format '%m' $(ALL_PACKAGES) | grep local-install)
$(CMO): $(EXTERNAL)

depend::
	echo "$(CMO): $(EXTERNAL)" > .depend.NEW
	$(OCAMLFIND) ocamldep $(DEBUG) $(WARNERR) -package $(PACKAGES) -syntax camlp5o \
	test_*.ppx.ml \
	test_*.pappx.ml \
	>> .depend.NEW
	mv .depend.NEW .depend

-include .depend
