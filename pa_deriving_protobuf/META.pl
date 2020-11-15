#!/usr/bin/env perl

use strict ;
BEGIN { push (@INC, "..") }
use Version ;

our $destdir = shift @ARGV ;

print <<"EOF";
# Specifications for the "pa_ppx_deriving_protobuf" preprocessor:
version = "$Version::version"
description = "pa_ppx_deriving_protobuf deriver"

  package "runtime" (
    requires = "rresult,fmt,ppx_deriving_protobuf.runtime,uint"
    archive(byte) = "pa_ppx_deriving_protobuf_runtime.cmo"
    archive(native) = "pa_ppx_deriving_protobuf_runtime.cmx"
  )

  requires(toploop) = "camlp5,pa_ppx.deriving_plugins.show,pa_ppx.params_runtime"
  archive(toploop) = "pa_deriving_protobuf.cmo"

    requires(syntax,preprocessor) = "camlp5,pa_ppx.deriving_plugins.show,pa_ppx.params_runtime"
    archive(syntax,preprocessor,-native) = "pa_deriving_protobuf.cmo"
    archive(syntax,preprocessor,native) = "pa_deriving_protobuf.cmx"

  package "link" (
  requires(byte) = "camlp5,pa_ppx.deriving_plugins.show.link,pa_ppx.params_runtime"
  archive(byte) = "pa_deriving_protobuf.cmo"
  )

  requires = "pa_ppx_deriving_protobuf.runtime"

EOF
