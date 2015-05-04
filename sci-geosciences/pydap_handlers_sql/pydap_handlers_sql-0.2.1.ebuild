# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="SQL handler for Pydap server that allows serving data from SQL databases"
HOMEPAGE="http://pydap.org/handlers.html#cdms"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE="postgres mysql"

DEPEND=">=dev-python/setuptools-0.6_rc3
	>=dev-python/paver-1.0.4"
RDEPEND="
	>=sci-geosciences/pydap-3.0_rc8
	>=sci-geosciences/cdat-lite-5.2
	>=dev-python/arrayterator-1.0.1
	postgres? ( >=dev-python/psycopg-2 )
	mysql? ( >=dev-python/mysql-python-1.2.3_rc1 )"

	# When cx_oracle is available...
	# oracle? >=dev-python/cx_oracle

	# Currently adodbapi is only availble for Windows so mssql support is not available.
	# If pydap used dev-python/pymssql that would be better.

S="$WORKDIR/$MY_P"

src_prepare() {
	paver generate_setup || die
	distutils_src_prepare
}
