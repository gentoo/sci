# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils distutils-r1

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/sim-x/${PN}.git http://github.com/sim-x/${PN}.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="https://github.com/sim-x/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="a library for developing parallel, discrete-event simulations in Python"
HOMEPAGE="https://github.com/sim-x"

SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

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
