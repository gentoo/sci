# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Short read sequence utilities"
HOMEPAGE="https://pypi.python.org/pypi/screed https://github.com/ged-lab/screed/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests --install pytest

RDEPEND="dev-python/bz2file[${PYTHON_USEDEP}]"

python_prepare_all() {
	# do not depend on pytest-runner
	sed -i "/pytest-runner/d" setup.py || die
	distutils-r1_python_prepare_all
}
