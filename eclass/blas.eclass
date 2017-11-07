# @ECLASS: blas.eclass
# @MAINTAINER:
# schmidom@student.ethz.ch
# @BLURB: Selects a proper BLAS implementation to build the package
# @DESCRIPTION:
# Here a BLAS-implementation is chosen from the cutset of available,
# compatible and implementations in the USE-flags
# The implementation is then enforced upon every dependency of the package

# @ECLASS-VARIABLE: BLAS_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of BLAS implementations the package
# supports. It has to be an array. Either it or BLAS_COMPAT_ALL must be
# set before the `inherit' call. BLAS_COMPAT_ALL overrides BLAS_COMPAT.
#
# Example:
# @CODE
# BLAS_COMPAT=( refblas openblas gotoblas mkl )
# @CODE

# @ECLASS-VARIABLE: BLAS_COMPAT_ALL
# @REQUIRED
# @DESCRIPTION:
# This variable marks that the package is compatible with all (standard)
# BLAS implementations. Set it to a non-empty value to make your package
# compatible with any BLAS version. Either it or BLAS_COMPAT must be set
# before the `inherit' call. BLAS_COMPAT_ALL overrides BLAS_COMPAT.
#
# Example:
# @CODE
# BLAS_COMPAT_ALL=1
# @CODE

# @ECLASS-VARIABLE: BLAS_USEDEP
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which has to be used
# to propagate the chosen BLAS-implementation down the dependency graph
#
# Example use:
# @CODE
# RDEPEND="sci-libs/foo[${BLAS_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# refblas?,openblas?
# @CODE


# @ECLASS-VARIABLE: BLAS_CONDITIONAL_FLAG
# @DESCRIPTION:
# This variable contains the USE-flag that selects whether the package
# should depend on BLAS or not.
# If non-empty, it gets prepended to REQUIRED_USE, DEPEND and RDEPEND.
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

# @ECLASS-VARIABLE: BLAS_USE_CBLAS
# @DESCRIPTION:
# This variable sets whether your package depends on BLAS C-headers.
# If non-empty, additional packages will be added to the DEPEND and 
# RDEPEND variable.
# This variable must be set before the call to inherit
#
# Example usage:
# @CODE
# BLAS_USE_CBLAS=1
# @CODE

# @ECLASS-VARIABLE: BLAS_REQ_USE
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



BLAS_IMPLS=(refblas openblas gotoblas mkl)
BLAS_SUPP_IMPLS=()

_blas_provider_refblas="sci-libs/blas-reference"
_blas_provider_openblas="sci-libs/openblas"
_blas_provider_gotoblas="sci-libs/gotoblas2"
_blas_provider_mkl="sci-libs/mkl"

_cblas_provider_refblas="sci-libs/cblas-reference"
_cblas_provider_openblas=""
_cblas_provider_gotoblas=""
_cblas_provider_mkl=""

function _blas_impl_valid(){
	local impl
	for impl in "${BLAS_IMPLS[@]}"
	do
		if [ "$1" == "$impl" ]
		then
			return 0
		fi
	done
	return 1
}

function _blas_best_impl(){
	local impl
	
	for impl in "${BLAS_SUPP_IMPLS[@]}"
	do
		if use "$(_blas_useflag_by_impl $impl)"
		then
			echo $impl
			return
		fi
	done
	
	die "No matching implementation found"
}

function _blas_useflag_by_impl(){
	echo "${@/#/blas_}"
}

function _blas_name_by_impl(){
	eval "echo \"\${_blas_name_$1}\""
}

function _blas_usedep(){
	local tmp
	tmp=("$(_blas_useflag_by_impl "${BLAS_SUPP_IMPLS[@]/%/?}" )" )
	echo "${tmp// /,}"
}

function _blas_get_depends(){
	local impl
	local cblas
	local requse
	for impl in "${BLAS_SUPP_IMPLS[@]}"
	do
		if [[ $BLAS_REQ_USE ]]
		then
			requse="[${BLAS_REQ_USE}]"
		else
			requse=""
		fi
		if [[ $BLAS_USE_CBLAS ]]
		then
			eval "cblas=\$_cblas_provider_$impl"
		else
			cblas=""
		fi
		eval "echo \"$(_blas_useflag_by_impl $impl)? ( \${_blas_provider_$impl}${requse} ${cblas}${requse} )\""
	done
}

function _blas_set_globals(){
	local impl
	
	if [[ ${BLAS_COMPAT_ALL} ]]
	then
		BLAS_SUPP_IMPLS=( "${BLAS_IMPLS[@]}" )
	else
		if [ "${#BLAS_COMPAT[@]}" -eq 0 ]
		then
			die "No BLAS implementations set in BLAS_COMPAT"
		fi
		
		for impl in "${BLAS_COMPAT[@]}"
		do
			if [ "$impl" == "*" ]
			then
			
				break
			elif _blas_impl_valid "$impl"
			then
				BLAS_SUPP_IMPLS+=( "$impl" )
			else
				die "Unknown BLAS implementation ${impl}"
			fi
		done
	fi
	IUSE="${IUSE[@]} $(_blas_useflag_by_impl "${BLAS_SUPP_IMPLS[@]}")"
	
	BLAS_USEDEP="$(_blas_usedep)"
	BLAS_DEPS="$(_blas_get_depends)"
	BLAS_REQUIRED_USE="^^ ( $(_blas_useflag_by_impl "${BLAS_SUPP_IMPLS[@]}") )"

	if [[ ${BLAS_CONDITIONAL_FLAG} ]]
	then
		REQUIRED_USE="${BLAS_CONDITIONAL_FLAG}? ( ${BLAS_REQUIRED_USE} )"
		RDEPEND="${BLAS_CONDITIONAL_FLAG}? ( ${BLAS_DEPS} )"
	else
		REQUIRED_USE="${BLAS_REQUIRED_USE}"
		RDEPEND="${BLAS_DEPS}"
	fi
	DEPEND="${RDEPEND}"
}

_blas_set_globals
unset -f _blas_set_globals


function blas_pkg_setup(){
	BLAS_IMPL="$(_blas_best_impl)"
	mkdir "${T}/pkg-config/"
	local NORMAL_PKGCONFIG="${EROOT}/usr/lib/pkgconfig"
	ln -s "${EROOT}/usr/lib/pkgconfig/$BLAS_IMPL.pc" "${T}/pkg-config/blas.pc"
	export PKG_CONFIG_PATH="${T}/pkg-config/:${PKG_CONFIG_PATH:-${NORMAL_PKGCONFIG}}"
}

EXPORT_FUNCTIONS pkg_setup
