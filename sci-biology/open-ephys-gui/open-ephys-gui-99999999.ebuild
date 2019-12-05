# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="Software for processing, recording, and visualizing multichannel electrophysiology data"
HOMEPAGE="http://www.open-ephys.org/gui/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"
	EGIT_BRANCH="master"
    inherit git-r3
	Suffix=$EGIT_BRANCH
	SubDir=${P}
elif [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"
	EGIT_BRANCH="development"
    inherit git-r3
	Suffix=$EGIT_BRANCH
	SubDir=${P}
else
    SRC_URI="https://github.com/open-ephys/plugin-GUI/archive/v${PV}.tar.gz"
    KEYWORDS="~amd64 ~x86"
	Suffix=${PV}
	SubDir="plugin-GUI-${PV}"
fi

#LICENSE="GPLv3"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/alsa-lib
	media-libs/freeglut
	media-libs/freetype
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXinerama
"
RDEPEND="${DEPEND}"
BDEPEND=""

BUILD_DIR="${WORKDIR}/$SubDir/Build"
PATCHES=( "${FILESDIR}"/${P}.patch )

src_install() {
	dodir opt/open-ephys-$Suffix
	cp -R ${BUILD_DIR}/Gentoo/* ${ED}/opt/open-ephys-$Suffix/
	dosym /opt/open-ephys-$Suffix/open-ephys usr/bin/open-ephys-$Suffix
}

