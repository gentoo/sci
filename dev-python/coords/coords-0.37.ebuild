# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Managing astronomical coordinate systems"
HOMEPAGE="https://trac6.assembla.com/astrolib/wiki/"
SRC_URI="http://stsdas.stsci.edu/astrolib/${P}.tar.gz"

LICENSE="AURA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" -c "import coords as C; print C._test()" || die
}
