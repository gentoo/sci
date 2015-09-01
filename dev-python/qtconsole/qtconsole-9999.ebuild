# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Qt-based console for Jupyter with support for rich media output"
HOMEPAGE="http://jupyter.org"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jupyter/${PN}.git git://github.com/jupyter/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
	)
	|| (
		dev-python/PyQt4[${PYTHON_USEDEP},svg]
		dev-python/PyQt5[${PYTHON_USEDEP},svg]
		dev-python/pyside[${PYTHON_USEDEP},svg]
	)
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-13[${PYTHON_USEDEP}]
	"
PDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"

python_test() {
	nosetests --with-coverage --cover-package qtconsole qtconsole || die
}
