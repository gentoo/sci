# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_P="nipy-${PV}"

DESCRIPTION="Neuroimaging tools for Python."
HOMEPAGE="http://nipy.org/"
SRC_URI="https://pypi.python.org/packages/source/n/nipy/nipy-0.3.0.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.2[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/sympy-0.6.6[${PYTHON_USEDEP}]
	>=sci-libs/nibabel-1.2[${PYTHON_USEDEP}]"
DEPEND="
	"

python_install_all() {
	distutils-r1_python_install_all
}
