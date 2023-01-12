# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Speedy Cosmic Ray Annihilation Package in Python"
HOMEPAGE="https://github.com/astropy/astroscrappy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#TODO: Fix this
# ModuleNotFoundError: No module named 'astroscrappy.astroscrappy'
# happens even with --install argument
RESTRICT="test"

RDEPEND="
	>=dev-python/astropy-2.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

# Requires self to already be installed
#distutils_enable_sphinx docs dev-python/sphinx-astropy
distutils_enable_tests --install pytest
