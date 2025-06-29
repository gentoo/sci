# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

DESCRIPTION="Processing, recording, and visualizing multichannel ephys data"
HOMEPAGE="https://open-ephys.org/gui/"
LICENSE="GPL-3"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-ephys/plugin-GUI"

	if [[ ${PV} == "9999" ]] ; then
		EGIT_BRANCH="main"
	elif [[ ${PV} == "99999999" ]] ; then
		EGIT_BRANCH="development"
	fi

	Suffix="${EGIT_BRANCH}"
	SubDir="${P}"

	SLOT="${PV}/${Suffix}"
else
	SRC_URI="https://github.com/open-ephys/plugin-GUI/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	Suffix="${PV}"
	SubDir="plugin-GUI-${PV}"
	S="${WORKDIR}/${SubDir}"

	SLOT="${Suffix}"

	KEYWORDS="~amd64 ~x86"
fi

IUSE="jack"

DEPEND="
	dev-libs/openssl
	media-libs/alsa-lib
	media-libs/freeglut
	media-libs/freetype
	net-libs/webkit-gtk:4.1
	net-misc/curl
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXinerama
	jack? ( virtual/jack )
"
RDEPEND="${DEPEND}"

BUILD_DIR="${S}/Build"
PATCHES=(
	"${FILESDIR}/${PN}-cmake-no-build-type-error.patch"
)

QA_PREBUILT="opt/open-ephys-*/shared/*.so"
QA_PRESTRIPPED="
	opt/open-ephys-*/plugins/*.so
	opt/open-ephys-*/open-ephys
"

src_prepare() {
	# picks up dev plugin otherwise
	local CMAKE_QA_COMPAT_SKIP=1

	cmake_src_prepare

	if use jack; then
		sed \
			-e 's/JUCE_APP_VERSION=/JUCE_JACK=1\n    JUCE_APP_VERSION=/' \
			-i "${WORKDIR}/${SubDir}/CMakeLists.txt" \
				|| die "sed failed!"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH="yes"
	)

	cmake_src_configure
}

src_install() {
	dodir opt/open-ephys-"${Suffix}"/
	cp -R "${BUILD_DIR}/RelWithDebInfo"/* "${ED}/opt/open-ephys-${Suffix}/" || die

	udev_newrules \
		"${WORKDIR}/${SubDir}/Resources/Scripts/40-open-ephys.rules" \
		"40-open-ephys-${Suffix}.rules"

	dodir usr/bin
	dosym -r /opt/open-ephys-"${Suffix}"/open-ephys /usr/bin/open-ephys-"${Suffix}"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
