# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils fortran-2

DESCRIPTION="High-level interpreted language for numerical analysis"
HOMEPAGE="http://algae.sourceforge.net/"
SRC_URI="mirror://sourceforge/algae/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="intel blas lapack"

DEPEND="
	sci-libs/fftw \
	intel? ( dev-lang/icc dev-lang/ifc )
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/configure.in.patch
		"${FILESDIR}"/Makefile.in-src.patch
		"${FILESDIR}"/Makefile.in-doc.patch
	eautoreconf
}

src_configure() {
	if use intel; then
		F77="ifort" \
		CC="icc" \
		LDFLAGS="-L/opt/intel/compiler80/lib" LIBS="-latlas" \
		econf \
			--with-readline --with-fftw \
			$(use-enable blas ) $(use-enable lapack ) \
			--with-fortran-libs="-limf -lifcore -lifport"
	else
		FLAGS="${FCFLAGS}" econf --with-readline --with-fftw \
			$(use-enable blas ) $(use-enable lapack )
	fi
}

src_compile() {
	emake htmldir="/usr/share/doc/${P}/html"
}

src_install() {
	emake install prefix="${D}usr" htmldir="${D}usr/share/doc/${P}/html"
	dodoc INSTALL NEWS PROBLEMS README VERSION doc/FAQ doc/*ps
}
