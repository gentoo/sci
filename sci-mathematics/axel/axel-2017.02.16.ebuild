# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils user

DESCRIPTION="Algebraic geometric modeling platform"
HOMEPAGE="http://dtk.inria.fr/axel/"
SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="~sci-libs/dtk-${PV}"
DEPEND="${RDEPEND}"

pkg_setup() {
	AXEL_DATA_DIR="/usr/share/axel/data"
	AXEL_PLUGINS_DIR="/usr/lib/axel-plugins"
	AXEL_GROUP="dtk-axel"
	enewgroup "${AXEL_GROUP}"
}

PATCHES=(
	"${FILESDIR}/${PV}/CMakeLists.txt.patch"
	"${FILESDIR}/${PV}/AxelConfig.cmake.in.patch"
	"${FILESDIR}/${PV}/install-axel-config.h.in.patch"
	"${FILESDIR}/${PV}/main.cpp.patch"
)

src_prepare() {
	cp "${FILESDIR}/${PV}/install-AxelConfig.cmake.in" \
		"${S}/cmake/install-AxelConfig.cmake.in" || \
		die "Could not copy '${FILESDIR}/${PV}/install-AxelConfig.cmake.in' to '${S}/cmake/'"
	# patches are applied by cmake-utils
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DAXL=ON
		-DDTK_USED=ON
		-DBUILD_FOR_RELEASE=ON
		-Daxel-sdk_VERSION_MAJOR=2
		-Daxel-sdk_VERSION_MINOR=4
		-Daxel-sdk_VERSION_PATCH=0
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	keepdir "${AXEL_DATA_DIR}"
	keepdir "${AXEL_PLUGINS_DIR}"
	# allow users to develop plug-ins
	fowners "root:${AXEL_GROUP}" "${AXEL_PLUGINS_DIR}"
	fperms g+w "${AXEL_PLUGINS_DIR}"
}
