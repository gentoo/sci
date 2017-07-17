# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 git-r3

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="http://ipython.org/"
EGIT_REPO_URI="https://github.com/ipython/${PN}.git git://github.com/ipython/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=dev-python/traitlets-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/ipykernel-4.2.2[${PYTHON_USEDEP}]
	>=dev-python/widgetsnbextension-1.2.3[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
	"

python_test() {
	nosetests --with-coverage --cover-package=ipywidgets ipywidgets || die

	"${PYTHON}" -m ipywidgets.jstest || die
}
