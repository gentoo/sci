# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION=" Meaningful and safe wrapping types. "
HOMEPAGE="https://github.com/nekitdev/wraps"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
# package does not have test suite (yet)

RDEPEND="
	>=dev-python/attrs-21.4.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.2.0[${PYTHON_USEDEP}]
	"

PATCHES=(
	"${FILESDIR}/${P}-poetry_groups.patch"
)

distutils_enable_tests pytest
