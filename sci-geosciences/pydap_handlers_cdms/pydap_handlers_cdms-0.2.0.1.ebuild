# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="CDMS handler for Pydap server that supports netCDF, HDF, GrADS/GRIB, or PCMDI DRS"
HOMEPAGE="http://pydap.org/handlers.html#cdms"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3[${PYTHON_USEDEP}]"
RDEPEND="
	>=sci-geosciences/pydap-3.0_rc10[${PYTHON_USEDEP}]
	>=sci-geosciences/cdat-lite-6.0_alpha[${PYTHON_USEDEP}]
	>=dev-python/arrayterator-1.0.1[${PYTHON_USEDEP}]"

S="$WORKDIR/$MY_P"
