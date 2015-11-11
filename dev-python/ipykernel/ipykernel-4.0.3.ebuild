# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="IPython Kernel for Jupyter"
HOMEPAGE="https://github.com/ipython/ipykernel"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ipython/${PN}.git git://github.com/ipython/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
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
