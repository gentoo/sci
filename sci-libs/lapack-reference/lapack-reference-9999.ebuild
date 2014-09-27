# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit fortran-2 cmake-utils multibuild alternatives-2 multilib-build toolchain-funcs

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
	>=virtual/blas-2.1-r1[int64?]
	>=virtual/lapack-3.5-r2[int64?]
	xblas? ( sci-libs/xblas[fortran] )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

INT64_SUFFIX="int64"
STATIC_SUFFIX="static"
BASE_PROFNAME="reflapack"

get_profname() {
	local profname="${1:-${BASE_PROFNAME}}"
	if [[ "${MULTIBUILD_ID}" =~ "_${INT64_SUFFIX}" ]]; then
		profname+="-${INT64_SUFFIX}"
	fi
	echo "${profname}"
}

get_variant_suffix() {
	local profname="${1:-$(get_profname)}"
	local variant_suffix="${profname//${BASE_PROFNAME}/}"
	echo "${variant_suffix}"
}

get_blas_module() {
	local module_name="blas"
	if [[ "${MULTIBUILD_ID}" =~ "_${INT64_SUFFIX}" ]]; then
		module_name+="-${INT64_SUFFIX}"
	fi
	echo "${module_name}"
}

get_blas_profname() {
	local profname="${1:-$(get_profname)}"
	local variant_suffix=$(get_variant_suffix "${profname}")
	local blas_profile=$(eselect $(get_blas_module) show)
	local selected_blas_profile="${blas_profile}"
	local blas_no_int64="${selected_blas_profile/-int64/}"
	local blas_base="${blas_no_int64%-*}"
	local blas_name="${blas_no_int64/${blas_base}/${blas_base}${variant_suffix}}"
	echo "${blas_name}"
}

get_lapack_module() {
	local module_name="lapack"
	if [[ "${MULTIBUILD_ID}" =~ "_${INT64_SUFFIX}" ]]; then
		module_name+="-${INT64_SUFFIX}"
	fi
	echo "${module_name}"
}

int64_multilib_get_enabled_abis() {
	local MULTILIB_VARIANTS=( $(multilib_get_enabled_abis) )
	local MULTILIB_INT64_VARIANTS=()
	local i
	for i in "${MULTILIB_VARIANTS[@]}"; do
		if use int64 && [[ "${i}" =~ 64$ ]]; then
			MULTILIB_INT64_VARIANTS+=( "${i}_${INT64_SUFFIX}" )
		fi
		MULTILIB_INT64_VARIANTS+=( "${i}" )
	done
	local MULTIBUILD_VARIANTS=()
	local j
	for j in "${MULTILIB_INT64_VARIANTS[@]}"; do
		use static-libs && MULTIBUILD_VARIANTS+=( "${j}_${STATIC_SUFFIX}" )
		MULTIBUILD_VARIANTS+=( "${j}" )
	done
	echo "${MULTIBUILD_VARIANTS[@]}"
}

# @FUNCTION: _int64_multilib_multibuild_wrapper
# @USAGE: <argv>...
# @INTERNAL
# @DESCRIPTION:
# Initialize the environment for ABI selected for multibuild.
_int64_multilib_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"
	local v="${MULTIBUILD_VARIANT/_${INT64_SUFFIX}/}"
	local ABI="${v/_${STATIC_SUFFIX}/}"
	multilib_toolchain_setup "${ABI}"
	"${@}"
}

src_prepare() {
	local MULTIBUILD_VARIANTS=( $(int64_multilib_get_enabled_abis) )
	if use int64; then
		local blas_int64_profname=$(get_blas_profname "${BASE_PROFNAME}-${INT64_SUFFIX}")
		$(tc-getPKG_CONFIG) --exists "${blas_int64_profname}" || die "Use int64 requires ${blas_int64_profname}"
	fi

	# rename library to avoid collision with other lapack implementations
	local LIBNAME="${PROFNAME//-/_}"
	sed -i \
		-e 's:BINARY_DIR}/lapack.pc:BINARY_DIR}/${PROFNAME}.pc:' \
		-e '/export/s:lapack:${LIBNAME}:g' \
		-e '/ALL_TARGETS/s:lapack):${LIBNAME}):' \
		-e '/LAPACK_LIBRARIES/s:lapack:${LIBNAME}:g' \
		CMakeLists.txt || die
	sed -i \
		-e 's:(lapack:(${LIBNAME}:g' \
		SRC/CMakeLists.txt || die
	sed -i \
		-e 's:-llapack:-l${LIBNAME}:g' \
		-e 's/Requires: blas/Requires: ${BLAS_PROFNAME}\nFflags=${LAPACK_PKGCONFIG_FFLAGS}/' \
		lapack.pc.in || die
	# some string does not get passed properly
	sed -i \
		-e '/lapack_testing.py/d' \
		CTestCustom.cmake.in || die
	# separate ebuild to tmglib
	sed -i \
		-e '/lapack_install_library(tmglib)/d' \
		TESTING/MATGEN/CMakeLists.txt || die
	# if xblas is used add it in the .pc file
	if use xblas ; then
		sed -i \
			-e '/Requires/s:blas:blas xblas:' \
			lapack.pc.in || die
	fi
}

src_configure() {
	local MULTIBUILD_VARIANTS=( $(int64_multilib_get_enabled_abis) )
	my_src_configure() {
		local profname=$(get_profname)
		local libname="${profname//-/_}"
		local blas_profname=$(get_blas_profname)
		local mycmakeargs=(
			-DPROFNAME="${profname}"
			-DBLAS_PROFNAME="${blas_profname}"
			-DLIBNAME="${libname}"
			-DUSE_OPTIMIZED_BLAS=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs ${blas_profname})"
			$(cmake-utils_use_build test TESTING)
			$(cmake-utils_use_use xblas XBLAS)
			$@
		)
		if [[ "${MULTIBUILD_ID}" =~ "_${INT64_SUFFIX}" ]]; then
			mycmakeargs+=(
				-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) $(get_abi_CFLAGS) -fdefault-integer-8"
				-DLAPACK_PKGCONFIG_FFLAGS="-fdefault-integer-8"
			)
		else
			mycmakeargs+=(
				-DCMAKE_Fortran_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) $(get_abi_CFLAGS)"
				-DLAPACK_PKGCONFIG_FFLAGS=""
			)
		fi
		if [[ "${MULTIBUILD_ID}" =~ "_${STATIC_SUFFIX}" ]]; then
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
		mycmakeargs+=(
			-DCMAKE_C_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) ${CFLAGS}"
			-DCMAKE_CXX_FLAGS="$($(tc-getPKG_CONFIG) --cflags ${blas_profname}) ${CXXFLAGS}"
		)
		cmake-utils_src_configure
	}
	multibuild_foreach_variant _int64_multilib_multibuild_wrapper my_src_configure
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(int64_multilib_get_enabled_abis) )
	multibuild_foreach_variant _int64_multilib_multibuild_wrapper cmake-utils_src_compile
}

src_test() {
	local MULTIBUILD_VARIANTS=( $(int64_multilib_get_enabled_abis) )
	multibuild_foreach_variant _int64_multilib_multibuild_wrapper cmake-utils_src_test
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(int64_multilib_get_enabled_abis) )
	my_src_install()  {
		cmake-utils_src_install
		if [[ ! "${MULTIBUILD_ID}" =~ "_${STATIC_SUFFIX}" ]]; then
			local profname=$(get_profname)
			alternatives_for $(get_lapack_module) $(get_profname "reference") 0 \
				/usr/$(get_libdir)/pkgconfig/$(get_lapack_module).pc ${profname}.pc
		fi
	}
	multibuild_foreach_variant _int64_multilib_multibuild_wrapper my_src_install
}
