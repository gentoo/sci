# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Matchers for pytest"
HOMEPAGE="https://github.com/jwodder/anys"
SRC_URI="https://github.com/jwodder/anys/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.2.0-coverage.patch"
)

distutils_enable_tests pytest
