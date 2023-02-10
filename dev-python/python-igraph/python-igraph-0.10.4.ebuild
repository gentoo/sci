# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python interface for igraph"
HOMEPAGE="https://igraph.org"
SRC_URI="mirror://pypi/i/igraph/igraph-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/igraph-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/igraph-$(ver_cut 1-2)
	>=dev-python/texttable-1.6.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-python/cairocffi[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/plotly[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
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
