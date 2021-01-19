# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions toolchain-funcs

DESCRIPTION="HMM-based cDNA to genome aligner"
HOMEPAGE="https://mblab.wustl.edu/software.html"
#SRC_URI="http://mblab.wustl.edu/software/download/pairagon_.tar"
# ERROR: cannot verify mblab.wustl.edu's certificate, issued by ‘CN=InCommon RSA Server CA,OU=InCommon,O=Internet2,L=Ann Arbor,ST=MI,C=US’:
# Unable to locally verify the issuer's authority.
# To connect to mblab.wustl.edu insecurely, use `--no-check-certificate'.
RESTRICT="fetch"
SRC_URI="pairagon_.tar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

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
