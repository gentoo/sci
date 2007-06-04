# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DEB_PV="${PV}.dfsg.2"
DEB_PR="1"
inherit cernlib

DESCRIPTION="CERN's Physics Analysis Workstation data analysis program"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/paw/index.html"
KEYWORDS="~amd64 ~x86"
DEPEND="x11-libs/xbae"

src_unpack() {
	cernlib_unpack
	# fix some path stuff and collision for comis.h, 
	# already installed by cernlib and replace hardcoded fortran compiler
	sed -i \
		-e '/comis.h/d' \
		-e "s/g77/${FORTRANC}/g" \
		"${S}"/debian/add-ons/Makefile || die "sed failed"
	cernlib_patch
}
