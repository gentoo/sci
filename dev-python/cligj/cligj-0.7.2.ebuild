# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="Library for processing GeoJSON commands"
HOMEPAGE="https://github.com/mapbox/cligj"
SRC_URI="https://github.com/mapbox/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
