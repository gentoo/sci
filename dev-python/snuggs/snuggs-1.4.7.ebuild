# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_13 )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="S-expressions for numpy"
HOMEPAGE="https://github.com/mapbox/snuggs"
SRC_URI="https://github.com/mapbox/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
