# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit pypi distutils-r1

DESCRIPTION="A high-performance immutable mapping type for Python"
HOMEPAGE="https://pypi.org/project/immutables/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="test? ( dev-python/mypy[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
