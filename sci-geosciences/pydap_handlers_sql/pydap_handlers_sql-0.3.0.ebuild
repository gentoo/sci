# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="SQL handler for Pydap server that allows serving data from SQL databases"
HOMEPAGE="http://pydap.org/handlers.html#cdms"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE="postgres mysql"

DEPEND="
	>=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]
	>=dev-python/paver-1.0.4[${PYTHON_USEDEP}]"
RDEPEND="
	>=sci-geosciences/pydap-3.0_rc8[${PYTHON_USEDEP}]
	>=sci-geosciences/cdat-lite-5.2[${PYTHON_USEDEP}]
	>=dev-python/arrayterator-1.0.1[${PYTHON_USEDEP}]
	postgres? ( >=dev-python/psycopg-2[${PYTHON_USEDEP}] )
	mysql? ( >=dev-python/mysql-python-1.2.3_rc1[${PYTHON_USEDEP}] )"

	# When cx_oracle is available...
	# oracle? >=dev-python/cx_oracle

	# Currently adodbapi is only availble for Windows so mssql support is not available.
	# If pydap used dev-python/pymssql that would be better.

S="$WORKDIR/$MY_P"

python_prepare_all() {
	paver generate_setup || die
	distutils-r1_python_prepare_all
}
