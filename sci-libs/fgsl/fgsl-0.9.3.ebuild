# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="http://www.lrz.de/services/software/mathematik/gsl/fortran/"
SRC_URI="http://www.lrz.de/services/software/mathematik/gsl/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

RDEPEND=">=sci-libs/gsl-1.14"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
#TODO: make docs

FORTRAN_STANDARD=90

src_prepare() {
	epatch "${FILESDIR}"/${P}-sharedlibs.patch
	if use amd64; then
		ln -s interface/integer_ilp64.finc integer.finc || die
	elif use x86; then
		ln -s interface/integer_ilp32.finc integer.finc || die
	else
		die "Don't know who you are"
	fi

	cat <<- EOF > "${S}/make.inc"
		F90 = $(tc-getFC)
		CC = $(tc-getCC)
		GSL_LIB = $($(tc-getPKG_CONFIG) --libs gsl)
		GSL_INC = $($(tc-getPKG_CONFIG) --cflags gsl)
		PREFIX = /usr
		ARFLAGS = -csrv
		FPP = -cpp
		LIB = $(get_libdir)
	EOF

	use static-libs && echo "STATIC_LIBS = yes" >> "${S}/make.inc"
}

src_configure() {
	return
}

src_install() {
	dodoc NEWS README
	ln -s lib${PN}.so.0.0.0 lib${PN}.so.0 || die
	ln -s lib${PN}.so.0.0.0 lib${PN}.so || die
	dolib.so lib${PN}.so*
	insinto /usr/include
	doins ${PN}.mod
	if use static-libs ; then
		newlib.a lib${PN}_$(tc-getFC).a lib${PN}.a
	fi
}
