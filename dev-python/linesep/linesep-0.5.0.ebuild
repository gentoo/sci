# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )
inherit distutils-r1 pypi

DESCRIPTION="Handling lines with arbitrary separators"
HOMEPAGE="https://github.com/jwodder/linesep"kat

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${P}-nocov.patch" )

distutils_enable_tests pytest
