# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="De novo short read OLC assembler (overlap-layout-consensus)"
HOMEPAGE="http://www.genomic.ch/edena.php"
SRC_URI="http://www.genomic.ch/edena/EdenaV"${PV}".tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/EdenaV"${PV}"

src_prepare(){
	sed -e "s@^CCC.*@CCC = $(tc-getCXX)@" -e "s@^CFLAGS.*@CFLAGS = ${CFLAGS} -pthread@" -i src/Makefile || die
}

src_compile(){
	cd src
	default
}

src_install(){
	dobin src/edena
	dodoc referenceManual.pdf
}
