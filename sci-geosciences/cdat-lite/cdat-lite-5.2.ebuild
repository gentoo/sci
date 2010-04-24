# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.5"

inherit python distutils

MY_P=${P/-/_}

DESCRIPTION="CDAT-Lite is a large suite of open source tools for the management and analysis of climate data."
HOMEPAGE="http://proj.badc.rl.ac.uk/ndg/wiki/CdatLite"
SRC_URI="http://ndg.nerc.ac.uk/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=sci-libs/netcdf-4.0.1
	>=sci-libs/hdf5-1.6.4"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools"
RDEPEND="${COMMON_DEPEND}"

src_compile()(
	find "${S}" -type l -exec rm '{}' \;
	distutils_src_compile
)

S="${WORKDIR}/${MY_P}"
