# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="Handler for Pydap server that allows serving data from SQLite files"
HOMEPAGE="http://pydap.org/handlers.html#sqlite"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND="
	>=sci-geosciences/pydap-3.0
	>=dev-python/simplejson-2.1.6
	>=dev-python/numpy-1.5.1"

S="$WORKDIR/$MY_P"
