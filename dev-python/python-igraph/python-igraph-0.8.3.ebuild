# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python interface for igraph"
HOMEPAGE="https://igraph.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	dev-libs/igraph
	dev-python/texttable[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/ipywidgets[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile --use-pkg-config
}
