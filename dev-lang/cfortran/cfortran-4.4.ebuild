# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DEB_PVER=9
DESCRIPTION="Header file allowing to call Fortran routines from C and C++"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz
         http://ftp.debian.org/debian/pool/main/c/${PN}/${PN}_${PV}-${DEB_PVER}.diff.gz"
HOMEPAGE="http://www-zeus.desy.de/~burow/cfortran/"
KEYWORDS="~x86 ~amd64"
LICENSE="LGPL"
IUSE=""
SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${PN}_${PV}-${DEB_PVER}.diff
	tar -xzf cfortran.examples.tar.gz
	# rename eg to examples and correct bad links
	mv eg examples
	ln -sfn sz1.c examples/sz1/sz1.C
	ln -sfn pz.c examples/pz/pz.C
}

src_compile() {
        einfo "No compilation neccessary"
}

src_install() {
	insinto /usr/include
	doins cfortran.h
	dodoc cfortran.doc
	insinto /usr/share/doc/${P}
	doins -r cfortest.c  cfortran.doc cfortran.html \
		index.htm cfortex.f debian examples
}
