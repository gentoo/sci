# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Jupyter Launcher"
HOMEPAGE="https://jupyter.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# TODO: fix this
RESTRICT="test"

RDEPEND="
	>=dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/notebook-4.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
