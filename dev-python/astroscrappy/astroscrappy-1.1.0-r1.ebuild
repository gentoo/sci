# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Speedy Cosmic Ray Annihilation Package in Python"
HOMEPAGE="https://github.com/astropy/astroscrappy"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#TODO: Fix this
RESTRICT="test"

RDEPEND="
	>=dev-python/astropy-2.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

# Requires self to already be installed
#distutils_enable_sphinx docs dev-python/sphinx-astropy
distutils_enable_tests pytest
