# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EBASE_PROFNAME="reflapack"
ESTATIC_MULTIBUILD=1
inherit fortran-2 cmake-utils multibuild alternatives-2 multilib-build toolchain-funcs fortran-int64

if [[ ${PV} == "9999" ]] ; then
	# The master ESVN_REPO_URI is difficult to access, the git mirror is easier
	# ESVN_REPO_URI="https://icl.cs.utk.edu/svn/lapack-dev/lapack/trunk"
	# MY_PN=lapack
	# inherit subversion
	EGIT_REPO_URI="https://github.com/nschloe/lapack.git"
	MY_PN=lapack-reference
	MYP=${MY_PN}-${PV}
	inherit git-r3
	KEYWORDS=""
else
	MY_PN=lapack
	MYP=${MY_PN}-${PV}
	SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Reference implementation of LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"

LICENSE="BSD"
SLOT="0"

IUSE="int64 static-libs test xblas"

RDEPEND="
	>=virtual/blas-2.1-r3[int64?]
	xblas? ( sci-libs/xblas[fortran,int64?] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="
	>=virtual/lapack-3.5-r2[int64?]"

S="${WORKDIR}/${MYP}"

src_prepare() {
	fortran-int64_ensure_blas

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
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_configure() {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		local blas_profname=$(fortran-int64_get_blas_profname)
		local xblas_profname=$(fortran-int64_get_xblas_profname)
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
			-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) $(get_abi_CFLAGS) $(fortran-int64_get_fortran_int64_abi_fflags) ${FCFLAGS}"
			-DLAPACK_PKGCONFIG_FFLAGS="$(fortran-int64_get_fortran_int64_abi_fflags)"
		)
		use xblas && \
			mycmakeargs+=( -DXBLAS_LIBRARY:FILEPATH="${EROOT}usr/$(get_libdir)/lib${xblas_libname}.so" )
		if $(fortran-int64_is_static_build); then
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
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper my_src_configure
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper cmake-utils_src_compile
}

src_test() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper cmake-utils_src_test
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_install()  {
		cmake-utils_src_install
		if ! $(fortran-int64_is_static_build); then
			local profname=$(fortran-int64_get_profname)
			local provider=$(fortran-int64_get_lapack_provider)
			alternatives_for ${provider} $(fortran-int64_get_profname "reference") 0 \
				/usr/$(get_libdir)/pkgconfig/${provider}.pc ${profname}.pc
		fi
	}
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper my_src_install
}
