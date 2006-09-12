# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib fortran

DEB_PV="${PV}.dfsg"
DEB_PR="1"

DESCRIPTION="CERN's Detector Description and Simulation Tool "
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/geant/index.html"
LICENSE="GPL-2 LGPL-2"
SRC_URI="mirror://debian/pool/main/g/${PN}/${PN}_${DEB_PV}.orig.tar.gz
	mirror://debian/pool/main/g/${PN}/${PN}_${DEB_PV}-${DEB_PR}.diff.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sci-physics/cernlib"

S=${WORKDIR}/${PN}-${DEB_PV}.orig

FORTRAN="g77 ifc"

src_unpack() {
	unpack ${A}
	epatch ${PN}_${DEB_PV}-${DEB_PR}.diff || die "epatch failed"
	cd "${S}"
	cp debian/add-ons/Makefile .
	sed -i \
		-e "s:/usr/local:/usr:g" \
		Makefile
	einfo "Applying Debian patches"
	make patch &> /dev/null || die "make patch failed"
}


src_compile() {
	make || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	cd "${S}"/debian
	docinto debian
	dodoc changelog README.* deadpool.txt copyright
	docinto debian/add-ons
	dodoc add-ons/README
}
