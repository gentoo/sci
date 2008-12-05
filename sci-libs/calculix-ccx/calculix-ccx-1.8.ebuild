# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=ccx_${PV}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="http://www.dhondt.de/${MY_P}.src.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.ps.tar.bz2 )
	examples? ( http://www.dhondt.de/${MY_P}.test.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arpack doc examples lapack threads"

DEPEND="arpack? ( >=sci-libs/arpack-96 )
	doc? ( virtual/ghostscript )
	lapack? ( virtual/lapack )
	>=sci-libs/spooles-2.2
	virtual/blas"

S=${WORKDIR}/CalculiX

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/01_${MY_P}_Makefile.patch
	use lapack && epatch "${FILESDIR}"/01_${MY_P}_lapack.patch
}

src_compile () {
	use lapack && export LAPACK=`pkg-config --libs lapack`

	export BLAS=`pkg-config --libs blas`

	export SPOOLESINC="-I/usr/include/spooles -DSPOOLES"
	export SPOOLESLIB="-lspooles"
	if use threads; then
		export USE_MT="-DUSE_MT"
		export SPOOLESLIB="-lspooles -lpthread"
	fi

	if use arpack; then
		export ARPACK="-DARPACK"
		export ARPACKLIB="-larpack"
	fi

	cd ${MY_P}/src
	emake || die "emake failed"
}

src_install () {
	cd ${MY_P}/src
	dobin ${MY_P} || die "dobin failed"
	dosym ${MY_P} /usr/bin/ccx

	if use doc; then
		insinto /usr/share/doc/${PF}
		cd "${S}/${MY_P}/doc"
		ps2pdf ${MY_P}.ps ${MY_P}.pdf
		doins ${MY_P}.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/${MY_P}/test/*
	fi
}
