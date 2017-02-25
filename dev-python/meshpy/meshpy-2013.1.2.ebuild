# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="MeshPy"

DESCRIPTION="Quality triangular and tetrahedral mesh generation for Python"
HOMEPAGE="http://mathema.tician.de/software/meshpy http://pypi.python.org/pypi/MeshPy"
SRC_URI="mirror://pypi/M/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/pyvtk[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	sed 's: delay = 10: delay = 1:g' -i aksetup_helper.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	mkdir "${BUILD_DIR}" || die
	echo "BOOST_PYTHON_LIBNAME = [\'boost_${EPYTHON}-mt\']">> "${BUILD_DIR}"/siteconf.py
	distutils-r1_python_compile
}
