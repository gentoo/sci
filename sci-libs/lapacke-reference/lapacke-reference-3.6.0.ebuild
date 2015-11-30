# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=test

inherit alternatives-2 cmake-utils eutils fortran-2 toolchain-funcs

MYP=lapack-${PV}

DESCRIPTION="C Interface to LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test tmg xblas"

RDEPEND="
	virtual/blas
	virtual/lapack
	tmg? ( sci-libs/tmglib )
	xblas? ( sci-libs/xblas )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	# rename libraries to avoid collision with other lapacke
	sed -i \
		-e 's:BINARY_DIR}/lapacke.pc:BINARY_DIR}/reflapacke.pc:' \
		-e '/export/s:lapacke:reflapacke:g' \
		-e '/ALL_TARGETS/s:lapacke):reflapacke):' \
		-e '/LAPACK_LIBRARIES/s:lapacke:reflapacke:g' \
		CMakeLists.txt || die
	sed -i \
		-e '/librar/s:(lapacke:(reflapacke:g' \
		LAPACKE/CMakeLists.txt || die
	sed -i \
		-e '/librar/s:lapacke:reflapacke:g' \
		LAPACKE/example/CMakeLists.txt || die
	local tmgpc; use tmg && tmgpc=" -ltmglib"
	sed -i \
		-e "s:-llapacke:-lreflapacke${tmgpc}:g" \
		LAPACKE/lapacke.pc.in || die
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

src_configure() {
	lapack_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_BLAS=ON
			-DUSE_OPTIMIZED_LAPACK=ON
			-DLAPACKE=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
			$(cmake-utils_use tmg LAPACKE_WITH_TMG)
			$(cmake-utils_use_build test TESTING)
			$(cmake-utils_use_use xblas XBLAS)
			$@
		)
		cmake-utils_src_configure
	}

	lapack_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" lapack_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	use test && cmake-utils_src_compile -C TESTING/MATGEN
	cmake-utils_src_compile -C LAPACKE
	use static-libs \
		&& BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_compile -C LAPACKE
}

src_test() {
	pushd "${BUILD_DIR}/LAPACKE" > /dev/null || die
	local ctestargs
	[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"
	ctest ${ctestargs} || die
	popd > /dev/null || die
}

src_install() {
	cmake-utils_src_install -C LAPACKE
	use static-libs \
		&& BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install -C LAPACKE
	alternatives_for lapacke reference 0 \
		/usr/$(get_libdir)/pkgconfig/lapacke.pc reflapacke.pc
}
