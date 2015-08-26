# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: fortran-int64.eclass
# @MAINTAINER:
# sci team <sci@gentoo.org>
# @AUTHOR:
# Author: Mark Wright <gienah@gentoo.org>
# @BLURB: flags and utility functions for building Fortran multilib int64
# multibuild packages
# @DESCRIPTION:
# The fortran-int64.eclass exports USE flags and utility functions
# necessary to build packages for multilib int64 multibuild in a clean
# and uniform manner.

if [[ ! ${_FORTRAN_INT64_ECLASS} ]]; then

# EAPI=4 is required for meaningful MULTILIB_USEDEP.
case ${EAPI:-0} in
	4|5) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit multilib-build toolchain-funcs

# @ECLASS-VARIABLE: EBASE_PROFNAME
# @DESCRIPTION: The base pkg-config module name of the package being built.
# EBASE_PROFNAME is used by the fortran-int64_get_profname function to
# determine the pkg-config module name based on whether the package
# has dynamic, threads or openmp USE flags and if so, if the user has
# turned them or, and if the current multibuild is a int64 build or not.
# @CODE
# EBASE_PROFNAME="openblas"
# inherit ... fortran-int64
# @CODE
: ${EBASE_PROFNAME:=blas}

# @ECLASS-VARIABLE: ESTATIC_MULTIBUILD
# @DEFAULT_UNSET
# @DESCRIPTION:
# If this is set, then do separate static multibuilds.
# @CODE
# ESTATIC_MULTIBUILD=1
# inherit ... fortran-int64
# @CODE

INT64_SUFFIX="int64"
STATIC_SUFFIX="static"

# @FUNCTION: fortran-int64_is_int64_build
# @DESCRIPTION:
# Returns shell true if the current multibuild is a int64 build,
# else returns shell false.
# @CODE
#	$(fortran-int64_is_int64_build) && \
#		openblas_abi_cflags+=" -DOPENBLAS_USE64BITINT"
# @CODE
fortran-int64_is_int64_build() {
	debug-print-function ${FUNCNAME} "${@}"
	if [[ "${MULTIBUILD_ID}" =~ "_${INT64_SUFFIX}" ]]; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: fortran-int64_is_static_build
# @DESCRIPTION:
# Returns shell true if ESTATIC_MULTIBUILD is true and the current multibuild
# is a static build, else returns shell false.
# @CODE
#	if $(fortran-int64_is_static_build); then
#		...
# @CODE
fortran-int64_is_static_build() {
	debug-print-function ${FUNCNAME} "${@}"
	if [[ "${MULTIBUILD_ID}" =~ "_${STATIC_SUFFIX}" ]]; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: fortran-int64_get_profname
# @USAGE: [<profname>]
# @DESCRIPTION: Return the pkgbuild profile name, without the .pc extension,
# for the current fortran int64 build.  If the current build is not an int64
# build, and the ebuild does not have dynamic, threads or openmp USE flags or
# they are disabled, then the profname is ${EBASE_PROFNAME} or <profname> if
# <profname> is specified.
#
# Takes an optional <profname> parameter.  If no <profname> is specified, uses
# ${EBASE_PROFNAME} as the base to calculate the profname for the current
# build.
fortran-int64_get_profname() {
	debug-print-function ${FUNCNAME} "${@}"
	local profname="${1:-${EBASE_PROFNAME}}"
	if has dynamic ${IUSE} && use dynamic; then
		profname+="-dynamic"
	fi
	if $(fortran-int64_is_int64_build); then
		profname+="-${INT64_SUFFIX}"
	fi
	# choose posix threads over openmp when the two are set
	# yet to see the need of having the two profiles simultaneously
	if has threads ${IUSE} && use threads; then
		profname+="-threads"
	elif has openmp ${IUSE} && use openmp; then
		profname+="-openmp"
	fi
	echo "${profname}"
}

# @FUNCTION: fortran-int64_get_blas_provider
# @DESCRIPTION: Returns the eselect blas provider for the current build.
# Which is blas-int64 if called from an int64 build, or blas otherwise.
# @CODE
#	local profname=$(fortran-int64_get_profname)
#	local provider=$(fortran-int64_get_blas_provider)
#	alternatives_for ${provider} $(fortran-int64_get_profname "reference") 0 \
#		/usr/$(get_libdir)/pkgconfig/${provider}.pc ${profname}.pc
# @CODE
fortran-int64_get_blas_provider() {
	debug-print-function ${FUNCNAME} "${@}"
	local provider_name="blas"
	if $(fortran-int64_is_int64_build); then
		provider_name+="-${INT64_SUFFIX}"
	fi
	echo "${provider_name}"
}

# @FUNCTION: fortran-int64_get_cblas_provider
# @DESCRIPTION: Returns the eselect cblas provider for the current build.
# Which is cblas-int64 if called from an int64 build, or cblas otherwise.
# @CODE
#	local profname=$(fortran-int64_get_profname)
#	local provider=$(fortran-int64_get_cblas_provider)
#	alternatives_for ${provider} $(fortran-int64_get_profname "reference") 0 \
#		/usr/$(get_libdir)/pkgconfig/${provider}.pc ${profname}.pc
# @CODE
fortran-int64_get_cblas_provider() {
	debug-print-function ${FUNCNAME} "${@}"
	local provider_name="cblas"
	if $(fortran-int64_is_int64_build); then
		provider_name+="-${INT64_SUFFIX}"
	fi
	echo "${provider_name}"
}

# @FUNCTION: fortran-int64_get_lapack_provider
# @DESCRIPTION: Returns the eselect lapack provider for the current build.
# Which is lapack-int64 if called from an int64 build, or lapack otherwise.
# @CODE
#	local profname=$(fortran-int64_get_profname)
#	local provider=$(fortran-int64_get_lapack_provider)
#	alternatives_for ${provider} $(fortran-int64_get_profname "reference") 0 \
#		/usr/$(get_libdir)/pkgconfig/${provider}.pc ${profname}.pc
# @CODE
fortran-int64_get_lapack_provider() {
	debug-print-function ${FUNCNAME} "${@}"
	local provider_name="lapack"
	if $(fortran-int64_is_int64_build); then
		provider_name+="-${INT64_SUFFIX}"
	fi
	echo "${provider_name}"
}

# @FUNCTION: fortran-int64_get_blas_profname
# @DESCRIPTION: Returns the pkg-config file name, without the .pc extension,
# for the currently selected blas-int64 module if we are performing an int64
# build, or the currently selected blas module otherwise.
# @CODE
#	cat <<-EOF > ${profname}.pc
#		...
#		Requires: $(fortran-int64_get_blas_profname)
#		...
# @CODE
fortran-int64_get_blas_profname() {
	debug-print-function ${FUNCNAME} "${@}"
	local blas_provider=$(fortran-int64_get_blas_provider)
	local blas_symlinks=( $(eselect "${blas_provider}" files) )
	local blas_prof_symlink="$(readlink -f "${blas_symlinks[0]}")"
	local blas_prof_file="${blas_prof_symlink##*/}"
	echo "${blas_prof_file%.pc}"
}

# @FUNCTION: fortran-int64_get_xblas_profname
# @DESCRIPTION: Returns the xblas pkg-config file name, without the .pc extension,
# for the current build.  Which is xblas-int64 if we are performing an int64
# build, or xblas otherwise.
# @CODE
#	cat <<-EOF > ${profname}.pc
#		...
#		Requires: $(fortran-int64_get_xblas_profname)
#		...
# @CODE
fortran-int64_get_xblas_profname() {
	debug-print-function ${FUNCNAME} "${@}"
	local xblas_provider="xblas"
	if $(fortran-int64_is_int64_build); then
		xblas_provider+="-${INT64_SUFFIX}"
	fi
	echo "${xblas_provider}"
}

# @FUNCTION: fortran-int64_get_fortran_int64_abi_fflags
# @DESCRIPTION: Return the Fortran compiler flag to enable 64 bit integers for
# array indices if we are performing an int64 build, or the empty string
# otherwise.
# @CODE
# src_configure() {
#	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
#	my_configure() {
#		export FCFLAGS="${FCFLAGS} $(get_abi_CFLAGS) $(fortran-int64_get_fortran_int64_abi_fflags)"
#		econf $(use_enable fortran)
#	}
#	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_configure
# }
# @CODE
fortran-int64_get_fortran_int64_abi_fflags() {
	debug-print-function ${FUNCNAME} "${@}"
	local openblas_abi_fflags=""
	if $(fortran-int64_is_int64_build); then
		openblas_abi_fflags+="-fdefault-integer-8"
	fi
	echo "${openblas_abi_fflags}"
}

# @FUNCTION: fortran-int64_multilib_get_enabled_abis
# @DESCRIPTION: Returns the array of multilib int64 and optionally static
# build combinations.  Each ebuild function that requires multibuild
# functionalits needs to set the MULTIBUILD_VARIANTS variable to the
# array returned by this function.
# @CODE
# src_prepare() {
#	local MULTIBUILD_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
#	multibuild_copy_sources
# }
# @CODE
fortran-int64_multilib_get_enabled_abis() {
	debug-print-function ${FUNCNAME} "${@}"
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
	if [[ -n ${ESTATIC_MULTIBUILD} ]]; then
		local j
		for j in "${MULTILIB_INT64_VARIANTS[@]}"; do
			use static-libs && MULTIBUILD_VARIANTS+=( "${j}_${STATIC_SUFFIX}" )
			MULTIBUILD_VARIANTS+=( "${j}" )
		done
	else
		MULTIBUILD_VARIANTS="${MULTILIB_INT64_VARIANTS[@]}"
	fi
	echo "${MULTIBUILD_VARIANTS[@]}"
}

# @FUNCTION: fortran-int64_ensure_blas
# @DESCRIPTION: Check the blas pkg-config files are available for the currently
# selected blas module, and for the currently select blas-int64 module if the
# int64 USE flag is enabled.
# @CODE
# src_prepare() {
#	fortran-int64_ensure_blas
#	...
# @CODE
fortran-int64_ensure_blas() {
	local MULTILIB_INT64_VARIANTS=( $(fortran-int64_multilib_get_enabled_abis) )
	local MULTIBUILD_ID
	for MULTIBUILD_ID in "${MULTILIB_INT64_VARIANTS[@]}"; do
		local blas_profname=$(fortran-int64_get_blas_profname)
		$(tc-getPKG_CONFIG) --exists "${blas_profname}" \
			|| die "${PN} requires the pkgbuild module ${blas_profname}"
	done
}

# @FUNCTION: fortran-int64_multilib_multibuild_wrapper
# @USAGE: <argv>...
# @DESCRIPTION:
# Initialize the environment for ABI selected for multibuild.
# @CODE
#	multibuild_foreach_variant run_in_build_dir fortran-int64_multilib_multibuild_wrapper my_src_install
# @CODE
fortran-int64_multilib_multibuild_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"
	local v="${MULTIBUILD_VARIANT/_${INT64_SUFFIX}/}"
	local ABI="${v/_${STATIC_SUFFIX}/}"
	multilib_toolchain_setup "${ABI}"
	"${@}"
}

_FORTRAN_INT64_ECLASS=1
fi
