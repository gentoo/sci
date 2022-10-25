# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs
MY_P=${PN}-v${PV}

DESCRIPTION="Rapid numerical evaluation of generalised polylogarithms"
HOMEPAGE="https://gitlab.com/mule-tools/handyg"
SRC_URI="https://gitlab.com/mule-tools/${PN}/-/archive/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/fortran
"

PATCHES=(
    "${FILESDIR}"/${P}-so.patch
)

src_configure() {
	tc-export CC CXX FC AR
	FFLAGS="${FFLAGS} -fPIC" LD="${FC}" ./configure --prefix=${EPREFIX}/usr LDFLAGS="${LDFLAGS}"
}

src_compile() {
	# single thread force needed since fortan mods depend on each other 	
	export MAKEOPTS=-j1
	emake all
}

src_install() {
	dolib.a libhandyg.a
	dolib.so libhandyg.so
	doheader handyg.mod
	dobin geval
}

