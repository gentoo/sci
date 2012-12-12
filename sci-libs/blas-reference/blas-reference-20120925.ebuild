# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit alternatives-2 eutils cmake-utils fortran-2

MYP=lapack-3.4.2

DESCRIPTION="Reference implementation of BLAS"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MYP}"

src_prepare() {
	# avoid collision with other blas
	sed -i \
		-e 's:blas:refblas:g' \
		CMakeLists.txt BLAS/blas.pc.in BLAS/{SRC,TESTING}/CMakeLists.txt || die
	sed -i \
		-e 's:BINARY_DIR}/blas:BINARY_DIR}/refblas:' \
		BLAS/CMakeLists.txt || die
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

src_configure() {
	blas_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_BLAS=OFF
			$(cmake-utils_use_build test TESTING)
			$@
		)
		cmake-utils_src_configure
	}

	blas_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" blas_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	cmake-utils_src_compile -C BLAS
	use static-libs && CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
		cmake-utils_src_compile -C BLAS
}

src_test() {
	pushd "${CMAKE_BUILD_DIR}/BLAS" > /dev/null
	local ctestargs
	[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"
	ctest ${ctestargs} || die
	popd > /dev/null
}

src_install() {
	cmake-utils_src_install -C BLAS
	use static-libs && CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
			cmake-utils_src_install -C BLAS
	alternatives_for blas reference 0 \
		/usr/$(get_libdir)/pkgconfig/blas.pc refblas.pc
}
