# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 toolchain-funcs

MY_P=${P/-/_}

DESCRIPTION="Large suite of open source tools for the management and analysis of climate data"
HOMEPAGE="http://proj.badc.rl.ac.uk/cedaservices/wiki/CdatLite"
SRC_URI="http://ndg.nerc.ac.uk/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	>=sci-libs/netcdf-4.0.1
	>=sci-libs/hdf5-1.6.4"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${COMMON_DEPEND}
	!sci-biology/ncbi-tools"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PV}-shared-lib.patch
	"${FILESDIR}"/${PV}-impl-dec.patch
	)

python_prepare_all() {
	find "${S}" -type l -exec rm '{}' \;
	tc-export CC
	sed \
		-e 's:libhdf5.a:libhdf5.so:g' \
		-i setup_util.py || die
	distutils-r1_python_prepare_all
}
