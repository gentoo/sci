# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

IUSE="doc"

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/libc
	dev-lang/cfortran"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-cfortran.patch
	cp "${FILESDIR}"/{Makefile.am,configure.ac} .
	eautoreconf
}

src_test() {
	make testprog
	./testprog > testprog.lis
	diff testprog.lis testprog.out || die "test failed"
	cmp testprog.fit testprog.std  || die "failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc changes.txt README License.txt
	insinto /usr/share/doc/${PF}
	doins cookbook.{f,c}
	use doc && dodoc *.ps
}
