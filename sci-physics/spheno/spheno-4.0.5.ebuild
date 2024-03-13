# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs fortran-2

MY_PN=SPheno
MY_P=${MY_PN}-${PV}

DESCRIPTION="SPheno stands for S(upersymmetric) Pheno(menology)"
HOMEPAGE="https://spheno.hepforge.org/"
SRC_URI="https://spheno.hepforge.org/downloads/?f=${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="all-rights-reserved"
RESTRICT="bindist mirror"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}"/${P}-gfortran.patch )

src_compile() {
	# single thread force needed since fortan mods depend on each other
	emake -j1 F90="${FC}"
}

src_install() {
	dobin bin/${MY_PN}
	# convenience symlink since the package is lowercase but the default produced binary is uppercase
	dosym ${MY_PN} /usr/bin/${PN}
	dolib.a lib/lib${MY_PN}.a
	mv include ${PN}
	doheader -r ${PN}
	dodoc doc/*
	docinto examples
	dodoc input/*
	docompress -x /usr/share/doc/${PF}/examples
}
