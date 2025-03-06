# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
PYTHON_COMPAT=( python3_{10..13} )

inherit fortran-2 cmake python-single-r1

DESCRIPTION="Recursive Computation of 1-Loop Amplitudes."
HOMEPAGE="https://recola.gitlab.io/recola2/index.html"
SRC_URI="https://recola.hepforge.org/downloads/?f=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+SM" # TODO add more models here and below
REQUIRED_USE="${PYTHON_REQUIRED_USE} || ( SM )"

DEPEND="
	sci-mathematics/otter
	sci-physics/collier
	SM? ( sci-physics/recola2-SM )
	${PYTHON_DEPS}
"
RDEPEND="${DEPEND}"

src_prepare() {
	# CMAKE should look in system install for required libs
	sed -e 's/NO_DEFAULT_PATH//g' -i src/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DSYSCONFIG_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)/cmake/recola
		-DCMAKE_PREFIX_PATH=/usr/$(get_libdir)/
		-Dwith_python3=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}
