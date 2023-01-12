# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

MY_PN="MeshPy"

DESCRIPTION="Quality triangular and tetrahedral mesh generation for Python"
HOMEPAGE="https://mathema.tician.de/software/meshpy
	https://pypi.python.org/pypi/MeshPy
"
SRC_URI="https://github.com/inducer/meshpy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# ModuleNotFoundError: No module named 'meshpy._internals'
RESTRICT="test"

RDEPEND="
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/gmsh_interop[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/pytools[${PYTHON_USEDEP}]
	sci-libs/gmsh
"
DEPEND="${RDEPEND}"

distutils_enable_tests --install pytest

python_prepare_all() {
	sed 's:delay=10:delay=1:g' -i aksetup_helper.py || die
	distutils-r1_python_prepare_all
}
