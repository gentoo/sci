# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="General purpose python library for professional astronomers/astrophysicists"
HOMEPAGE="http://packages.python.org/Astropysics/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/eteq/${PN}.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/chaco[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/atpy[${PYTHON_USEDEP}]
	sci-astronomy/sextractor
	sci-visualization/mayavi[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
