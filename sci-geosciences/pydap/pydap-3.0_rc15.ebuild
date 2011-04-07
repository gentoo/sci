# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN=${PN/pydap/Pydap}
MY_P=${P/pydap/Pydap}
MY_P=${MY_P/_rc/.rc.}

DESCRIPTION="Data Access Protocol client and server."
HOMEPAGE="http://pydap.org"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND=">=dev-python/numpy-1.2.1
	>=dev-python/httplib2-0.4.0
	>=dev-python/genshi-0.5.1
	>=dev-python/paste-1.7.2
	>=dev-python/pastescript-1.7.2
	>=dev-python/pastedeploy-1.3.3"

S="$WORKDIR/$MY_P"
