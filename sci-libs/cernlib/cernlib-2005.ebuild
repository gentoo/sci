# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib fortran

DEB_PV="2005.05.09.dfsg"
DEB_PR="5"

DESCRIPTION="CERN program library for High Energy Physics: paw, geant, mc, mathlibs..."
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/cernlib"
LICENSE="GPL-2 LGPL-2"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${DEB_PV}.orig.tar.gz
	mirror://debian/pool/main/c/${PN}/${PN}_${DEB_PV}-${DEB_PR}.diff.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="virtual/motif
	virtual/lapack
	dev-lang/cfortran
	virtual/tetex"

S=${WORKDIR}/${PN}-${DEB_PV}.orig

FORTRAN="gfortran ifc g77"

src_unpack() {
	unpack ${A}
	epatch ${PN}_${DEB_PV}-${DEB_PR}.diff
}

src_compile() {
	cp debian/add-ons/Makefile .
	make \
		prefix=/usr \
		libdir=/usr/$(get_libdir) \
		host=${CHOST} \
		mandir=/usr/share/man \
		datadir=/usr/share \
		sysconfdir=/etc \
		OPTIMIZED_OPTS="\#define OptimizationLevel ${CFLAGS}" \
		GEANTDOC=/usr/share/doc/${P}/geant321 \
		MCDOC=/usr/share/doc/${P}/montecarlo \
		|| "make failed"
}

src_install() {
	dodir /usr/share/doc/${P}/geant321
	dodir /usr/share/doc/${P}/montecarlo
	einstall \
		GEANTDOC=/usr/share/doc/${P}/geant321 \
		MCDOC=/usr/share/doc/${P}/montecarlo \
		|| die "einstall failed"
	
	cd "${S}"/debian
	docinto debian
	dodoc changelog README.* deadpool.txt NEWS copyright
	docinto debian/add-ons
	dodoc add-ons/README
}

pkg_postinst() {
	einfo 
	einfo "The cernlib on Gentoo tries to respect file system standards"
	einfo "The scripts have been modified accordingly and are in the path"
	einfo
}
