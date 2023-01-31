# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Lightweight package for generating visually distinct colours"
HOMEPAGE="
	https://distinctipy.readthedocs.io/en/latest/
	https://github.com/alan-turing-institute/distinctipy
"
# PyPI archive does not include tests:
# https://github.com/alan-turing-institute/distinctipy/issues/29
SRC_URI="https://github.com/alan-turing-institute/distinctipy/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# Requires networking:
EPYTEST_DESELECT=(
	tests/test_examples.py::test_compare_clusters
	tests/test_examples.py::test_simulate_clusters
)
