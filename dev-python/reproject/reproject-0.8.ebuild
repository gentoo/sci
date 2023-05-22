# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
inherit distutils-r1 pypi

DESCRIPTION="Reproject astronomical images"
HOMEPAGE="https://reproject.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#TODO: Package all these pytest deps:
# 	pytest-doctestplus>=0.2.0
# 	pytest-remotedata>=0.3.1
# 	pytest-openfiles>=0.3.1
# 	pytest-astropy-header>=0.1.2
# 	pytest-arraydiff>=0.1
# 	pytest-filter-subpackage>=0.1
RESTRICT="test"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

RDEPEND="
	>=dev-python/astropy-3.2[${PYTHON_USEDEP}]
	>=dev-python/astropy-healpix-0.6[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.14[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.1[${PYTHON_USEDEP}]
"

# requires self to be installed
# distutils_enable_sphinx docs dev-python/sphinx-astropy dev-python/matplotlib
distutils_enable_tests --install pytest
