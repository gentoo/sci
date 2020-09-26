# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

MY_PN="MeshPy"

DESCRIPTION="Quality triangular and tetrahedral mesh generation for Python"
HOMEPAGE="https://mathema.tician.de/software/meshpy
	https://pypi.python.org/pypi/MeshPy
"

COMMIT=6f4f9418f5f02b414d561bd8de710c4f1349ea72
SRC_URI="https://github.com/inducer/meshpy/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/gmsh_interop[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/pytools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sci-libs/gmsh
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_prepare_all() {
	sed 's:delay=10:delay=1:g' -i aksetup_helper.py || die

#	echo "BOOST_PYTHON_LIBNAME = ['boost_${EPYTHON}-mt']">> "${S}"/siteconf.py

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	pytest -vv || die "tests failed with ${EPYTHON}"
}
