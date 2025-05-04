# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 # pypi misses tests

DESCRIPTION="Error propagation and statistical analysis for Markov chain Monte Carlos"
HOMEPAGE="
	https://github.com/fjoswig/pyerrors
	https://fjosw.github.io/pyerrors/pyerrors.html
	https://arxiv.org/abs/2209.14371
"
SRC_URI="https://github.com/fjosw/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-2[${PYTHON_USEDEP}]
	>=dev-python/autograd-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/numdifftools-0.9.41[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.9[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.13[${PYTHON_USEDEP}]
	>=dev-python/iminuit-2.28[${PYTHON_USEDEP}]
	>=dev-python/h5py-3.11[${PYTHON_USEDEP}]
	>=dev-python/lxml-5.0[${PYTHON_USEDEP}]
	>=dev-python/python-rapidjson-1.20[${PYTHON_USEDEP}]
	>=dev-python/pandas-2.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	tests/benchmark_test.py
)

distutils_enable_tests pytest
