# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Annotation and analysis pipeline for de novo assembled transcriptomes"
HOMEPAGE="http://trinotate.github.io"
SRC_URI="https://github.com/Trinotate/Trinotate/archive/v${PV}.tar.gz"

LICENSE="BSD-BroadInstitute"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/ncbi-tools++
	sci-biology/trinityrnaseq
	sci-biology/TransDecoder"

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

src_install(){
	perl_set_version
	dobin Trinotate
	insinto /usr/share/"${PN}"
	doins -r admin java sample_data util TrinotateWeb
	insinto ${VENDOR_LIB}/${PN}
	doins -r PerlLib/*
	dodoc Release.Notes
}
