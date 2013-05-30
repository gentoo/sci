# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils fortran-2

MYP=lapack-3.4.2

DESCRIPTION="Test Matrix Generator library for LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

src_configure() {
	tmg_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_BLAS=ON
			-DUSE_OPTIMIZED_LAPACK=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
			-DTESTING=ON
			$@
		)
		cmake-utils_src_configure
	}

	tmg_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" tmg_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	cmake-utils_src_compile -C TESTING/MATGEN
	use static-libs && CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
		cmake-utils_src_compile -C TESTING/MATGEN
}

src_install() {
	cmake-utils_src_install -C TESTING/MATGEN
	use static-libs && CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
			cmake-utils_src_install -C TESTING/MATGEN
}
