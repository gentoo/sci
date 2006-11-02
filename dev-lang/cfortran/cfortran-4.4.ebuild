# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DEB_PR="10"

DESCRIPTION="Header file allowing to call Fortran routines from C and C++"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/c/${PN}/${PN}_${PV}-${DEB_PR}.diff.gz"
HOMEPAGE="http://www-zeus.desy.de/~burow/cfortran/"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2"
IUSE="examples"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${PN}_${PV}-${DEB_PR}.diff
	if use examples; then
		unpack "${PN}".examples.tar.gz
		mv eg examples
		ln -sfn sz1.c examples/sz1/sz1.C
		ln -sfn pz.c examples/pz/pz.C
	fi
}

src_compile() {
	einfo "No compilation neccessary"
}

src_install() {
	insinto /usr/include/cfortran
	doins cfortran.h
	dosym /usr/include/cfortran/cfortran.h /usr/include/cfortran.h
	dodoc cfortran.doc debian/{NEWS,changelog,copyright}
	insinto /usr/share/doc/${PF}
	doins cfortran.html index.htm  cfortest.c cfortex.f
	use examples && doins -r examples
}
