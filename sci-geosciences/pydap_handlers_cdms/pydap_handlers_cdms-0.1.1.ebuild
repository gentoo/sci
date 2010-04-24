# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.4"

inherit python distutils

MY_PN=${PN//_/.}
MY_P=${P//_/.}

DESCRIPTION="CDMS handler for Pydap server that supports netCDF, HDF, GrADS/GRIB, or PCMDI DRS"
HOMEPAGE="http://pydap.org/handlers.html#cdms"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="pydap"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/setuptools-0.6_rc3"
RDEPEND=">=sci-geosciences/pydap-3.0_rc8
	>=sci-geosciences/cdat-lite-5.2
	>=dev-python/arrayterator-1.0.1"

S="$WORKDIR/$MY_P"
