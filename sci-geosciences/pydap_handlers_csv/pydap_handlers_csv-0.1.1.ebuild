# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="Comma Separated Values (CSV) handler for Pydap server"
HOMEPAGE="http://pydap.org/handlers.html#csv"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND=">=sci-geosciences/pydap-3.0_rc10"

S="$WORKDIR/$MY_P"
