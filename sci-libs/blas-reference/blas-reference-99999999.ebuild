# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs cmake-utils alternatives-2 subversion

DESCRIPTION="Reference implementation of BLAS"
HOMEPAGE="http://www.netlib.org/lapack/"
ESVN_REPO_URI="https://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="static-libs test"

DOCS=( README )

S="${WORKDIR}/${MYP}"

src_prepare() {
	# avoid collision with other blas
	sed -i \
		-e 's:blas:refblas:g' \
		CMakeLists.txt BLAS/blas.pc.in BLAS/{SRC,TESTING}/CMakeLists.txt || die
	sed -i \
		-e 's:BINARY_DIR}/blas:BINARY_DIR}/refblas:' \
		BLAS/CMakeLists.txt || die
	export FC=$(tc-getFC) F77=$(tc-getF77)
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

lapack_configure() {
	mycmakeargs+=(
		-DUSE_OPTIMIZED_BLAS=OFF
		$(cmake-utils_use_build test TESTING)
	)
	cmake-utils_src_configure
}

src_configure() {
	mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
	lapack_configure
	if use static-libs; then
		mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" lapack_configure
	fi
}

src_compile() {
	cmake-utils_src_compile -C BLAS
	if use static-libs; then
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
			cmake-utils_src_compile -C BLAS
	fi
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
	if use static-libs; then
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" \
			cmake-utils_src_install -C BLAS
	fi
	alternatives_for blas reference 0 \
		"/usr/$(get_libdir)/pkgconfig/blas.pc" "refblas.pc"
}
