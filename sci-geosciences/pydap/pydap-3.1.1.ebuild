# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN/pydap/Pydap}
MY_P=${P/pydap/Pydap}
MY_P=${MY_P/_rc/.rc.}

DESCRIPTION="Data Access Protocol client and server"
HOMEPAGE="http://pydap.org"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/wsgiintercept[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/genshi-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/paste-1.7.2[${PYTHON_USEDEP}]
	>=dev-python/pastescript-1.7.2[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.3.3[${PYTHON_USEDEP}]"

S="$WORKDIR"/${MY_P}

python_test() {
	esetup.py test
}
