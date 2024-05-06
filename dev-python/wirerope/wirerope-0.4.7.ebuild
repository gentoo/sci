# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="A wrapper interface for python callables"
HOMEPAGE="https://github.com/youknowone/wirerope"
# Not using PyPI archive because it misses test files:
# https://github.com/youknowone/wirerope/issues/20
SRC_URI="https://github.com/youknowone/wirerope/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-nocov.patch" )

distutils_enable_tests pytest
