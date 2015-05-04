# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit cmake-utils multilib

DESCRIPTION="Library for chemistry applications"
HOMEPAGE="http://www.chemkit.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="applications examples python test"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost
	dev-cpp/eigen:3
	examples? (
		x11-libs/libX11
		x11-libs/libXext
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

src_prepare() {
	sed \
		-e "/install/s:lib:$(get_libdir):g" \
		-i CMakeLists.txt src/CMakeLists.txt src/plugins/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCHEMKIT_BUILD_PLUGIN_BABEL=on
		$(cmake-utils_use applications CHEMKIT_BUILD_APPS)
		$(cmake-utils_use applications CHEMKIT_BUILD_QT_DESIGNER_PLUGINS)
		$(cmake-utils_use examples CHEMKIT_BUILD_EXAMPLES)
		$(cmake-utils_use examples CHEMKIT_BUILD_DEMOS)
		$(cmake-utils_use python CHEMKIT_BUILD_BINDINGS_PYTHON)
		$(cmake-utils_use test CHEMKIT_BUILD_TESTS)
	)
	cmake-utils_src_configure
}

src_install() {
	use examples && dobin demos/*-viewer/*-viewer examples/uff-energy/uff-energy

	cmake-utils_src_install
}
