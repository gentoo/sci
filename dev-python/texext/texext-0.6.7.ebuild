# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Sphinx extensions for working with LaTeX math"
HOMEPAGE="https://github.com/matthew-brett/texext"
SRC_URI="https://github.com/matthew-brett/texext/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: package sphinxtesters
# E   ModuleNotFoundError: No module named 'sphinxtesters'
RESTRICT="test"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
