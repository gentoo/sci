# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EBASE_PROFNAME="openblas"
inherit alternatives-2 eutils multilib fortran-2 multibuild multilib-build toolchain-funcs fortran-int64

SRC_URI+="http://dev.gentoo.org/~gienah/distfiles/${PN}-0.2.11-gentoo.patch"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/xianyi/OpenBLAS.git"
	EGIT_BRANCH="develop"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI+=" http://github.com/xianyi/OpenBLAS/tarball/v${PV} -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos ~ppc-macos ~x64-macos"
fi

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
LICENSE="BSD"
SLOT="0"
IUSE="dynamic int64 openmp static-libs threads"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="
	>=virtual/blas-2.1-r2[int64?]
	>=virtual/cblas-2.0-r1[int64?]"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/openblas/cblas.h
	/usr/include/openblas/f77blas.h
	/usr/include/openblas/openblas_config.h
)

get_openblas_flags() {
	local openblas_flags=""
	use dynamic && \
		openblas_flags+=" DYNAMIC_ARCH=1 TARGET=GENERIC NUM_THREADS=64 NO_AFFINITY=1"
	$(fortran-int64_is_int64_build) && \
		openblas_flags+=" INTERFACE64=1"
	# choose posix threads over openmp when the two are set
	# yet to see the need of having the two profiles simultaneously
	if use threads; then
		openblas_flags+=" USE_THREAD=1 USE_OPENMP=0"
	elif use openmp; then
		openblas_flags+=" USE_THREAD=0 USE_OPENMP=1"
	fi
	local profname=$(fortran-int64_get_profname)
	local libname="${profname//-/_}"
	local underscoresuffix="${libname#${PN}}"
	if [[ "${underscoresuffix}" != "_" ]]; then
		local libnamesuffix="${underscoresuffix#_}"
		openblas_flags+=" LIBNAMESUFFIX=${libnamesuffix}"
	fi
	echo "${openblas_flags}"
}

get_openblas_abi_cflags() {
	local openblas_abi_cflags=""
	if [[ "${ABI}" == "x86" ]]; then
		openblas_abi_cflags="-DOPENBLAS_ARCH_X86=1 -DOPENBLAS___32BIT__=1"
	else
		openblas_abi_cflags="-DOPENBLAS_ARCH_X86_64=1 -DOPENBLAS___64BIT__=1"
	fi
	$(fortran-int64_is_int64_build) && \
		openblas_abi_cflags+=" -DOPENBLAS_USE64BITINT"
	echo "${openblas_abi_cflags}"
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
	else
		default
		if [[ ${PV} != "9999" ]] ; then
			find "${WORKDIR}" -maxdepth 1 -type d -name \*OpenBLAS\* && \
				mv "${WORKDIR}"/*OpenBLAS* "${S}"
		fi
	fi
}

src_prepare() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	epatch "${DISTDIR}/${PN}-0.2.11-gentoo.patch"
	if [[ ${PV} == "0.2.11" ]] ; then
		epatch "${FILESDIR}/${PN}-0.2.11-cpuid_x86.patch"
	fi
	# lapack and lapacke are not modified from upstream lapack
	sed \
		-e "s:^#\s*\(NO_LAPACK\)\s*=.*:\1=1:" \
		-e "s:^#\s*\(NO_LAPACKE\)\s*=.*:\1=1:" \
		-i Makefile.rule || die
	multibuild_copy_sources
}

src_configure() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_configure() {
		local openblas_abi_cflags="$(get_openblas_abi_cflags)"
		local internal_openblas_abi_cflags="${openblas_abi_cflags//OPENBLAS_}"
		sed \
			-e "s:^#\s*\(CC\)\s*=.*:\1=$(tc-getCC) $(get_abi_CFLAGS):" \
			-e "s:^#\s*\(FC\)\s*=.*:\1=$(tc-getFC) $(get_abi_CFLAGS):" \
			-e "s:^#\s*\(COMMON_OPT\)\s*=.*:\1=${CFLAGS} ${internal_openblas_abi_cflags}:" \
			-i Makefile.rule || die
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_configure
}

src_compile() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	# openblas already does multi-jobs
	MAKEOPTS+=" -j1"
	my_src_compile () {
		local openblas_flags=$(get_openblas_flags)
		local profname=$(fortran-int64_get_profname)
		local libname="${profname//-/_}"
		einfo "Compiling profile ${profname}"
		# cflags already defined twice
		unset CFLAGS
		emake clean
		emake libs shared ${openblas_flags}
		mkdir -p libs && mv libopenblas* libs/
		# avoid pic when compiling static libraries, so re-compiling
		if use static-libs; then
			emake clean
			emake libs ${openblas_flags} NO_SHARED=1 NEED_PIC=
			mv libopenblas* libs/
		fi
		# Fix Bug 524612 - [science overlay] sci-libs/openblas-0.2.11 - Assembler messages:
		# ../kernel/x86_64/gemm_kernel_8x4_barcelona.S:451: Error: missing ')'
		# The problem is applying this patch in src_prepare() causes build failures on
		# assembler code as the assembler does not understand sizeof(float).  So
		# delay applying the patch until after building the libraries.
		epatch "${FILESDIR}/${PN}-0.2.11-openblas_config_header_same_between_ABIs.patch"
		rm -f config.h config_last.h
		# Note: prints this spurious warning: make: Nothing to be done for 'config.h'.
		emake config.h
		cp config.h config_last.h || die
		cat <<-EOF > ${profname}.pc
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include
			Name: ${profname}
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -l${libname}
			Libs.private: -lm
		EOF
		local openblas_abi_cflags=$(get_openblas_abi_cflags)
		local openblas_abi_fflags=$(fortran-int64_get_fortran_int64_abi_fflags)
		cat <<-EOF >> ${profname}.pc
			Cflags: -I\${includedir}/${PN} ${openblas_abi_cflags}
			Fflags=${openblas_abi_fflags}
		EOF
		mv libs/libopenblas* . || die
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_compile
}

src_test() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_test () {
		local openblas_flags=$(get_openblas_flags)
		emake tests ${openblas_flags}
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_test
}

src_install() {
	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	my_src_install() {
		local openblas_flags=$(get_openblas_flags)
		local profname=$(fortran-int64_get_profname)
		local pcfile
		for pcfile in *.pc; do
			local profname=${pcfile%.pc}
			# The file /usr/include/openblas/openblas_config.h is generated during the install.
			# The sed on config_last.h removes the #define's OPENBLAS_USE64BITINT
			# OPENBLASS__32BIT__ OPENBLASS__64BIT__ OPENBLAS__ARCH_X86 OPENBLAS__ARCH_X86_64
			# from /usr/include/openblas/openblas_config.h.  We then specify it in Cflags in
			# the /usr/lib64/pkg-config/openblas-int64-{threads,openmp}.pc file.
			sed -e '/#define USE64BITINT/d' \
				-e '/#define ARCH_X86/d' \
				-e '/#define __\(32\|64\)BIT__/d' \
				-i config_last.h \
				|| die "Could not ensure there is no definition of USE64BITINT in config_last.h"
			emake install \
				PREFIX="${ED}"usr ${openblas_flags} \
				OPENBLAS_INCLUDE_DIR="${ED}"usr/include/${PN} \
				OPENBLAS_LIBRARY_DIR="${ED}"usr/$(get_libdir)
			use static-libs || rm "${ED}"usr/$(get_libdir)/lib*.a
			alternatives_for $(fortran-int64_get_blas_provider) ${profname} 0 \
				/usr/$(get_libdir)/pkgconfig/$(fortran-int64_get_blas_provider).pc ${pcfile}
			alternatives_for $(fortran-int64_get_cblas_provider) ${profname} 0 \
				/usr/$(get_libdir)/pkgconfig/$(fortran-int64_get_cblas_provider).pc ${pcfile} \
				/usr/include/cblas.h ${PN}/cblas.h
			insinto /usr/$(get_libdir)/pkgconfig
			doins ${pcfile}
		done

		if [[ ${CHOST} == *-darwin* ]] ; then
			cd "${ED}"/usr/$(get_libdir)
			local d
			for d in *.dylib ; do
				ebegin "Correcting install_name of ${d}"
				install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/${d}" "${d}"
				eend $?
			done
		fi
		if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
			multilib_prepare_wrappers
			multilib_check_headers
		fi
	}
	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_install
	multilib_install_wrappers

	dodoc GotoBLAS_{01Readme,03FAQ,04FAQ,05LargePage,06WeirdPerformance}.txt
	dodoc *md Changelog.txt
}
