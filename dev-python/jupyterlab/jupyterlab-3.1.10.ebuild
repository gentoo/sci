# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="JupyterLab computational environment"
HOMEPAGE="https://jupyter.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD MIT GPL-3 Apache-2.0"
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
	# We have to do this here because we need internet since this uses yarn
	jupyter-lab build -y || ( \
		ewarn "Failed to build jupyterlab javascript assets, please run"
		ewarn "'jupyter-lab build' manually before starting jupyter-lab."
		ewarn "Note that this will likely require network access."
		)
}

pkg_prerm() {
	jupyter-lab clean -y --static || ( \
		ewarn "Failed to clean jupyterlab javascript assets, please remove"
		ewarn "/usr/share/jupyter/lab/staging and /usr/share/jupyter/lab/static"
		ewarn "manually."
	)
}
