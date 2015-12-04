# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="https://github.com/Calysto/metakernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/ipython-3.0[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		>=dev-python/metakernel_python-0.11.3[${PYTHON_USEDEP}]
	)
"

# tests currently fail and the dying/stopping of ipcluster needs to be fixed
RESTRICT="test"

python_test() {
	ipcluster start -n=3 &
	nosetests --with-doctest --with-coverage --cover-package metakernel || die
	ipcluster stop
}
