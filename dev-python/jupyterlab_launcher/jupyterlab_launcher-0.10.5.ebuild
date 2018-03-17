# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="JupyterLab computational environment."
HOMEPAGE="https://github.com/jupyterlab/jupyterlab_launcher"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/notebook-4.2.0[${PYTHON_USEDEP}]
		"
DEPEND="${RDEPEND}
	test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2*')
		  )"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	py.test jupyter_core || die
}
