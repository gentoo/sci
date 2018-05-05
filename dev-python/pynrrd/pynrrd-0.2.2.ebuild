# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Simple pure-python module for reading and writing nrrd files"
HOMEPAGE="https://github.com/mhe/pynrrd"
SRC_URI="https://github.com/mhe/pynrrd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND} )"

python_test() {
	${EPYTHON} tests/test_nrrd.py || die
}
