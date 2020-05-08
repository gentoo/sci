# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit python-r1 cmake

DESCRIPTION="An open source C++, python library for Topological Data Analysis"
HOMEPAGE="https://gudhi.inria.fr/"

SRC_URI="https://github.com/GUDHI/gudhi-devel/releases/download/tags/gudhi-release-${PV}/${PN}.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.${PV}"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE="threads test"
RESTRICT="! test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CMAKE_IN_SOURCE_BUILD=1

RDEPEND="${PYTHON_DEPS}
	dev-cpp/eigen:3
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pot[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
	sci-mathematics/cgal
	threads? ( dev-cpp/tbb )
"
BDEPEND="${RDEPEND}"

# (1) remove qgl viewer cuz gudhi uses old broken
# (2) remove python setup.py from cmake call
PATCHES=(
	"${FILESDIR}/gudhi-CMakeLists.txt.patch"
	"${FILESDIR}/gudhi-python_CMakeLists.txt.patch"
)

src_configure() {
	my
}

src_compile() {
	cmake_src_compile

	#cd "${BUILD_DIR}/python"
	#python_foreach_impl distutils-r1_python_compile
}

src_install() {
	einstalldocs
	cmake_src_install

	#cd "${BUILD_DIR}/python"
	#python_foreach_impl distutils-r1_python_install
}
