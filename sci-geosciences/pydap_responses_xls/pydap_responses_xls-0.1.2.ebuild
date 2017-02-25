# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Excel responses for Pydap Data Access Protocol server"
HOMEPAGE="http://pydap.org"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]"
RDEPEND="
	>=sci-geosciences/pydap-3.0_rc10[${PYTHON_USEDEP}]
	>=dev-python/xlwt-0.7.2[${PYTHON_USEDEP}]"

S="$WORKDIR/$MY_P"
