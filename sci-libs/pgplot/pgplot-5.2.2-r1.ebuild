# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs fortran

FORTRAN="g77"
MY_P="${PN}${PV//.}"
DESCRIPTION="A Fortran- or C-callable, device-independent graphics package for making simple scientific graphs"
HOMEPAGE="http://www.astro.caltech.edu/~tjp/pgplot/"
SRC_URI="ftp://ftp.astro.caltech.edu/pub/pgplot/${MY_P}.tar.gz"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="examples motif"
RDEPEND="|| ( x11-libs/libX11 virtual/x11 )
	media-libs/libpng
	motif? ( virtual/motif )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-drivers.patch
	epatch ${FILESDIR}/${PN}-makemake.patch
	epatch ${FILESDIR}/${PN}-compile-setup.patch
	epatch ${FILESDIR}/${PN}-path.patch

	cp sys_linux/g77_gcc.conf local.conf

	sed -i \
		-e "s:FCOMPL=.*:FCOMPL=\"${FORTRANC}\":g" \
		-e "s:FFLAGOPT=.*:FFLAGOPT=\"${FFLAGS:- -O2}\":g" \
		-e "s:CCOMPL=.*:CCOMPL=\"$(tc-getCC)\":g" \
		-e "s:CFLAGOPT=.*:CFLAGOPT=\"${CFLAGS}\":g" \
		local.conf

	sed -i \
		-e "s:/usr/local/pgplot:/usr/$(get_libdir)/pgplot:" \
		src/grgfil.f

	if use motif; then
		sed -i \
			-e '/XMDRIV/s/!//' \
			drivers.list
	fi
}

src_compile() {
	./makemake ${S} linux

	emake -j1 || die "emake failed"

	# Build C portion
	make cpg || die "make cpg failed"

	# this just cleans out unneeded files
	make clean
}

src_install() {
	insinto /usr/$(get_libdir)/pgplot
	doins grfont.dat grexec.f grpckg1.inc rgb.txt
	dolib.a libpgplot.a
	dolib.so libpgplot.so
	dobin pgxwin_server

	# C binding
	insinto /usr/include
	doins cpgplot.h
	if use motif; then
		doins XmPgplot.h
		dolib.a libXmPgplot.a
	fi
	dolib.a libcpgplot.a

	dodoc aaaread.me pgplot.doc cpg/cpgplot.doc \
		applications/curvefit/curvefit.doc
	dohtml pgplot.html

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/* cpg/cpgdemo.c
		insinto /usr/share/doc/${PF}/pgm
		doins pgmf/* drivers/xmotif/pgmdemo.c
	fi
}
