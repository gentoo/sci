# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fortran autotools

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fortran"

DEPEND="fortran? ( dev-lang/cfortran )"
FORTRAN="gfortran g77 ifc"
S=${WORKDIR}/${PN}

pkg_setup() {
	use fortran && fortran_pkg_setup
}

src_unpack() {
	if use fortran; then
		fortran_src_unpack ${A}
		export FC="${FORTRANC}"
		sed -i \
			-e 's:"cfortran.h":<cfortran.h>:' \
			"${S}"/f77_wrap.h || die "sed failed"
	else
		unpack ${A}
	fi
	cd "${S}"
	cp "${FILESDIR}"/${P}-Makefile.am Makefile.am
	cp "${FILESDIR}"/${P}-configure.ac configure.ac
	eautoreconf
}

src_test() {
	make testprog
	./testprog > testprog.lis
	diff testprog.lis testprog.out || die "test failed"
	cmp testprog.fit testprog.std  || die "failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc changes.txt README License.txt
	insinto /usr/share/doc/${PF}
	doins cookbook.{f,c}
	use doc && dodoc *.ps
}
