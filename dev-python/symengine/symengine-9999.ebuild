# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Python wrappers to the symengine C++ library"
HOMEPAGE="https://github.com/sympy/symengine.py"
SRC_URI=""
EGIT_REPO_URI="https://github.com/symengine/symengine.py.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	=sci-libs/symengine-9999"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

# if this is not set python2 .so is linked to python3
DISTUTILS_IN_SOURCE_BUILD=1

python_install_all() {
	newdoc README.md ${PN}_py.md
}
