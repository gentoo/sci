# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{12..15} )
export CRC32C_PURE_PYTHON=0

inherit distutils-r1 pypi

DESCRIPTION="A python wrapper of the C library crc32c"
HOMEPAGE="https://github.com/googleapis/python-crc32c"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/crc32c"
DEPEND="${RDEPEND}"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
