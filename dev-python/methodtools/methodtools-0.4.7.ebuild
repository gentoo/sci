# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )
inherit distutils-r1

DESCRIPTION="Expand functools features to methods, classmethods, staticmethods"
HOMEPAGE="https://github.com/youknowone/methodtools"
# Not using PyPI archive because it misses test files:
# https://github.com/youknowone/methodtools/issues/24
SRC_URI="https://github.com/youknowone/methodtools/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/wirerope[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-nocov.patch" )

distutils_enable_tests pytest
