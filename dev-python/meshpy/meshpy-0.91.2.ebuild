# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="MeshPy"

DESCRIPTION="Quality triangular and tetrahedral mesh generation for Python"
HOMEPAGE="http://mathema.tician.de/software/meshpy http://pypi.python.org/pypi/MeshPy"
SRC_URI="mirror://pypi/M/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost[python]
	dev-python/pyvtk"
DEPEND="
	${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	sed 's: delay = 10: delay = 1:g' -i aksetup_helper.py || die
	echo "BOOST_PYTHON_LIBNAME = ['boost_python-mt']">> siteconf.py
	distutils_src_prepare
}
