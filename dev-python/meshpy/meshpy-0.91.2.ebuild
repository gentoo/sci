# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
#SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="MeshPy"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Quality triangular and tetrahedral mesh generation for Python"
HOMEPAGE="http://mathema.tician.de/software/meshpy http://pypi.python.org/pypi/MeshPy"
SRC_URI="http://pypi.python.org/packages/source/M/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/setuptools"
RDEPEND="dev-libs/boost[python]
         dev-python/pyvtk"

src_configure() {
	./configure.py --boost-python-libname="boost_python-mt"
}
