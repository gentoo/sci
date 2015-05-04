# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit fortran-2 toolchain-funcs

DESCRIPTION="a general purpose molecular dynamics simulation package"
HOMEPAGE="http://www.ccp5.ac.uk/DL_POLY_CLASSIC/"
SRC_URI="http://ccpforge.cse.rl.ac.uk/gf/download/frsrelease/255/2627/dl_class_1.9.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/dl_class_1.9/source"

src_prepare() {
	cp ../build/MakeSEQ Makefile || die
}

src_compile() {
	emake -j1 FC=$(tc-getF77) FFLAGS="${FFLAGS} -c" LD="$(tc-getF77) -o" LDFLAGS="${LDFLAGS}" EXE="${PN}" seq
}

src_install() {
	dobin "${PN}"
	dodoc ../README
	use doc && dodoc ../manual/USRMAN.pdf
}
