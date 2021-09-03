# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="JupyterLab computational environment"
HOMEPAGE="https://jupyter.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# TODO: package openapi et al
RESTRICT="test"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/jupyterlab_server[${PYTHON_USEDEP}]
	dev-python/jupyter_server[${PYTHON_USEDEP}]
	dev-python/nbclassic[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	>=www-servers/tornado-6.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
# TODO: package myst_parser
#distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

pkg_postinst() {
	jupyter-lab build || die "Failed to build jupyter assets"
}
