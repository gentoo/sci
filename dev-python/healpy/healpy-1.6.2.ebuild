# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Python wrapper for healpix"
HOMEPAGE="https://github.com/healpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyfits[${PYTHON_USEDEP}]
	sci-astronomy/healpix_cxx
	sci-libs/cfitsio"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

python_test() {
	cd "${BUILD_DIR}"/lib || die
	echo "backend: Agg" > matplotlibrc || die
	MPLCONFIGDIR=. nosetests || die
	rm matplotlibrc || die
}
