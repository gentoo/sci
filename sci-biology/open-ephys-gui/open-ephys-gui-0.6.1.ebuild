# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake udev

DESCRIPTION="Processing, recording, and visualizing multichannel ephys data"
HOMEPAGE="https://open-ephys.org/gui/"
LICENSE="GPL-3"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"
	EGIT_BRANCH="main"
	Suffix=${EGIT_BRANCH}
	SubDir=${P}
elif [[ ${PV} == "99999999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"
	EGIT_BRANCH="development"
	Suffix=${EGIT_BRANCH}
	SubDir=${P}
else
	SRC_URI="https://github.com/open-ephys/plugin-GUI/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	Suffix=${PV}
	SubDir="plugin-GUI-${PV}"
	S="${WORKDIR}/${SubDir}"
	KEYWORDS="~amd64 ~x86"
fi

SLOT="${PV}"
IUSE="jack"

DEPEND="
	dev-libs/openssl
	media-libs/alsa-lib
	media-libs/freeglut
	media-libs/freetype
	net-libs/webkit-gtk
	net-misc/curl
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXinerama
	jack? ( || ( media-sound/jack-audio-connection-kit media-sound/jack2 ) )
"
RDEPEND="${DEPEND}"

BUILD_DIR="${S}/Build"
PATCHES=( "${FILESDIR}"/${P}.patch )

QA_PREBUILT="opt/open-ephys-*/shared/*.so"
QA_PRESTRIPPED="
	opt/open-ephys-*/plugins/*.so
	opt/open-ephys-*/open-ephys
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
	dodir opt/open-ephys-"${Suffix}"/ lib/udev/rules.d/
	cp -R "${BUILD_DIR}"/RelWithDebInfo/* "${ED}"/opt/open-ephys-"${Suffix}"/ || die
	udev_newrules "${WORKDIR}"/"${SubDir}"/Resources/Scripts/40-open-ephys.rules 40-open-ephys-"${Suffix}".rules
	dosym ../../opt/open-ephys-"${Suffix}"/open-ephys usr/bin/open-ephys-"${Suffix}"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
