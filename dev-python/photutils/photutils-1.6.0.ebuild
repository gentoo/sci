# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Affiliated package for image photometry utilities"
HOMEPAGE="https://github.com/astropy/photutils"

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

RDEPEND="
	>=dev-python/astropy-0.4[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# TODO: Fix this
# NameError: name 'disabled_intersphinx_mapping' is not defined
#distutils_enable_sphinx docs \
# 	dev-python/sphinx-astropy \
# 	dev-python/scipy \
# 	dev-python/matplotlib \
# 	dev-python/scikit-learn \
# 	dev-python/scikit-image \
