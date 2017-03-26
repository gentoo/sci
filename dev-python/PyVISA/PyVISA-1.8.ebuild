# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python VISA bindings for GPIB, RS232, and USB instruments"
HOMEPAGE="https://github.com/hgrecco/pyvisa"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	"
DEPEND="${RDEPEND}"

python_test() {
	esetup.py test
}
