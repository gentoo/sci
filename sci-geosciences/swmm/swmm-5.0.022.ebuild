# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV=$(delete_all_version_separators)

MY_SRC="swmm${MY_PV}_engine.zip"

DESCRIPTION="Storm Water Management Model - SWMM, hydrology, hydraulics, and water quality model."
HOMEPAGE="http://www.epa.gov/ednnrmrl/models/swmm/index.htm"
SRC_URI="http://www.epa.gov/nrmrl/wswrd/wq/models/swmm/${MY_SRC}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	mkdir "${S}" && cd "${S}"
	unpack "${MY_SRC}"
	# Need to delete Readme.txt, because it is in makefiles.zip
	rm Readme.txt
	unpack ./makefiles.zip
	unpack ./GNU_CON.zip
	unpack ./source*.ZIP
}

src_compile(){
	# 'sed' command has to accomodate DOS formatted file.
	sed -i \
	    -e 's;^#define DLL;//#define DLL;' \
	    -e 's;^//#define CLE;#define CLE;' \
		swmm5.c
	emake || die "compile failed"
}

src_install(){
	# Don't like the version number in the name.
	mv swmm5 swmm
	dobin swmm
	if use doc ; then
		dodoc Roadmap.txt
	fi
}
