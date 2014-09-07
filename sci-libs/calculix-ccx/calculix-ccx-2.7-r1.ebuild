# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs flag-o-matic

MY_P=ccx_${PV}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="
	http://www.dhondt.de/${MY_P}.src.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.ps.tar.bz2 )
	examples? ( http://www.dhondt.de/${MY_P}.test.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arpack doc examples lapack"

RDEPEND="
	arpack? ( sci-libs/arpack )
	lapack? ( virtual/lapack )
	>=sci-libs/spooles-2.2
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/ghostscript-gpl )"

S=${WORKDIR}/CalculiX/${MY_P}/src

src_prepare() {
	#epatch "${FILESDIR}"/01_${MY_P}_Makefile_spooles_arpack.patch
	epatch "${FILESDIR}"/01_${MY_P}_Makefile_custom_cc_flags_spooles_arpack.patch
	use lapack && epatch "${FILESDIR}"/01_${MY_P}_lapack.patch
}

src_configure() {
	use lapack && export LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)

	export BLAS=$($(tc-getPKG_CONFIG) --libs blas)

	#export SPOOLESINC="-I/usr/include/spooles -DSPOOLES"
	append-cflags "-I/usr/include/spooles -DSPOOLES"
	#export SPOOLESLIB="-lspooles -lpthread"
	export USE_MT="-DUSE_MT"

	if use arpack; then
		export ARPACK="-DARPACK"
		export ARPACKLIB=$($(tc-getPKG_CONFIG) --libs arpack)
		append-cflags "${ARPACK}"
	fi
	export CC="$(tc-getCC)"
	export FC="$(tc-getFC)"
}

src_install () {
	dobin ${MY_P}
	dosym ${MY_P} /usr/bin/ccx

	if use doc; then
		cd "${S}/../doc"
		ps2pdf ${MY_P}.ps ${MY_P}.pdf
		dodoc ${MY_P}.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/../test/*
	fi
}
