# @ECLASS: blas.eclass
# @MAINTAINER:
# schmidom@student.ethz.ch
# @BLURB: Selects a proper BLAS implementation to build the package
# @DESCRIPTION:
# Here a BLAS-implementation is chosen from the cutset of available,
# compatible and implementations in the USE flags
# If inherited, it automatically adds the dependencies to the right
# implementation to RDEPEND and DEPEND, adds the USE flags corresponding
# to the compatible implementations to IUSE and adds a XOR constraint
# on the implementations to REQUIRED_USE to allow only a single implementation
# to be set.
# Additionally it provides a pkg_setup that does the actual heavy-lifting
# by forcing pkg-config to resolve the right parameters.

# @ECLASS-VARIABLE: BLAS_COMPAT
# @DESCRIPTION:
# This variable contains a list of BLAS implementations the package
# supports.
# It _must_ be set prior to inheriting the eclass.
# Its format has the following grammar:
# 
# @CODE
# COMPAT <- HEADER_SPECIFIER " " IMPLEMENTATIONS | IMPLEMENTATIONS
# HEADER_SPECIFIER <- "fortran:" | "c:"
# IMPLEMENTATIONS <- IMPLEMENTATION | IMPLEMENTATIONS " " IMPLEMENTATIONS
# IMPLEMENTATION <- [a-zA-Z_\-]+ | "*"
# @CODE
# 
# Since packages can depend on BLAS either in Fortran or in C, the package
# may add a header specifier in front of the compatibility-list, e.g.
# "c: <list>". By default, "fortran:" is assumed.
# 
# If a package is compatible with any BLAS implementation, "<list>" can
# be expressed with an asterisk ("*")
# 
# This variable defaults to "fortran: *"
#
# Example:
# @CODE
# BLAS_COMPAT=( c: refblas )
# @CODE
# This forces linking against sci-libs/cblas-reference

# @ECLASS-VARIABLE: BLAS_CONDITIONAL_FLAG
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable contains the USE-flag that selects whether the package
# should depend on BLAS or not.
# If non-empty, it gets prepended to REQUIRED_USE, DEPEND and RDEPEND.
# If it is an array, we will depend on BLAS when at least one of the 
# USE-flags is activated (logical OR)
#
# If, for example, set to
# @CODE
# BLAS_CONDITIONAL_FLAG="blas"
# @CODE
#
# Then the eclasses REQUIRED_USE and DEPENDs look like this:
# @CODE
# DEPEND="blas? ( blas_refblas? ( sci-libs/blas-reference ))"
# RDEPEND="${DEPEND}"
# REQUIRED_USE="blas? ( ^^ ( blas_refblas blas_openblas ) )"
# @CODE

# @ECLASS-VARIABLE: BLAS_REQ_USE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Adds a USE-flag requirement to every BLAS-implementation we depend on
# (mainly useful for multilib, since the implementations share nearly no
# other flags)
# This must be set before the call to inherit blas
#
# Example usage:
# @CODE
# BLAS_REQ_USE="int64"
# @CODE
# 
# Will result in DEPENDs like.
# @CODE
# DEPEND="blas_refblas? ( sci-libs/blas-reference[int64] )
# @CODE

BLAS_COMPAT="${BLAS_COMPAT:-fortran: *}"

# @ECLASS-VARIABLE: BLAS_IMPLS
# @INTERNAL
# @DESCRIPTION:
# A list of all available BLAS implementations providing fortran bindings
BLAS_IMPLS=(refblas openblas gotoblas mkl atlas eigen)

# @ECLASS-VARIABLE: CBLAS_IMPLS
# @INTERNAL
# @DESCRIPTION:
# A list of all available BLAS implementations providing C bindings
CBLAS_IMPLS=(refblas openblas gsl gotoblas mkl atlas)

# @ECLASS-VARIABLE: BLAS_SUPP_IMPLS
# @INTERNAL
# @DESCRIPTION:
# An ordered list of all the ebuild-supported implementations
# The order is the same as in BLAS_IMPLS
BLAS_SUPP_IMPLS=()

# @ECLASS-VARIABLE: BLAS_USE_CBLAS
# @INTERNAL
# @DESCRIPTION:
# Contains whether we depend on the C or the Fortran header.
BLAS_USE_CBLAS=false

# @ECLASS-VARIABLE: _blas_provider_*
# @INTERNAL
# @DESCRIPTION:
# Sets the package that provides the fortran bindings to the corresponding
# implementation
_blas_provider_refblas="sci-libs/blas-reference"
_blas_provider_openblas="sci-libs/openblas"
_blas_provider_gotoblas="sci-libs/gotoblas2"
_blas_provider_eigen="sci-libs/eigen[fortran]"
_blas_provider_atlas="sci-libs/atlas[fortran]"
_blas_provider_mkl="sci-libs/mkl"

# @ECLASS-VARIABLE: _cblas_provider_*
# @INTERNAL
# @DESCRIPTION:
# Sets the package that provides the fortran bindings to the corresponding
# implementation
_cblas_provider_refblas="sci-libs/cblas-reference"
_cblas_provider_openblas="sci-libs/openblas"
_cblas_provider_gotoblas="sci-libs/gotoblas2"
_cblas_provider_gsl="sci-libs/gsl[-cblas-external]"
_cblas_provider_mkl="sci-libs/mkl"
_cblas_provider_atlas="sci-libs/atlas"


# @ECLASS-VARIABLE: _blas_special_pkgconfig_*
# @INTERNAL
# @DESCRIPTION:
# An array of size two containing the base-names for the package-config
# files installed by the implementation. The first one is for the 
# Fortran-headers the second one for the C-headers
_blas_special_pkgconfig_refblas=(refblas refcblas)

# @FUNCTION:  _blas_impl_valid
# @INTERNAL
# @USAGE: <Implementation>
# @RETURN: Echos the pkgconfig-file for the given BLAS implementation
# @DESCRIPTION:
# Echos the pkgconfig-file for the given BLAS implementation
_blas_impl_get_pkgconfig() {
	local var
	eval "var=(\"\${_blas_special_pkgconfig_${1}[@]}\")"
	if [[ -z "${var[*]}" ]]; then
		echo "$1"
	fi
	
	if ${BLAS_USE_CBLAS}; then
		echo "${var[1]}"
	else
		echo "${var[0]}"
	fi
}

# @FUNCTION:  _blas_impl_valid
# @INTERNAL
# @USAGE: <Implementation>
# @RETURN: 0 if valid, 1 if invalid
# @DESCRIPTION:
# Checks whether the given implementation is in the set BLAS_IMPLS
_blas_impl_valid() {
	local impl
	local impls
	if ${BLAS_USE_CBLAS}; then
		impls=( "${CBLAS_IMPLS[@]}" )
	else
		impls=( "${BLAS_IMPLS[@]}" )
	fi
	for impl in "${impls[@]}"; do
		if [[ "$1" == "${impl}" ]]; then
			return 0
		fi
	done
	return 1
}

# @FUNCTION:  _blas_best_impl
# @INTERNAL
# @USAGE:
# @RETURN: Echos the name of the best allowed implementation
# @DESCRIPTION:
# This function returns the highest-ranked (as in BLAS_IMPLS) implementation
# whose use-flag is set (i.e. the "best" implementation)
_blas_best_impl() {
	local impl
	
	for impl in "${BLAS_SUPP_IMPLS[@]}"; do
		if use "$(_blas_useflag_by_impl ${impl})"; then
			echo ${impl}
			return
		fi
	done
	
	die "No matching implementation found"
}

# @FUNCTION:  _blas_useflag_by_impl
# @INTERNAL
# @USAGE: <Implementation> [Implementation,...]
# @RETURN: Echos the USE flag corresponding to the implementations
# @DESCRIPTION:
# This function echos the USE flag corresponding to the given implementation(s)
_blas_useflag_by_impl() {
	echo "${@/#/blas_}"
}

# @FUNCTION:  _blas_useflag_by_impl
# @INTERNAL
# @USAGE: <Implementation> [Implementation,...]
# @RETURN: Echos the USE flag corresponding to the implementations
# @DESCRIPTION:
# This function echos the USE flag corresponding to the given implementation(s)
_blas_get_depends() {
	local impl
	local blas
	local provider
	if ${BLAS_USE_CBLAS}; then
		blas="cblas"
	else
		blas="blas"
	fi
	for impl in "${BLAS_SUPP_IMPLS[@]}"; do
		eval "provider=\"\${_${blas}_provider_${impl}}\""
		if [[ ${BLAS_REQ_USE} ]]; then
			#Does the provider also have USE flag constraints?
			if [[ "${provider: -1}" == "]" ]]; then
				provider="${provider:0:-1},${BLAS_REQ_USE}]"
			else
				provider="${provider}[${BLAS_REQ_USE}]"
			fi
		fi
		
		echo "$(_blas_useflag_by_impl ${impl})? ( ${provider} )"
	done
}

_blas_set_globals() {
	local impl
	
	#Prevent shell-expansion by prepending a \ to ever *
	local blas_array=(${BLAS_COMPAT[*]//\*/\\*})
	
	case "${blas_array[0]}" in
		"c:")
			BLAS_USE_CBLAS=true
			blas_array=("${blas_array[@]:1}")
			;;
		"fortran:")
			blas_array=("${blas_array[@]:1}")
			;;
	esac
	
	for impl in "${blas_array[@]}"; do
		if [[ "${impl}" == '\*' ]]; then
			if ${BLAS_USE_CBLAS}; then
				BLAS_SUPP_IMPLS=( "${CBLAS_IMPLS[@]}" )
			else
				BLAS_SUPP_IMPLS=( "${BLAS_IMPLS[@]}" )
			fi
		elif _blas_impl_valid "${impl}"; then
			BLAS_SUPP_IMPLS+=( "${impl}" )
		else
			die "Unknown BLAS implementation ${impl}"
		fi
	done
	
	IUSE="${IUSE[@]} $(_blas_useflag_by_impl "${BLAS_SUPP_IMPLS[@]}")"
	
	BLAS_DEPS="$(_blas_get_depends)"
	RDEPEND=""
	REQUIRED_USE=""
	BLAS_REQUIRED_USE="^^ ( $(_blas_useflag_by_impl "${BLAS_SUPP_IMPLS[@]}") )"
	if [[ ${BLAS_CONDITIONAL_FLAG} ]]; then
		for flag in "${BLAS_CONDITIONAL_FLAG[@]}"; do
			RDEPEND="${RDEPEND} ${flag}? ( ${BLAS_DEPS} )"
			REQUIRED_USE="${REQUIRED_USE} ${flag}? ( ${BLAS_REQUIRED_USE} )"
		done
	else
		RDEPEND="${BLAS_DEPS}"
		REQUIRED_USE="${BLAS_REQUIRED_USE}"
	fi
	DEPEND="${RDEPEND}"
}

_blas_set_globals
unset -f _blas_set_globals


# @FUNCTION: blas_pkg_setup
# @USAGE:
# @DESCRIPTION:
# This function adds a temporary directory to the environment variable 
# PKG_CONFIG_PATH, and exports it.
# This directory contains a blas.pc (or cblas.pc, if BLAS_COMPAT specifies
# the C-headers), that is linked to the pkgconfig-file installed by the 
# corresponding provider.
# Hence, any subsequent call to "pkg-config blas" will yield the correct
# result.
# Note: If you override the default pkg_setup, make sure to call blas_pkg_setup.
blas_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"
	
	local BLAS_IMPL="$(_blas_best_impl)"
	local PKGCONFIG="$(_blas_impl_get_pkgconfig ${BLAS_IMPL})"
	local PKGCONFIG_LOCAL
	if ${BLAS_USE_CBLAS}; then
		PKGCONFIG_LOCAL=cblas
	else
		PKGCONFIG_LOCAL=blas
	fi
	mkdir "${T}/pkg-config/" die "Could not create the pkgconfig overlay directory"
	local NORMAL_PKGCONFIG="${EROOT}/usr/lib/pkgconfig"
	ln -s "${EROOT}/usr/lib/pkgconfig/${PKGCONFIG}.pc" "${T}/pkg-config/${PKGCONFIG_LOCAL}.pc"
	export PKG_CONFIG_PATH="${T}/pkg-config/:${PKG_CONFIG_PATH:-${NORMAL_PKGCONFIG}}"
}

EXPORT_FUNCTIONS pkg_setup
