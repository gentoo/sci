# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="GUI for ffnet - feed forward neural network for python"
HOMEPAGE="http://ffnet.sourceforge.net"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	>=dev-python/ffnet-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-1.4[${PYTHON_USEDEP}]
	dev-python/traitsui[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
