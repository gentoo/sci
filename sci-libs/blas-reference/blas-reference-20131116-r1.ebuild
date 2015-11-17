# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBASE_PROFNAME="refblas"
ESTATIC_MULTIBUILD="true"
inherit fortran-2 cmake-utils alternatives-2 multibuild multilib-build toolchain-funcs fortran-int64

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
IUSE="int64 static-libs test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND=">=virtual/blas-2.1-r3[int64?]"

S="${WORKDIR}/${LPN}-${LPV}"

src_prepare() {
	# rename library to avoid collision with other blas implementations
	# ${LIBNAME} and ${PROFNAME} are not defined here, they are in single
	# quotes in the following seds.  They are later set by defining cmake
	# variables with -DPROFNAME etc in src_configure
	sed -i \
		-e 's:\([^xc]\)blas:\1${LIBNAME}:g' \
		CMakeLists.txt \
		BLAS/SRC/CMakeLists.txt || die
	sed -i \
		-e '/Name: /s:blas:${PROFNAME}:' \
		-e 's:-lblas:-l${LIBNAME}:g' \
		 BLAS/blas.pc.in || die
	sed -i \
		-e 's:blas):${LIBNAME}):' \
		BLAS/TESTING/CMakeLists.txt || die
	sed -i \
		-e 's:BINARY_DIR}/blas:BINARY_DIR}/${PROFNAME}:' \
		BLAS/CMakeLists.txt || die
}

src_configure() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	blas_configure() {
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		local mycmakeargs=(
			-Wno-dev
			-DPROFNAME="${profname}"
			-DLIBNAME="${libname}"
			-DUSE_OPTIMIZED_BLAS=OFF
			$(cmake-utils_use_build test TESTING)
			-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) $(get_abi_CFLAGS) $(fortran-int64_get_fortran_int64_abi_fflags) ${FCFLAGS}"
			-DLAPACK_PKGCONFIG_FFLAGS="$(fortran-int64_get_fortran_int64_abi_fflags)"
		)
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
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper blas_configure
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper cmake-utils_src_compile -C BLAS
}

src_test() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	blas_test() {
		_check_build_dir
		pushd "${BUILD_DIR}/BLAS" > /dev/null
		local ctestargs
		[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"
		ctest ${ctestargs} || die
		popd > /dev/null
	}
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper blas_test
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_install()  {
		cmake-utils_src_install -C BLAS
		if ! $(fortran-int64_is_static_build); then
			local profname=$(fortran-int64_get_profname)
			local provider=$(fortran-int64_get_blas_provider)
			alternatives_for ${provider} $(fortran-int64_get_profname "reference") 0 \
				/usr/$(get_libdir)/pkgconfig/${provider}.pc ${profname}.pc
		fi
	}
	multibuild_foreach_variant fortran-int64_multilib_multibuild_wrapper my_src_install
}
