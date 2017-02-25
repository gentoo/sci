# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Design degenerate primers"
HOMEPAGE="http://mblab.wustl.edu/software.html"
SRC_URI="http://mblab.wustl.edu/software/download/primerD.tar.gz -> primerD-1.0.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}"/primerD

src_prepare(){
	sed -e "s:CC=g++:CC=$(tc-getCXX):; s:-Wall -g:${CFLAGS}:" -i Makefile || die
}

src_install(){
	dodoc README
	dobin primerD
}
