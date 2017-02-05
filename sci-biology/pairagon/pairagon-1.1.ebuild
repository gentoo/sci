# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="HMM-based cDNA to genome aligner"
HOMEPAGE="http://mblab.wustl.edu/software.html"
SRC_URI="http://mblab.wustl.edu/software/download/pairagon_.tar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/pairagon

src_prepare(){
	sed -e 's:src/get-glib-flags.sh:#src/get-glib-flags.sh:; s:-Wall -Werror::' -i Makefile
	sed -e 's/^use Alignment/use pairagon::Alignment/' -i bin/alignmentConvert.pl || die
}

src_compile(){
	emake pairagon-linux
}

src_install(){
	dobin bin/pairagon bin/pairameter_estimate bin/Pairagon.pl bin/alignmentConvert.pl
	dodoc README
	perl_set_version
	insinto /usr/share/pairagon
	doins parameters/*
	insinto ${VENDOR_LIB}/${PN}
	doins lib/perl5/Alignment.pm
}
