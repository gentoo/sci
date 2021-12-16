# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Annotation and analysis pipeline for de novo assembled transcriptomes"
HOMEPAGE="https://github.com/Trinotate/Trinotate.github.io/wiki"
SRC_URI="https://github.com/Trinotate/Trinotate/archive/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/ncbi-tools++
	sci-biology/trinityrnaseq
	sci-biology/TransDecoder
"

# http://www.cbs.dtu.dk/cgi-bin/sw_request?rnammer
# >=sci-biology/rnammer-2.3.2
#
# http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?signalp
# >=sci-biology/signalp-4
#
# http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?tmhmm

# We suggest you rename this version of hmmsearch from hmmer-2 package to 'hmmsearch2'.
# In the 'rnammer' software configuration, edit the rnammer script to point
# $HMMSEARCH_BINARY = "/path/to/hmmsearch2";

S="${WORKDIR}/${PN}-${PN}-v${PV}"

src_install(){
	perl_set_version
	dobin Trinotate
	insinto /usr/share/"${PN}"
	doins -r admin sample_data util TrinotateWeb
	perl_domodule -r PerlLib/*
	dodoc notes README.md README.txt Changelog.txt
}
