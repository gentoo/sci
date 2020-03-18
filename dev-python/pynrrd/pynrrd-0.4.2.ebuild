# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

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
	${EPYTHON} -m unittest discover -v nrrd/tests || die
}
