# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

NUMERIC_MODULE_NAME="reflapack"

inherit alternatives-2 cmake-utils fortran-2 git-r3 numeric-int64-multibuild python-any-r1

# The master ESVN_REPO_URI is difficult to access, the git mirror is easier
# ESVN_REPO_URI="https://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk"
# MY_PN=lapack
# inherit subversion

MY_PN=lapack-reference
MYP=${MY_PN}-${PV}

DESCRIPTION="Reference implementation of LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
EGIT_REPO_URI="https://github.com/nschloe/lapack.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="static-libs test xblas"

REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=virtual/blas-2.1-r3[int64?,${MULTILIB_USEDEP}]
	xblas? ( sci-libs/xblas[fortran,int64?] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )"

S="${WORKDIR}/${MYP}"

src_prepare() {
	numeric-int64_ensure_blas_int_support

	# rename library to avoid collision with other lapack implementations
	# ${PROFNAME}, ${LIBNAME} and ${BLAS_REQUIRES} are not defined here, they
	# are in single quotes in the following seds.  They are set later by
	# defining a cmake variables with -DPROFNAME etc in src_configure.
	sed -i \
		-e 's:BINARY_DIR}/lapack.pc:BINARY_DIR}/${PROFNAME}.pc:' \
		-e '/ALL_TARGETS/s:lapack):${LIBNAME}):' \
		-e '/LAPACK_LIBRARIES/s:lapack:${LIBNAME}:g' \
		CMakeLists.txt || die
	sed -i \
		-e 's:(lapack:(${LIBNAME}:g' \
		SRC/CMakeLists.txt || die
	sed -i \
		-e '/Name: /s:lapack:${PROFNAME}:' \
		-e 's:-llapack:-l${LIBNAME}:g' \
		-e '/Requires: /s:blas:${BLAS_REQUIRES}\nFflags=${LAPACK_PKGCONFIG_FFLAGS}:' \
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
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs ${blas_profname})"
			$(cmake-utils_use_build test TESTING)
			$(cmake-utils_use_use xblas XBLAS)
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
