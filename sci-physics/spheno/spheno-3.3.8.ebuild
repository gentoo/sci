# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=SPheno
MY_P=${MY_PN}-${PV}

DESCRIPTION="SPheno stands for S(upersymmetric) Pheno(menology)"
HOMEPAGE="https://spheno.hepforge.org/"
SRC_URI="https://spheno.hepforge.org/downloads/?f=${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
RESTRICT="bindist mirror"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"
DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-gfortran.patch )

S="${WORKDIR}/${MY_P}"

src_compile() {
	# single thread force needed since fortan mods depend on each other
	export MAKEOPTS=-j1
	emake
}

src_install() {
	dobin bin/${MY_PN}
	# convenience symlink since the package is lowercase but the default produced binary is uppercase
	dosym ${EPREFIX}/usr/bin/${MY_PN} /usr/bin/${PN}
	dolib.a lib/lib${MY_PN}.a
	doheader include/*

	use doc && dodoc doc/*
}
