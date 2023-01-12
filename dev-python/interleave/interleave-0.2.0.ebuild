# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10)

inherit distutils-r1

DESCRIPTION="Yield from multiple iterators as values become available"
HOMEPAGE="https://github.com/jwodder/interleave"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-0.2.0-drop-coverage.patch" )

distutils_enable_tests pytest
