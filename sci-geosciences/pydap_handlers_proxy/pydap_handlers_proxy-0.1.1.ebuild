# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="Proxy handler for Pydap server that can serve data from other web sites"
HOMEPAGE="http://pydap.org/handlers.html#cdms"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]"
RDEPEND="
	>=sci-geosciences/pydap-3.0_rc8[${PYTHON_USEDEP}]
	>=dev-python/paste-1.7.2[${PYTHON_USEDEP}]
	>=dev-python/configobj-4.6.0[${PYTHON_USEDEP}]"

S="$WORKDIR/$MY_P"
