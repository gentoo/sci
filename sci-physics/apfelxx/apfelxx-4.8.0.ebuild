# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake python-single-r1

DESCRIPTION="Object oriented rewriting of the APFEL evolution code"
HOMEPAGE="https://github.com/vbertone/apfelxx"
SRC_URI="https://github.com/vbertone/apfelxx/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="${PYTHON_DEPS}"

src_prepare() {
	default
	cmake_src_prepare
	sed -i "/prefix./s/\/lib/\/$(get_libdir)/g" CMakeLists.txt || die
	sed -i "s#DESTINATION lib#DESTINATION $(get_libdir)#g" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
