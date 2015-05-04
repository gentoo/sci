# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit alternatives-2 cmake-utils eutils fortran-2 toolchain-funcs

FORTRAN_NEEDED=test

MYP=lapack-${PV}

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk"
	inherit subversion
	KEYWORDS=""
else
	SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="C Interface to LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"

LICENSE="BSD"
SLOT="0"
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
		-e 's:(lapacke:(reflapacke:g' \
		lapacke/CMakeLists.txt || die
	sed -i \
		-e 's:lapacke:reflapacke:g' \
		lapacke/example/CMakeLists.txt || die
	local tmgpc; use tmg && tmgpc=" -ltmglib"
	sed -i \
		-e "s:-llapacke:-lreflapacke${tmgpc}:g" \
		lapacke/lapacke.pc.in || die
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
