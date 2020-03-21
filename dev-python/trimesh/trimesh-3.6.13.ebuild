# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python library for loading and using triangular meshes."
HOMEPAGE="https://trimsh.org/"
SRC_URI="https://github.com/mikedh/trimesh/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test extra"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		)
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
RDEPEND="
	extra? (
		dev-libs/xxhash
		dev-python/colorlog[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pyglet[${PYTHON_USEDEP}]
		dev-python/pycollada[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/svg-path[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
		sci-libs/scikits_image[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
		sci-libs/Shapely[${PYTHON_USEDEP}]
		sci-libs/Rtree[${PYTHON_USEDEP}]
	)
"

python_test() {
	if use extra; then
		pytest -vv || die
	else
		cd tests || die
		pytest -p no:warnings $(grep -v '^#' basic.list) || die
	fi
}
