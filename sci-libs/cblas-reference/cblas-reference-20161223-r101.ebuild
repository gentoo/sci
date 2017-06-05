# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

NUMERIC_MODULE_NAME="refcblas"

inherit alternatives-2 cmake-utils eutils fortran-2 numeric-int64-multibuild python-any-r1 toolchain-funcs

LPN=lapack
LPV=3.7.0

DESCRIPTION="C wrapper interface to the F77 reference BLAS implementation"
HOMEPAGE="http://www.netlib.org/cblas/"
SRC_URI="http://www.netlib.org/${LPN}/${LPN}-${LPV}.tgz"

LICENSE="BSD"
SLOT="0/${LPV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	virtual/pkgconfig"

S="${WORKDIR}/${LPN}-${LPV}"
PATCHES=( "${FILESDIR}/lapack-reference-${LPV}-fix-build-system.patch" )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/cblas/cblas.h
)
src_prepare() {
	default

	# rename library to avoid collision with other blas implementations
	# ${LIBNAME} and ${PROFNAME} are not defined here, they are in single
	# quotes in the following seds.  They are later set by defining cmake
	# variables with -DPROFNAME etc in src_configure
	sed -i \
		-e 's:\([^xc]\)blas:\1${LIBNAME}:g' \
		-e '/ALL_TARGETS/s:cblas):${LIBNAME}):' \
		-e '/_librar/s:cblas:${LIBNAME}:' \
		CMakeLists.txt \
		CBLAS/src/CMakeLists.txt || die
	sed -i \
		-e 's:/CMAKE/:/cmake/:g' \
		CBLAS/CMakeLists.txt || die
	sed -i \
		-e '/Name: /s:cblas:@PROFNAME@:' \
		-e 's:-lcblas:-l@LIBNAME@:g' \
		 CBLAS/cblas.pc.in || die
	sed -i \
		-e 's:cblas):${LIBNAME}):' \
		CBLAS/testing/CMakeLists.txt || die
	sed -i \
		-e 's:BINARY_DIR}/cblas:BINARY_DIR}/${PROFNAME}:' \
		-e '/install/s:include):include/${PROFNAME}):g' \
		CBLAS/CMakeLists.txt || die
}

src_configure() {
	cblas_configure() {
		local FCFLAGS="${FCFLAGS}"
		append-fflags $($(tc-getPKG_CONFIG) --cflags ${blas_profname})
		append-fflags $(get_abi_CFLAGS)
		append-fflags $(numeric-int64_get_fortran_int64_abi_fflags)

		local blas_profname=$(numeric-int64_get_blas_alternative)
		local profname=$(numeric-int64_get_module_name)
		local libname="${profname//-/_}"

		local mycmakeargs=(
			-Wno-dev
			-DCBLAS=ON
			-DPROFNAME="${profname}"
			-DLIBNAME="${libname}"
			-DUSE_OPTIMIZED_BLAS=ON
			-DCMAKE_C_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) ${CFLAGS}"
			-DCMAKE_CXX_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) ${CXXFLAGS}"
			-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) $(get_abi_CFLAGS) $(numeric-int64_get_fortran_int64_abi_fflags) ${FCFLAGS}"
			-DLAPACK_PKGCONFIG_FFLAGS="$(numeric-int64_get_fortran_int64_abi_fflags)"
			-DBUILD_TESTING=$(usex test)
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
	numeric-int64-multibuild_foreach_all_abi_variants cblas_configure
}

src_compile() {
	local each target_dirs=( CBLAS )
	use test && target_dirs+=( testing )
	for each in ${target_dirs[@]}; do
		numeric-int64-multibuild_foreach_all_abi_variants \
			cmake-utils_src_compile -C ${each}
	done

}

src_test() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_test
}

src_install() {
	numeric-int64-multibuild_foreach_all_abi_variants cmake-utils_src_install -C CBLAS
	numeric-int64-multibuild_install_alternative cblas reference /usr/include/cblas.h refcblas/cblas.h
	multilib_install_wrappers
}
