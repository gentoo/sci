# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit distutils-r1

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="https://github.com/Calysto/metakernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="test"
KEYWORDS="~amd64"

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
