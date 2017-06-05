# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

NUMERIC_MODULE_NAME="reflapack"

inherit alternatives-2 cmake-utils eutils fortran-2 numeric-int64-multibuild python-any-r1

MY_PN=lapack
MYP=${MY_PN}-${PV}

DESCRIPTION="Reference implementation of LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+deprecated static-libs test xblas"

REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=virtual/blas-2.1-r3[int64?,${MULTILIB_USEDEP}]
	xblas? ( sci-libs/xblas[fortran,int64?] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )"

S="${WORKDIR}/${MYP}"
PATCHES=( "${FILESDIR}/lapack-reference-${PV}-fix-build-system.patch" )

src_prepare() {
	numeric-int64_ensure_blas_int_support

	default

	# rename library to avoid collision with other lapack implementations
	# ${PROFNAME}, ${LIBNAME} and ${BLAS_REQUIRES} are not defined here, they
	# are in single quotes in the following seds.  They are set later by
	# defining a cmake variables with -DPROFNAME etc in src_configure.
	sed \
		-e 's:BINARY_DIR}/lapack.pc:BINARY_DIR}/${PROFNAME}.pc:' \
		-e '/ALL_TARGETS/s:lapack):${LIBNAME}):' \
		-e '/LAPACK_LIBRARIES/s:lapack:${LIBNAME}:g' \
		-i CMakeLists.txt || die
	sed -i \
		-e 's:(lapack:(${LIBNAME}:g' \
		-e '/PROPERTIES/s:lapack:${LIBNAME}:g' \
		SRC/CMakeLists.txt || die
	sed -i \
		-e '/Name: /s:lapack:@PROFNAME@:' \
		-e 's:-llapack:-l@LIBNAME@:g' \
		-e '/Requires: /s:blas:@BLAS_REQUIRES@\nFflags\: ${LAPACK_PKGCONFIG_FFLAGS}:' \
		lapack.pc.in || die
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
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"
		local blas_profname=$(numeric-int64_get_blas_alternative)
		local xblas_profname=$(numeric-int64_get_xblas_alternative)
		local xblas_libname="${xblas_profname//-/_}"
		local blas_requires="${blas_profname}"
		use xblas && \
			blas_requires+=" ${xblas_profname}"
		local mycmakeargs=(
			-DPROFNAME="${profname}"
			-DBLAS_REQUIRES="${blas_requires}"
			-DLIBNAME="${libname}"
			-DUSE_OPTIMIZED_BLAS=ON
			-DBUILD_TESTING="$(usex test)"
			-DUSE_XBLAS="$(usex xblas)"
			-DBUILD_DEPRECATED="$(usex deprecated)"
			-DCMAKE_C_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) ${CFLAGS}"
			-DCMAKE_CXX_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) ${CXXFLAGS}"
			-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) $(get_abi_CFLAGS) $(numeric-int64_get_fortran_int64_abi_fflags) ${FCFLAGS}"
			-DLAPACK_PKGCONFIG_FFLAGS="$(numeric-int64_get_fortran_int64_abi_fflags)"
		)
		use xblas && \
			mycmakeargs+=( -DXBLAS_LIBRARY:FILEPATH="${EROOT}usr/$(get_libdir)/lib${xblas_libname}.so" )
		if $(numeric-int64_is_static_build); then
			mycmakeargs+=(
				-DBUILD_SHARED_LIBS=OFF
				-DBUILD_STATIC_LIBS=ON
			)
		else
			mycmakeargs+=(
				-DBUILD_SHARED_LIBS=ON
				-DBUILD_STATIC_LIBS=OFF
			)
		fi
		cmake-utils_src_configure
	}
	numeric-int64-multibuild_foreach_all_abi_variants lapack_configure
}

src_compile() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_compile
}

src_test() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_test
}

src_install() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_install
	numeric-int64-multibuild_install_alternative lapack reference
}
