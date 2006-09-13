# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 flag-o-matic

DESCRIPTION="Celestial orbit reconstruction, simulation and analysis"
HOMEPAGE="http://orsa.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="opengl qt3 mpi ginac cln gsl fftw xinerama threads static"

DEPEND=">=sys-libs/readline-4.2
	fftw?  ( =sci-libs/fftw-2.1* )
	gsl?   ( >=sci-libs/gsl-1.5 )
	qt3?   ( $(qt_min_version 3.3) )
	mpi?   ( sys-cluster/lam-mpi )
	ginac? ( >=sci-mathematics/ginac-1.2.0 )
	cln?   ( >=sci-libs/cln-1.1.6 )"

replace-flags k6-3 i586
replace-flags k6-2 i586
replace-flags k6 i586

src_unpack() {
	unpack ${A}
	# patch backward compatible with gcc-3
	epatch "${FILESDIR}"/${P}-gcc41.patch
}

src_compile() {
	local myconf=""
	use mpi || export MPICXX="g++"
	use ginac || myconf="--with-ginac-prefix=/no/such/file"
	use gsl || myconf="${myconf} --with-gsl-prefix=/no/such/file"
	use cln || myconf="${myconf} --with-cln-prefix=/no/such/file"
	use fftw || sed -i -e 's/have_fftw=yes/have_fftw=no/' configure
	if ! use qt3; then
		myconf="${myconf} --with-qt-dir=/no/such/file"
	else
		addwrite "${QTDIR}/etc/settings"
	fi

	econf \
		${myconf} \
		$(use_with mpi) \
		$(use_with opengl gl) \
		$(use_with threads) \
		$(use_with xinerama) \
		$(use_enable static) \
		|| die "econf failed"

	if use mpi; then
		sed -e 's/\(orsa_LDADD = .*\)/\1 -llammpi++ -lmpi -llam -lpthread -lutil/' \
			-i src/orsa/Makefile
	fi

	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	# INSTALL README ChangeLog empty
	dodoc AUTHORS COPYRIGHT DEVELOPERS TODO THANKS
	insinto /usr/share/doc/${P}/test
	doins src/test/*.{cc,h,fft,ggo}
}
