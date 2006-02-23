# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"

S=${WORKDIR}/${PN}

src_compile() {
	econf --prefix=${D}usr || die "econf failed"
	sed -i -e "s:CFITSIO_LIB = /usr/lib:CFITSIO_LIB = ${D}usr/lib:g" Makefile
	sed -i -e "s:CFITSIO_INCLUDE =	/usr/include:CFITSIO_INCLUDE = ${D}usr/include:g" Makefile
	emake || die "emake failed"
	make shared fitscopy imcopy listhead
}

src_test() {
	make testprog
	./testprog > testprog.lis
	diff testprog.lis testprog.out || die "test failed"
	cmp testprog.fit testprog.std  || die "failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dobin fitscopy imcopy listhead
	dodoc changes.txt README License.txt
	insinto /usr/share/doc/${P}
	doins cookbook.{f,c}
	use doc && dodoc *.ps
}
