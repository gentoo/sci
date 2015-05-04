# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

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
	mkdir "${S}" && cd "${S}" || die
	unpack "${MY_SRC}"
	# Need to delete Readme.txt, because it is in makefiles.zip
	rm Readme.txt || die
	unpack ./makefiles.zip ./GNU_CON.zip ./source*.ZIP
}

src_prepare(){
	# 'sed' command has to accomodate DOS formatted file.
	sed -i \
	    -e 's;^#define DLL;//#define DLL;' \
	    -e 's;^//#define CLE;#define CLE;' \
		swmm5.c || die
}

src_install(){
	# Don't like the version number in the name.
	newbin swmm5 swmm
	use doc && dodoc Roadmap.txt
}
