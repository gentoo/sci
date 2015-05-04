# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="A Fortran interface to the GNU Scientific Library"
HOMEPAGE="http://www.lrz.de/services/software/mathematik/gsl/fortran/"
SRC_URI="http://www.lrz.de/services/software/mathematik/gsl/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="static-libs"

DEPEND=">=sci-libs/gsl-1.15
	virtual/fortran"
RDEPEND="${DEPEND}"
#TODO: make docs

FORTRAN_STANDARD=90

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.3-sharedlibs.patch
	use amd64 && ln -s interface/integer_ilp64.finc integer.finc
	use x86 && ln -s interface/integer_ilp32.finc integer.finc
	cat <<- EOF > "${S}/make.inc"
		F90 = $(tc-getFC)
		CC = $(tc-getCC)
		GSL_LIB = $(pkg-config --libs gsl)
		GSL_INC = $(pkg-config --cflags gsl)
		PREFIX = /usr
		ARFLAGS = -csrv
		FPP = -cpp
		LIB = $(get_libdir)
	EOF
	use static-libs && echo "STATIC_LIBS = yes" >> "${S}/make.inc"
}

src_configure() {
:
}

src_install() {
	dodoc NEWS README
	ln -s lib${PN}.so.0.0.0 lib${PN}.so.0
	ln -s lib${PN}.so.0.0.0 lib${PN}.so
	dolib.so lib${PN}.so*
	insinto /usr/include
	doins ${PN}.mod
	if use static-libs ; then
		newlib.a lib${PN}_$(tc-getFC).a lib${PN}.a
	fi
}
