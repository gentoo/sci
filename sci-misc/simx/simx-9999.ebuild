# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit cmake-utils distutils-r1 git-r3

DESCRIPTION="a library for developing parallel, discrete-event simulations in Python"
HOMEPAGE="https://github.com/sim-x"
SRC_URI=""

SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""
KEYWORDS=""

RDEPEND="
	virtual/mpi
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	# don't do egg install
	sed -i 's/self.do_egg_install()/_install.install.run(self)/' setup.py || die
}
