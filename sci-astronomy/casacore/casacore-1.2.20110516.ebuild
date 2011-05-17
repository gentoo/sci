# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils cmake-utils

DESCRIPTION="Core libraries for the Common Astronomy Software Applications"
HOMEPAGE="http://code.google.com/p/casacore/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc fftw hdf5 test"

RDEPEND="sci-libs/cfitsio
	sci-astronomy/wcslib
	virtual/blas
	virtual/lapack
	sys-libs/readline
	hdf5? ( sci-libs/hdf5 )
	fftw? ( >=sci-libs/fftw-3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}"/${PV}-{headers,implicits,libdir}.patch )

src_configure() {
	has_version sci-libs/hdf5[mpi] && export CXX=mpicxx
	mycmakeargs+=(
		-DENABLE_SHARED=YES
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_use hdf5 HDF5)
		$(cmake-utils_use_use fftw FFTW3)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && doxygen doxygen.cfg
}

src_install(){
	cmake-utils_src_compile
	use doc && dohtml -r doc/html
}
