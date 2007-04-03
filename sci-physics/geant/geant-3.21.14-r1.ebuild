# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib fortran

DEB_PN="${PN}321"
DEB_PV="${PV}.dfsg"
DEB_PR="4"

DESCRIPTION="CERN's Detector Description and Simulation Tool "
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/geant/index.html"
LICENSE="GPL-2 LGPL-2"
SRC_URI="mirror://debian/pool/main/g/${DEB_PN}/${DEB_PN}_${DEB_PV}.orig.tar.gz
	mirror://debian/pool/main/g/${DEB_PN}/${DEB_PN}_${DEB_PV}-${DEB_PR}.diff.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="=sci-physics/cernlib-2006*
	sci-physics/paw"

S=${WORKDIR}/${DEB_PN}-${DEB_PV}.orig

FORTRAN="gfortran g77 ifc"

src_unpack() {
	fortran_src_unpack ${A}

	cd "${WORKDIR}"
	epatch ${DEB_PN}_${DEB_PV}-${DEB_PR}.diff || die "epatch failed"

	cd "${S}"
	cp debian/add-ons/Makefile .
	sed -i \
		-e "s:/usr/local:/usr:g" \
		Makefile || die "sed failed"
	make \
		DEB_BUILD_OPTIONS="${FORTRANC} nostrip" \
		patch &> /dev/null || die "make patch failed"
}

src_compile() {
	emake -j1 DEB_BUILD_OPTIONS="${FORTRANC} nostrip" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt copyright
	newdoc add-ons/README README.addons
}
