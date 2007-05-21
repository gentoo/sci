# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DEB_PN="${PN}321"
DEB_PR="5"

inherit cernlib

DESCRIPTION="CERN's detector description and simulation Tool"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/geant/index.html"
KEYWORDS="~amd64 ~x86"
DEPEND="sci-physics/paw"

S=${WORKDIR}/${DEB_PN}-${DEB_PV}.orig

src_unpack() {
	unpack ${A}
	epatch ${DEB_PN}_${DEB_PV}-${DEB_PR}.diff
	rm -f ${DEB_PN}_${DEB_PV}-${DEB_PR}.diff
	cernlib_patch
}
