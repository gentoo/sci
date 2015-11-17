# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 git-r3

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"
EGIT_REPO_URI="https://github.com/ipython/${PN}.git git://github.com/ipython/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-python/traitlets[${PYTHON_USEDEP}]"
	#dev-python/jupyter_client[${PYTHON_USEDEP}]
	#>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
DEPEND="${RDEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
	"

python_test() {
	nosetests --with-coverage --cover-package ipykernel ipykernel || die
}
