# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: numeric-int64-multilib.eclass
# @MAINTAINER:
# sci team <sci@gentoo.org>
# @AUTHOR:
# Author: Mark Wright <gienah@gentoo.org>
# Author: Justin Lecher <jlec@gentoo.org>
# @BLURB: Build functions for Fortran multilib int64 multibuild packages
# @DESCRIPTION:
# The numeric-int64-multilib.eclass exports USE flags and utility functions
# necessary to build packages for multilib int64 multibuild in a clean
# and uniform manner.

if [[ ! ${_NUMERIC_INT64_MULTILIB_ECLASS} ]]; then

# EAPI=5 is required for meaningful MULTILIB_USEDEP.
case ${EAPI:-0} in
	5)
		inherit multilib ;;
	6) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit alternatives-2 eutils fortran-2 multilib-build numeric toolchain-funcs

IUSE="int64"

# @ECLASS-VARIABLE: NUMERIC_INT32_SUFFIX
# @INTERNAL
# @DESCRIPTION:
# MULTIBUILD_ID suffix for int32 build
NUMERIC_INT32_SUFFIX="int32"

# @ECLASS-VARIABLE: NUMERIC_INT64_SUFFIX
# @INTERNAL
# @DESCRIPTION:
# MULTIBUILD_ID suffix for int64 build
NUMERIC_INT64_SUFFIX="int64"

# @ECLASS-VARIABLE: NUMERIC_STATIC_SUFFIX
# @INTERNAL
# @DESCRIPTION:
# MULTIBUILD_ID suffix for static build
NUMERIC_STATIC_SUFFIX="static"

# @FUNCTION: numeric-int64_is_int64_build
# @DESCRIPTION:
# Returns shell true if the current multibuild is a int64 build,
# else returns shell false.
#
# Example:
#
# @CODE
#	$(numeric-int64_is_int64_build) && \
#		openblas_abi_cflags+=" -DOPENBLAS_USE64BITINT"
# @CODE
numeric-int64_is_int64_build() {
	debug-print-function ${FUNCNAME} "${@}"
	if [[ "${MULTIBUILD_ID}" =~ "${NUMERIC_INT64_SUFFIX}" ]]; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: numeric-int64_is_static_build
# @DESCRIPTION:
# Returns shell true if current multibuild is a static build,
# else returns shell false.
#
# Example:
#
# @CODE
#	if $(numeric-int64_is_static_build); then
#		dolib.a lib*a
#	fi
# @CODE
numeric-int64_is_static_build() {
	debug-print-function ${FUNCNAME} "${@}"
	if [[ "${MULTIBUILD_ID}" =~ "${NUMERIC_STATIC_SUFFIX}" ]]; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: numeric-int64_get_module_name
# @USAGE: [<module_name>]
# @DESCRIPTION:
# Return the numeric module name, without the .pc extension,
# for the current fortran int64 build.  If the current build is not an int64
# build, and the ebuild does not have dynamic, threads or openmp USE flags or
# they are disabled, then the module_name is ${NUMERIC_MODULE_NAME} or
# <module_name> if <module_name> is specified.
#
# Takes an optional <module_name> parameter.  If no <module_name> is specified,
# uses ${NUMERIC_MODULE_NAME} as the base to calculate the module_name for the
# current build.
#
# Example:
#
# @CODE
#	NUMERIC_MODULE_NAME=blas
#	profname=$(numeric-int64_get_module_name)
#
#	int32 build:
#	-> profname == blas
#
#	int64 build:
#	-> profname == blas-int64
# @CODE
numeric-int64_get_module_name() {
	debug-print-function ${FUNCNAME} "${@}"
	local module_name="${1:-${NUMERIC_MODULE_NAME}}"
	if has dynamic ${IUSE} && use dynamic; then
		module_name+="-dynamic"
	fi
	if $(numeric-int64_is_int64_build); then
		module_name+="-${NUMERIC_INT64_SUFFIX}"
	fi
	# choose posix threads over openmp when the two are set
	# yet to see the need of having the two profiles simultaneously
	if use_if_iuse threads; then
		module_name+="-threads"
	elif use_if_iuse openmp; then
		module_name+="-openmp"
	fi
	echo "${module_name}"
}

# @FUNCTION: _numeric-int64_get_numeric_alternative
# @INTERNAL
_numeric-int64_get_numeric_alternative() {
	debug-print-function ${FUNCNAME} "${@}"
	local alternative_name="${1}"
	if $(numeric-int64_is_int64_build); then
		alternative_name+="-${NUMERIC_INT64_SUFFIX}"
	fi
	echo "${alternative_name}"
}

# @FUNCTION: numeric-int64_get_blas_alternative
# @DESCRIPTION:
# Returns the eselect blas alternative for the current
# int build type. Which is blas-int64 if called from an int64 build,
# or blas otherwise.
numeric-int64_get_blas_alternative() {
	debug-print-function ${FUNCNAME} "${@}"
	_numeric-int64_get_numeric_alternative blas
}

# @FUNCTION: numeric-int64_get_cblas_alternative
# @DESCRIPTION:
# Returns the eselect cblas alternative for the current
# int build type. Which is cblas-int64 if called from an int64 build,
# or cblas otherwise.
numeric-int64_get_cblas_alternative() {
	debug-print-function ${FUNCNAME} "${@}"
	_numeric-int64_get_numeric_alternative cblas
}

# @FUNCTION: numeric-int64_get_xblas_alternative
# @DESCRIPTION:
# Returns the eselect xblas alternative for the current
# int build type. Which is xblas-int64 if called from an int64 build,
# or xblas otherwise.
numeric-int64_get_xblas_alternative() {
	debug-print-function ${FUNCNAME} "${@}"
	_numeric-int64_get_numeric_alternative xblas
}

# @FUNCTION: numeric-int64_get_lapack_alternative
# @DESCRIPTION:
# Returns the eselect lapack alternative for the current
# int build type. Which is lapack-int64 if called from an int64 build,
# or lapack otherwise.
numeric-int64_get_lapack_alternative() {
	debug-print-function ${FUNCNAME} "${@}"
	_numeric-int64_get_numeric_alternative lapack
}

# @FUNCTION: numeric-int64_get_blas_module_name
# @DESCRIPTION:
# Returns the pkg-config file name, without the .pc extension,
# for the currently selected blas-int64 module if we are performing an int64
# build, or the currently selected blas module otherwise.
numeric-int64_get_blas_module_name() {
	debug-print-function ${FUNCNAME} "${@}"
	local blas_alternative=$(numeric-int64_get_blas_alternative)
	local blas_symlinks=( $(eselect "${blas_alternative}" files) )
	local blas_prof_symlink="$(readlink -f ${blas_symlinks[0]})"
	local blas_prof_file="${blas_prof_symlink##*/}"
	echo "${blas_prof_file%.pc}"
}

# @FUNCTION: numeric-int64_get_xblas_module_name
# @DESCRIPTION:
# Returns the xblas pkg-config file name,
# without the .pc extension, for the current build. Which is xblas-int64 if
# we are performing an int64 build, or xblas otherwise.
numeric-int64_get_xblas_module_name() {
	debug-print-function ${FUNCNAME} "${@}"
	local xblas_provider="xblas"
	if $(numeric-int64_is_int64_build); then
		xblas_provider+="-${INT64_SUFFIX}"
	fi
	echo "${xblas_provider}"
}

# @FUNCTION: numeric-int64_get_fortran_int64_abi_fflags
# @DESCRIPTION:
# Return the Fortran compiler flag to enable 64 bit integers for
# array indices if we are performing an int64 build, or the empty string
# otherwise.
#
# Example:
#
# @CODE
# src_configure() {
#	my_configure() {
#		export FCFLAGS="${FCFLAGS} $(get_abi_CFLAGS) $(numeric-int64_get_fortran_int64_abi_fflags)"
#		econf $(use_enable fortran)
#	}
#	numeric-int64-multibuild_foreach_all_abi_variants run_in_build_dir my_configure
# }
# @CODE
numeric-int64_get_fortran_int64_abi_fflags() {
	debug-print-function ${FUNCNAME} "${@}"
	$(numeric-int64_is_int64_build) && echo "$(fortran_int64_abi_fflags)"
}

# @FUNCTION: numeric-int64_get_multibuild_int_variants
# @DESCRIPTION:
# Returns the array of int64 and int32
# multibuild combinations.
numeric-int64_get_multibuild_int_variants() {
	debug-print-function ${FUNCNAME} "${@}"
	local MULTIBUILD_VARIANTS=( int32 ) variant

	use_if_iuse int64 && MULTIBUILD_VARIANTS+=( int64 )

	echo "${MULTIBUILD_VARIANTS[@]}"
}

# @FUNCTION: numeric-int64_get_multibuild_variants
# @DESCRIPTION:
# Returns the array of int64, int32 and static
# multibuild combinations.
numeric-int64_get_multibuild_variants() {
	debug-print-function ${FUNCNAME} "${@}"
	local MULTIBUILD_VARIANTS=$(numeric-int64_get_multibuild_int_variants)
	if use_if_iuse static-libs; then
		for variant in ${MULTIBUILD_VARIANTS[@]}; do
			MULTIBUILD_VARIANTS+=( static_${variant} )
		done
	fi
	echo "${MULTIBUILD_VARIANTS[@]}"
}

# @FUNCTION: numeric-int64_get_all_abi_variants
# @DESCRIPTION:
# Returns the array of int64, int32 and static build combinations
# combined with all multilib ABI variants.
numeric-int64_get_all_abi_variants() {
	debug-print-function ${FUNCNAME} "${@}"
	local abi ret=() variant

	for abi in $(multilib_get_enabled_abis); do
		for variant in $(numeric-int64_get_multibuild_variants); do
			if [[ ${variant} =~ int64 ]]; then
				[[ ${abi} =~ amd64 ]] && ret+=( ${abi}_${variant} )
			else
				ret+=( ${abi}_${variant} )
			fi
		done
	done
	echo "${ret[@]}"
}

# @FUNCTION: numeric-int64_ensure_blas_int_support
# @DESCRIPTION:
# Check the blas supports the necessary int types in the currently
# selected blas module.
#
# Example:
#
# @CODE
# src_prepare() {
#	numeric-int64_ensure_blas_int_support
#	...
# @CODE
numeric-int64_ensure_blas_int_support() {
	local MULTILIB_INT64_VARIANTS=( $(numeric-int64_get_multibuild_variants) )
	local MULTIBUILD_ID
	for MULTIBUILD_ID in "${MULTILIB_INT64_VARIANTS[@]}"; do
		local blas_module_name=$(numeric-int64_get_blas_module_name)
		$(tc-getPKG_CONFIG) --exists "${blas_module_name}" \
			|| die "${PN} requires the pkgbuild module ${blas_module_name}"
	done
}

# @FUNCTION: numeric-int64-multibuild_install_alternative
# @USAGE: <alternative name> <provider name> [extra files sources] [extra files dest]
# @DESCRIPTION:
# Install alternatives pc file and extra files for all providers for all multilib ABIs.
numeric-int64-multibuild_install_alternative() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ $# -lt 2 ]] && die "${FUNCNAME} needs at least two arguments"
	pc_file()  {
		debug-print-function ${FUNCNAME} "${@}"
		numeric-int64_is_static_build && return
		local alternative=$(_numeric-int64_get_numeric_alternative "$1")
		local module_name=$(numeric-int64_get_module_name)
		printf \
			"/usr/$(get_libdir)/pkgconfig/${alternative}.pc ${module_name}.pc " \
			>> "${T}"/alternative-${alternative}.sh || die
	}
	pc_install() {
		debug-print-function ${FUNCNAME} "${@}"
		numeric-int64_is_static_build && return
		local alternative=$(_numeric-int64_get_numeric_alternative "$1")
		local module_name=$(numeric-int64_get_module_name $2)
		shift 2
		alternatives_for \
			${alternative} ${module_name} 0 \
			$(cat "${T}"/alternative-${alternative}.sh) ${@}
		rm "${T}"/alternative-${alternative}.sh || die
	}
	numeric-int64-multibuild_foreach_all_abi_variants pc_file ${@}
	numeric-int64-multibuild_foreach_int_abi pc_install ${@}
}

# @FUNCTION: numeric-int64-multibuild_multilib_wrapper
# @USAGE: <argv>...
# @DESCRIPTION:
# Initialize the environment for ABI selected for multibuild.
#
# Example:
#
# @CODE
# 	multibuild_foreach_variant run_in_build_dir \
# 		numeric-int64-multibuild_multilib_wrapper my_src_install
# @CODE
numeric-int64-multibuild_multilib_wrapper() {
	debug-print-function ${FUNCNAME} "${@}"
	local v="${MULTIBUILD_VARIANT/_${NUMERIC_INT32_SUFFIX}/}"
	local v="${v/_${NUMERIC_INT64_SUFFIX}/}"
	local ABI="${v/_${NUMERIC_STATIC_SUFFIX}/}"
	multilib_toolchain_setup "${ABI}"
	"${@}" || die
}

# @FUNCTION: numeric-int64-multibuild_foreach_int_abi
# @USAGE: <argv> ...
# @DESCRIPTION:
# Run command for each enabled numeric variant (e.g. int32, int64)
numeric-int64-multibuild_foreach_int_abi() {
	debug-print-function ${FUNCNAME} "${@}"
	local MULTIBUILD_VARIANTS=( $(numeric-int64_get_multibuild_int_variants) )
	multibuild_foreach_variant numeric-int64-multibuild_multilib_wrapper "${@}"
}

# @FUNCTION: numeric-int64-multibuild_foreach_variant
# @USAGE: <argv> ...
# @DESCRIPTION:
# Run command for each enabled numeric abi and static-libs (e.g. int32, int64, static)
numeric-int64-multibuild_foreach_variant() {
	debug-print-function ${FUNCNAME} "${@}"
	local MULTIBUILD_VARIANTS=( $(numeric-int64_get_multibuild_variants) )
	multibuild_foreach_variant numeric-int64-multibuild_multilib_wrapper "${@}"
}

# @FUNCTION: numeric-int64-multibuild_foreach_all_abi_variants
# @USAGE: <argv> ...
# @DESCRIPTION:
# Run command for each enabled numeric variant (e.g. int32, int64, static) _AND_
# enabled multilib ABI
numeric-int64-multibuild_foreach_all_abi_variants() {
	debug-print-function ${FUNCNAME} "${@}"
	local MULTIBUILD_VARIANTS=( $(numeric-int64_get_all_abi_variants) )
	multibuild_foreach_variant numeric-int64-multibuild_multilib_wrapper "${@}"
}

# @FUNCTION: numeric-int64-multibuild_copy_sources
# @DESCRIPTION:
# Thin wrapper around multibuild_copy_sources()
numeric-int64-multibuild_copy_sources() {
	debug-print-function ${FUNCNAME} "${@}"
	local MULTIBUILD_VARIANTS=( $(numeric-int64_get_all_abi_variants) )
	multibuild_copy_sources
}

_NUMERIC_INT64_MULTILIB_ECLASS=1
fi
