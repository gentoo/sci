# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib fortran

DEB_PV="${PV}.dfsg"
DEB_PR="1"

DESCRIPTION="CERN's Physics Analysis Workstation data analysis program"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/paw/index.html"
LICENSE="BSD"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${DEB_PV}.orig.tar.gz
	mirror://debian/pool/main/p/${PN}/${PN}_${DEB_PV}-${DEB_PR}.diff.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/xbae
	>=sci-physics/cernlib-2006"

S=${WORKDIR}/${PN}_${DEB_PV}.orig

FORTRAN="gfortran g77 ifc"

src_unpack() {
	fortran_src_unpack

	cd "${WORKDIR}"
	epatch ${PN}_${DEB_PV}-${DEB_PR}.diff || die "epatch failed"
	mv ${PN}-${PV}.dfsg/debian "${S}"/
	rm -rf ${PN}-${PV}.dfsg

	cd "${S}"
	cp debian/add-ons/Makefile .
	# fix some path stuff and collision for comis.h, already installed by cernlib
	sed -i \
		-e "s:/usr/local:/usr:g" \
		-e '/comis.h/d' \
		-e "s/g77/${FORTRANC}/g" \
		Makefile || die "sed failed"

	einfo "Applying Debian patches"
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
	dodoc changelog README.* deadpool.txt copyright.txt
	newdoc add-ons/README README.add-ons
}
