# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Design degenerate primers"
HOMEPAGE="https://mblab.wustl.edu/software.html"
#SRC_URI="https://mblab.wustl.edu/software/download/primerD.tar.gz -> primerD-1.0.tar.gz"
# ERROR: cannot verify mblab.wustl.edu's certificate, issued by ‘CN=InCommon RSA Server CA,OU=InCommon,O=Internet2,L=Ann Arbor,ST=MI,C=US’:
# Unable to locally verify the issuer's authority.
# To connect to mblab.wustl.edu insecurely, use `--no-check-certificate'.
RESTRICT="fetch"
SRC_URI="primerD.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}"/primerD

src_prepare(){
	sed -e "s:CC=g++:CC=$(tc-getCXX):; s:-Wall -g:${CFLAGS}:" -i Makefile || die
}

src_install(){
	dodoc README
	dobin primerD
}
