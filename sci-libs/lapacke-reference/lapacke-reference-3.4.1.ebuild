# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils fortran-2 alternatives-2

MYP=lapack-${PV}

DESCRIPTION="C Interface to LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test xblas"

RDEPEND="virtual/blas
	virtual/lapack
	xblas? ( sci-libs/xblas )"
DEPEND="${RDEPEND}
	test? ( virtual/fortran )
	dev-util/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${MYP}-cmake.patch
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

src_configure() {
	lapack_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_BLAS=ON
			-DUSE_OPTIMIZED_LAPACK=ON
			-DLAPACKE=ON
			-DBLAS_LIBRARIES="$(pkg-config --libs blas)"
			-DLAPACK_LIBRARIES="$(pkg-config --libs lapack)"
			$(cmake-utils_use_build test TESTING)
			$(cmake-utils_use_use xblas XBLAS)
			$@
		)
		cmake-utils_src_configure
	}

	lapack_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" lapack_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	use test && cmake-utils_src_compile -C TESTING/MATGEN
	cmake-utils_src_compile -C lapacke
	use static-libs && CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
			cmake-utils_src_compile -C lapacke
}

src_test() {
	pushd "${CMAKE_BUILD_DIR}/lapacke" > /dev/null
	local ctestargs
	[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"
	ctest ${ctestargs} || die
	popd > /dev/null
}

src_install() {
	cmake-utils_src_install -C lapacke
	use static-libs && CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
		cmake-utils_src_install -C lapacke
	alternatives_for lapacke reference 0 \
		/usr/$(get_libdir)/pkgconfig/lapacke.pc reflapacke.pc
}
