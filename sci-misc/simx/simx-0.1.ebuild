# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit cmake-utils distutils-r1

DESCRIPTION="a library for developing parallel, discrete-event simulations in Python"
HOMEPAGE="https://github.com/sim-x"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="
	virtual/mpi
	dev-libs/boost[python,${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	# don't do egg install
	sed -i 's/self.do_egg_install()/_install.install.run(self)/' setup.py || die

	epatch "${FILESDIR}/${P}-python-check.patch"
}
