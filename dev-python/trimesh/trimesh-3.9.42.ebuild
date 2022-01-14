# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python library for loading and using triangular meshes."
HOMEPAGE="https://trimsh.org/"
SRC_URI="https://github.com/mikedh/trimesh/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="extra"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="
	extra? (
		dev-libs/xxhash
		dev-python/colorlog[${PYTHON_USEDEP}]
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
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
		sci-libs/scikit-image[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		sci-libs/shapely[${PYTHON_USEDEP}]
		sci-libs/rtree[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# TODO: package pypandoc
# distutils_enable_sphinx docs \
# 	dev-python/sphinx_rtd_theme \
# 	dev-python/numpy \
# 	dev-python/scipy \
# 	dev-python/networkx \
# 	dev-python/recommonmark \
# 	dev-python/jupyter \
# 	dev-python/pyopenssl \
# 	dev-python/autodocsumm \
# 	dev-python/jinja2 \
# 	dev-python/matplotlib

python_test() {
	if use extra; then
		epytest
	else
		cd tests || die
		epytest -p no:warnings $(grep -v '^#' basic.list)
	fi
}
