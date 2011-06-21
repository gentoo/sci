# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fortran-2

DESCRIPTION="high-level interpreted language for numerical analysis"

HOMEPAGE="http://algae.sourceforge.net/"

SRC_URI="mirror://sourceforge/algae/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE="icc blas lapack"

DEPEND="sci-libs/fftw \
	icc? ( dev-lang/icc dev-lang/ifc ) \
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/configure.in.patch" || die "epatch configure.in failed"
	epatch "${FILESDIR}/Makefile.in-src.patch" || die "epatch src/Makefile.in failed"
	epatch "${FILESDIR}/Makefile.in-doc.patch" || die "epatch doc/Makefile.in failed"
}

src_compile() {
	autoconf
	if use icc; then
		F77="ifort" FFLAGS="-O3 -axKWNBP -ip" \
		CC="icc" CFLAGS="-O3 -axKWNBP -ip" \
		LDFLAGS="-L/opt/intel/compiler80/lib" LIBS="-latlas" \
		econf \
			--with-readline --with-fftw \
			$(use-enable blas ) $(use-enable lapack ) \
			--with-fortran-libs="-limf -lifcore -lifport" \
				|| die "econf failed"
	else
		FLAGS="${CFLAGS}" econf --with-readline --with-fftw \
			$(use-enable blas ) $(use-enable lapack ) \
				|| die "econf failed"
	fi

	emake htmldir="/usr/share/doc/${P}/html" || die "emake failed"
}

src_install() {
	dodoc INSTALL NEWS PROBLEMS README VERSION doc/FAQ
	dodir /usr/share/doc/${P}/html
	make install prefix="${D}usr" htmldir="${D}usr/share/doc/${P}/html" \
		|| die "make install failed"
	insinto /usr/share/doc/${P}
	doins doc/*ps
}

pkg_postinst() {
	ln -s "/usr/bin/${P}" "/usr/bin/${PN}"
	ln -s "/usr/share/doc/${P}/html" "/usr/share/${PN}/html"
}

pkg_prerm() {
	rm -f "/usr/bin/${PN}"
	rm -f "/usr/share/${PN}/html"
}
