# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

NUMERIC_MODULE_NAME="refblas"

inherit alternatives-2 cmake-utils fortran-2 numeric-int64-multibuild python-any-r1 toolchain-funcs

LPN=lapack
LPV=3.6.0

DESCRIPTION="Reference implementation of BLAS"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/${LPN}/${LPN}-${LPV}.tgz"

LICENSE="BSD"
SLOT="0/${LPV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	virtual/pkgconfig"

S="${WORKDIR}/${LPN}-${LPV}"

src_prepare() {
	# rename library to avoid collision with other blas implementations
	# ${LIBNAME} and ${PROFNAME} are not defined here, they are in single
	# quotes in the following seds.  They are later set by defining cmake
	# variables with -DPROFNAME etc in src_configure
	sed -i \
		-e 's:\([^xc]\)blas:\1${LIBNAME}:g' \
		-e '/PROPERTIES/s:blas:${LIBNAME}:g' \
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
	blas_configure() {
		local FCFLAGS="${FCFLAGS}"
		append-fflags $($(tc-getPKG_CONFIG) --cflags ${blas_profname})
		append-fflags $(get_abi_CFLAGS)
		append-fflags $(numeric-int64_get_fortran_int64_abi_fflags)

		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"

		local mycmakeargs=(
			-Wno-dev
			-DPROFNAME="${profname}"
			-DLIBNAME="${libname}"
			-DUSE_OPTIMIZED_BLAS=OFF
			-DCMAKE_Fortran_FLAGS="${FCFLAGS}"
			-DLAPACK_PKGCONFIG_FFLAGS="$(numeric-int64_get_fortran_int64_abi_fflags)"
			$(cmake-utils_use_build test TESTING)
		)
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
	numeric-int64-multibuild_foreach_all_abi_variants blas_configure
}

src_compile() {
	local each target_dirs=( BLAS )
	use test && target_dirs+=( TESTING )
	for each in ${target_dirs[@]}; do
		numeric-int64-multibuild_foreach_all_abi_variants \
			cmake-utils_src_compile -C ${each}
	done

}

src_test() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_test
}

src_install() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_install -C BLAS
	numeric-int64-multibuild_install_alternative blas reference
}
