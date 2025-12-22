# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Yield from multiple iterators as values become available"
HOMEPAGE="https://github.com/jwodder/interleave"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-0.2.0-drop-coverage.patch" )

distutils_enable_tests pytest
