# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1 git-2

DESCRIPTION="a library for developing parallel, discrete-event simulations in Python"
HOMEPAGE="https://github.com/sim-x"
SRC_URI=""
EGIT_REPO_URI="git://github.com/sim-x/simx.git http://github.com/sim-x/simx.git"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS=""
IUSE=""

RDEPEND=" virtual/mpi
	dev-libs/boost[python] "
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	# don't do egg install
	sed -i 's/self.do_egg_install()/_install.install.run(self)/' setup.py || die
}
