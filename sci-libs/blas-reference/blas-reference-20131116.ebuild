# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit fortran-2 cmake-utils alternatives-2

LPN=lapack
LPV=3.5.0

if [[ ${PV} == "99999999" ]] ; then
	ESVN_REPO_URI="https://icl.cs.utk.edu/svn/lapack-dev/${LPN}/trunk"
	inherit subversion
	KEYWORDS=""
else
	SRC_URI="http://www.netlib.org/${LPN}/${LPN}-${LPV}.tgz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Reference implementation of BLAS"
HOMEPAGE="http://www.netlib.org/lapack/"

LICENSE="BSD"
SLOT="0"
IUSE="static-libs test"

S="${WORKDIR}/${LPN}-${LPV}"

src_prepare() {
	# rename library to avoid collision with other blas implementations
	sed -i \
		-e 's:blas:refblas:g' \
		CMakeLists.txt BLAS/blas.pc.in \
		BLAS/{SRC,TESTING}/CMakeLists.txt || die
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
