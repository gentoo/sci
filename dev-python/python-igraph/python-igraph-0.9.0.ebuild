# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Python interface for igraph"
HOMEPAGE="https://igraph.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/igraph-0.9.0
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

python_prepare_all() {
	# fix the igraph include path
	cd src || die
	find -type f -name "*.h" -exec sed -i -e 's@#include <igraph@#include <igraph/igraph@g' {} + || die
	find -type f -name "*.c" -exec sed -i -e 's@#include <igraph@#include <igraph/igraph@g' {} + || die
	cd .. || die

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile --use-pkg-config
}
