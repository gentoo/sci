# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DOCS_BUILDER="mkdocs"
DOCS_DEPEND="dev-python/mkdocs-material"

inherit cmake python-any-r1 docs

DESCRIPTION="Single File Libraries for Physically-Based Graphics"
HOMEPAGE="https://github.com/simoncblyth/yocto-gl"
SRC_URI="https://github.com/xelatihy/yocto-gl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/bcm"

src_prepare() {
	sed -i -e 's/isnan/std::isnan/g' libs/yocto/yocto_mesh.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/YoctoGL
	)

	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}
