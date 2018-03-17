# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="JupyterLab computational environment."
HOMEPAGE="https://github.com/jupyterlab/jupyterlab"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/jupyterlab_launcher-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/notebook-4.3.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/futures[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep 'dev-python/subprocess32[${PYTHON_USEDEP}]' 'python2*')
	"
DEPEND="${RDEPEND}
	>=net-libs/nodejs-5.0.0
	doc?  (
			dev-python/recommonmark[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		  )
	test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/selenium[${PYTHON_USEDEP}]
			$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2*')
		  )"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	py.test jupyter_core || die
}

pkg_postinst() {
	if [ "$(printf "5.3.0\n%s\n" $(jupyter notebook --version)|sort -V|head -n1)" != "5.3.0" ]; then
		jupyter serverextension enable --py --sys-prefix jupyterlab
	fi
}
