# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 toolchain-funcs

DESCRIPTION="a general purpose molecular dynamics simulation package"
HOMEPAGE="http://www.ccp5.ac.uk/DL_POLY_CLASSIC/"
SRC_URI="https://gitlab.com/DL_POLY_Classic/dl_poly/-/archive/RELEASE-${PV//./-}/${PN}-RELEASE-${PV//./-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="virtual/mpi[fortran]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-RELEASE-${PV//./-}/source"

src_prepare() {
	default
	cp ../build/MakeSEQ Makefile || die
}

src_compile() {
	emake -j1 FC=$(tc-getF77) FFLAGS="${FFLAGS} -c" LD="$(tc-getF77) -o" LDFLAGS="${LDFLAGS}" EXE="${PN}" seq
}

src_install() {
	newbin "${PN}" DLPOLY.Z
	dodoc ../README
	use doc && dodoc ../manual/USRMAN.pdf
}
