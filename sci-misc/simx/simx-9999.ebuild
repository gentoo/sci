# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils distutils-r1 git-r3

DESCRIPTION="Library for developing parallel, discrete-event simulations in Python"
HOMEPAGE="https://github.com/sim-x"
SRC_URI=""
EGIT_REPO_URI="git://github.com/sim-x/${PN}.git http://github.com/sim-x/${PN}.git"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/mpi
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/cmake"

python_prepare_all() {
	# don't do egg install
	sed \
		-e 's/self.do_egg_install()/_install.install.run(self)/' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
