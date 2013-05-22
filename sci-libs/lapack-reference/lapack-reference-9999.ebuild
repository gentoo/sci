# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit fortran-2 cmake-utils alternatives-2 toolchain-funcs

MYP=lapack-${PV}

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk"
	inherit subversion
	KEYWORDS=""
else
	SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Reference implementation of LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"

LICENSE="BSD"
SLOT="0"

IUSE="static-libs test xblas"

RDEPEND="
	virtual/blas
	xblas? ( sci-libs/xblas )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	# rename library to avoid collision with other lapack implementations
	sed -i \
		-e 's:BINARY_DIR}/lapack.pc:BINARY_DIR}/reflapack.pc:' \
		-e '/export/s:lapack:reflapack:g' \
		-e '/ALL_TARGETS/s:lapack):reflapack):' \
		-e '/LAPACK_LIBRARIES/s:lapack:reflapack:g' \
		CMakeLists.txt || die
	sed -i \
		-e 's:(lapack:(reflapack:g' \
		SRC/CMakeLists.txt || die
	sed -i \
		-e 's:-llapack:-lreflapack:g' \
		lapack.pc.in || die
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
	# some string does not get passed properly
	sed -i \
		-e '/lapack_testing.py/d' \
		CTestCustom.cmake.in || die
	# separate ebuild to tmglib
	sed -i \
		-e '/lapack_install_library(tmglib)/d' \
		TESTING/MATGEN/CMakeLists.txt || die
}

src_configure() {
	lapack_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_BLAS=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
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
	cmake-utils_src_compile
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install
	alternatives_for lapack reference 0 \
		/usr/$(get_libdir)/pkgconfig/lapack.pc reflapack.pc
}
