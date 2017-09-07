# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions toolchain-funcs

DESCRIPTION="HMM-based cDNA to genome aligner"
HOMEPAGE="http://mblab.wustl.edu/software.html"
SRC_URI="http://mblab.wustl.edu/software/download/pairagon_.tar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl:="
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	sed -e 's:src/get-glib-flags.sh:#src/get-glib-flags.sh:; s:-Wall -Werror::' \
		-i Makefile || die
	sed -e 's/^use Alignment/use pairagon::Alignment/' \
		-i bin/alignmentConvert.pl || die
}

src_compile() {
	emake pairagon-linux
}

src_install() {
	dobin bin/{pairagon,pairameter_estimate,Pairagon.pl,alignmentConvert.pl}
	einstalldocs

	insinto /usr/share/pairagon
	doins -r parameters/.

	perl_domodule -C ${PN} lib/perl5/Alignment.pm
}
