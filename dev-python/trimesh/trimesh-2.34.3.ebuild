# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python library for loading and using triangular meshes."
HOMEPAGE="https://trimsh.org/"
SRC_URI="https://github.com/mikedh/trimesh/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		)
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-libs/xxhash
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/svg-path[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	=dev-python/six-1*[${PYTHON_USEDEP}]
	sci-libs/Shapely[${PYTHON_USEDEP}]
	sci-libs/Rtree[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-suppress-xvfb-test.patch" )

python_test() {
	pytest -vv || die
}
