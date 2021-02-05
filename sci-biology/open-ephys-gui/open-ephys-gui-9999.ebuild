# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Processing, recording, and visualizing multichannel ephys data"
HOMEPAGE="http://www.open-ephys.org/gui/"
LICENSE="GPL-3"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"
	EGIT_BRANCH="master"
	Suffix=$EGIT_BRANCH
	SubDir=${P}
elif [[ ${PV} == "99999999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"
	EGIT_BRANCH="development"
	Suffix=$EGIT_BRANCH
	SubDir=${P}
else
	SRC_URI="https://github.com/open-ephys/plugin-GUI/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	Suffix=${PV}
	SubDir="plugin-GUI-${PV}"
	S="${WORKDIR}/$SubDir"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="${PV}"
IUSE="jack"

BDEPEND="
	<sys-devel/gcc-9
"
DEPEND="
	media-libs/alsa-lib
	media-libs/freeglut
	media-libs/freetype
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXinerama
	jack? ( media-sound/jack-audio-connection-kit )
"
RDEPEND="${DEPEND}"

BUILD_DIR="$S/Build"
PATCHES=( "${FILESDIR}"/${P}.patch )

QA_PREBUILT="opt/open-ephys-0.5.2.2/shared/*.so"
QA_PRESTRIPPED="
	opt/open-ephys-0.5.2.2/plugins/*.so
	opt/open-ephys-0.5.2.2/open-ephys
"

src_prepare() {
	cmake_src_prepare

	if use jack; then
		sed -i 's/JUCE_APP_VERSION=/JUCE_JACK=1\n    JUCE_APP_VERSION=/' "${WORKDIR}/${SubDir}/CMakeLists.txt" || die "Sed failed!"
	fi
}

src_configure() {
	local mycmakeargs=( -DCMAKE_SKIP_RPATH=ON )
	cmake_src_configure
}

src_install() {
	dodir opt/open-ephys-"$Suffix"/ lib/udev/rules.d/
	cp -R "${BUILD_DIR}"/Gentoo/* "${ED}"/opt/open-ephys-"$Suffix"/
	cp -R "${WORKDIR}"/"${SubDir}"/Resources/Scripts/40-open-ephys.rules "${ED}"/lib/udev/rules.d/
	dosym ../../opt/open-ephys-"$Suffix"/open-ephys usr/bin/open-ephys-"$Suffix"
}

pkg_postinst() {
	ewarn " "
	ewarn "You must restart the udev service in order to allow your computer to"
	ewarn "communicate with the Open Ephys acquisition board."
	ewarn " "
}
