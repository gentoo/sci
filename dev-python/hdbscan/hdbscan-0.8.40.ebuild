# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="A high performance implementation of HDBSCAN clustering."
HOMEPAGE="https://github.com/scikit-learn-contrib/hdbscan"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Reported upstream:
# https://github.com/scikit-learn-contrib/hdbscan/issues/501
RESTRICT="test"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
