# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="python frontend for the fast ripser tda tool"
HOMEPAGE="https://ripser.scikit-tda.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/persim[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hopcroftkarp[${PYTHON_USEDEP}]
		dev-python/joblib[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest
