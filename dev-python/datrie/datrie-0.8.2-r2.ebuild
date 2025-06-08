# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Implements a topological sort algorithm"
HOMEPAGE="https://github.com/pytries/datrie"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on pytest-runner
	sed -i "/pytest-runner/d" setup.py || die
	# https://github.com/pytries/datrie/pull/99
	sed -i "12s/struct AlphaMap:/ctypedef struct AlphaMap:/" src/cdatrie.pxd || die
	distutils-r1_python_prepare_all
}
