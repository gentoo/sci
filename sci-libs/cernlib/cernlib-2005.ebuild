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

	# apply the big debian patch
	epatch ${PN}_${DEB_PV}-${DEB_PR}.diff || die "epatch failed"

	cd "${S}"
	# temporary fix for threading support (while we have buggy eselect)
	if blas-config -p | grep "F77 BLAS:" | grep -q f77-threaded-ATLAS; then
		einfo "Fixing threads linking for blas"
		sed -i \
			-e 's/$DEPS -lm/$DEPS -lm -lpthread/' \
			-e 's/$DEPS -l$1 -lm/$DEPS -l$1 -lm -lpthread/' \
			debian/add-ons/bin/cernlib.in
	fi
	
	cp debian/add-ons/Makefile .
	einfo "Appying Debian patches"
	make patch
	# since we depend on cfortran, do not use the one from cernlib
	# (adapted from $S/debian/rules)
	mv -f src/include/cfortran/cfortran.h \
		src/include/cfortran/cfortran.h.disabled
}

src_compile() {
	make \
		prefix=/usr \
		libdir=/usr/$(get_libdir) \
		host=${CHOST} \
		mandir=/usr/share/man \
		datadir=/usr/share \
		sysconfdir=/etc \
		OPTIMIZED_OPTS="\#define OptimizationLevel ${CFLAGS}" \
		GEANTDOC="/usr/share/doc/${P}/geant321" \
		MCDOC="/usr/share/doc/${P}/montecarlo" \
		|| die "make failed"
}

src_install() {
	dodir /usr/share/doc/${P}/geant321
	dodir /usr/share/doc/${P}/montecarlo
	einstall \
		GEANTDOC="${D}/usr/share/doc/${P}/geant321" \
		MCDOC="${D}/usr/share/doc/${P}/montecarlo" \
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
