# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs flag-o-matic fortran-2

MY_P=ccx_${PV/_/}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="
	http://www.dhondt.de/${MY_P}.src.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.ps.tar.bz2 )
	examples? ( http://www.dhondt.de/${MY_P}.test.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arpack doc examples openmp threads"

RDEPEND="
	arpack? ( >=sci-libs/arpack-3.1.3 )
	>=sci-libs/spooles-2.2[threads=]
	virtual/lapack
	virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-text/ghostscript-gpl )"

S=${WORKDIR}/CalculiX/${MY_P}/src

PATCHES=(
	"${FILESDIR}/01_${MY_P}_Makefile_custom_cc_flags_spooles_arpack.patch"
)

src_configure() {
	# Technically we currently only need this when arpack is not used.
	# Keeping things this way in case we change pkgconfig for arpack
	export LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)

	append-cflags "-I/usr/include/spooles -DSPOOLES"
	if use threads; then
		append-cflags "-DUSE_MT"
	fi

	if use openmp; then
		append-fflags "-fopenmp"
		append-cflags "-fopenmp"
	fi

	if use arpack; then
		export ARPACKLIB=$($(tc-getPKG_CONFIG) --libs arpack)
		append-cflags "-DARPACK"
	fi
	export CC="$(tc-getCC)"
	export FC="$(tc-getFC)"
}

src_install () {
	dobin ${MY_P}
	dosym ${MY_P} /usr/bin/ccx

	if use doc; then
		cd "${S}/../doc" || die
		ps2pdf ${MY_P}.ps ${MY_P}.pdf || die "ps2pdf failed"
		dodoc ${MY_P}.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/../test/*
	fi
}
