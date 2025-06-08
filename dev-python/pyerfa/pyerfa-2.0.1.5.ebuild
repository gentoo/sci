# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for ERFA"
HOMEPAGE="https://github.com/liberfa/pyerfa/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# ImportError: cannot import name 'ufunc' from 'erfa'
RESTRICT="test"

RDEPEND="
	sci-astronomy/erfa:0=
	>=dev-python/numpy-1.17[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
#distutils_enable_sphinx docs dev-python/sphinx-astropy
