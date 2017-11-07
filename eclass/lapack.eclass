# @ECLASS: lapack.eclass
# @MAINTAINER:
# schmidom@student.ethz.ch
# @BLURB: Selects a proper LAPACK implementation to build the package
# @DESCRIPTION:
# Here a LAPACK-implementation is chosen from the cutset of available,
# compatible and implementations in the USE-flags
# The implementation is then enforced upon every dependency of the package

# @ECLASS-VARIABLE: LAPACK_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of LAPACK implementations the package
# supports. It has to be an array. Either it or LAPACK_COMPAT_ALL must be
# set before the `inherit' call. LAPACK_COMPAT_ALL overrides LAPACK_COMPAT.
#
# Example:
# @CODE
# LAPACK_COMPAT=( reflapack openlapack gotolapack mkl )
# @CODE

# @ECLASS-VARIABLE: LAPACK_COMPAT_ALL
# @REQUIRED
# @DESCRIPTION:
# This variable marks that the package is compatible with all (standard)
# LAPACK implementations. Set it to a non-empty value to make your package
# compatible with any LAPACK version. Either it or LAPACK_COMPAT must be set
# before the `inherit' call. LAPACK_COMPAT_ALL overrides LAPACK_COMPAT.
#
# Example:
# @CODE
# LAPACK_COMPAT_ALL=1
# @CODE

# @ECLASS-VARIABLE: LAPACK_USEDEP
# @DESCRIPTION:
# This is an eclass-generated USE-dependency string which has to be used
# to propagate the chosen LAPACK-implementation down the dependency graph
#
# Example use:
# @CODE
# RDEPEND="sci-libs/foo[${LAPACK_USEDEP}]"
# @CODE
#
# Example value:
# @CODE
# reflapack?,openlapack?
# @CODE


# @ECLASS-VARIABLE: LAPACK_CONDITIONAL_FLAG
# @DESCRIPTION:
# This variable contains the USE-flag that selects whether the package
# should depend on LAPACK or not.
# If non-empty, it gets prepended to REQUIRED_USE, DEPEND and RDEPEND.
#
# If, for example, set to
# @CODE
# LAPACK_CONDITIONAL_FLAG="lapack"
# @CODE
#
# Then the eclasses REQUIRED_USE and DEPENDs look like this:
# @CODE
# DEPEND="lapack? ( lapack_reflapack? ( sci-libs/lapack-reference ))"
# RDEPEND="${DEPEND}"
# REQUIRED_USE="lapack? ( ^^ ( lapack_reflapack lapack_openlapack ) )"
# @CODE

# @ECLASS-VARIABLE: LAPACK_USE_LAPACKE
# @DESCRIPTION:
# This variable sets whether your package depends on LAPACK C-headers.
# If non-empty, additional packages will be added to the DEPEND and 
# RDEPEND variable.
# This variable must be set before the call to inherit
#
# Example usage:
# @CODE
# LAPACK_USE_LAPACKE=1
# @CODE

# @ECLASS-VARIABLE: LAPACK_REQ_USE
# @DESCRIPTION:
# Adds a USE-flag requirement to every LAPACK-implementation we depend on
# (mainly useful for multilib, since the implementations share nearly no
# other flags)
# This must be set before the call to inherit lapack
#
# Example usage:
# @CODE
# LAPACK_REQ_USE="int64"
# @CODE
# 
# Will result in DEPENDs like.
# @CODE
# DEPEND="lapack_reflapack? ( sci-libs/lapack-reference[int64] )
# @CODE



LAPACK_IMPLS=(reflapack atlas mkl)
LAPACK_SUPP_IMPLS=()

_lapack_provider_reflapack="sci-libs/lapack-reference"
_lapack_provider_atlas="sci-libs/atlas"
_lapack_provider_mkl="sci-libs/mkl"

_lapacke_provider_reflapack="sci-libs/lapacke-reference"
_lapacke_provider_atlas=""
_lapacke_provider_mkl=""

function _lapack_impl_valid(){
	local impl
	for impl in "${LAPACK_IMPLS[@]}"
	do
		if [ "$1" == "$impl" ]
		then
			return 0
		fi
	done
	return 1
}

function _lapack_best_impl(){
	local impl
	
	for impl in "${LAPACK_SUPP_IMPLS[@]}"
	do
		if use "$(_lapack_useflag_by_impl $impl)"
		then
			echo $impl
			return
		fi
	done
	
	die "No matching implementation found"
}

function _lapack_useflag_by_impl(){
	echo "${@/#/lapack_}"
}

function _lapack_name_by_impl(){
	eval "echo \"\${_lapack_name_$1}\""
}

function _lapack_usedep(){
	local tmp
	tmp=("$(_lapack_useflag_by_impl "${LAPACK_SUPP_IMPLS[@]/%/?}" )" )
	echo "${tmp// /,}"
}

function _lapack_get_depends(){
	local impl
	local lapacke
	local requse
	for impl in "${LAPACK_SUPP_IMPLS[@]}"
	do
		if [[ $LAPACK_REQ_USE ]]
		then
			requse="[${LAPACK_REQ_USE}]"
		else
			requse=""
		fi
		if [[ $LAPACK_USE_CLAPACK ]]
		then
			eval "lapacke=\$_clapack_provider_$impl"
		else
			lapacke=""
		fi
		eval "echo \"$(_lapack_useflag_by_impl $impl)? ( \${_lapack_provider_$impl}${requse} ${lapacke}${requse} )\""
	done
}


function _lapack_set_globals(){
	local impl
	
	if [[ ${LAPACK_COMPAT_ALL} ]]
	then
		LAPACK_SUPP_IMPLS=( "${LAPACK_IMPLS[@]}" )
	else
		if [ "${#LAPACK_COMPAT[@]}" -eq 0 ]
		then
			die "No LAPACK implementations set in LAPACK_COMPAT"
		fi
		
		for impl in "${LAPACK_COMPAT[@]}"
		do
			if [ "$impl" == "*" ]
			then
			
				break
			elif _lapack_impl_valid "$impl"
			then
				LAPACK_SUPP_IMPLS+=( "$impl" )
			else
				die "Unknown LAPACK implementation ${impl}"
			fi
		done
	fi
	IUSE="${IUSE[@]} $(_lapack_useflag_by_impl "${LAPACK_SUPP_IMPLS[@]}")"
	
	LAPACK_USEDEP="$(_lapack_usedep)"
	LAPACK_DEPS="$(_lapack_get_depends)"
	LAPACK_REQUIRED_USE="^^ ( $(_lapack_useflag_by_impl "${LAPACK_SUPP_IMPLS[@]}") )"
	if [[ ${LAPACK_CONDITIONAL_FLAG} ]]
	then
		REQUIRED_USE="${LAPACK_CONDITIONAL_FLAG}? ( ${LAPACK_REQUIRED_USE} )"
		RDEPEND="${LAPACK_CONDITIONAL_FLAG}? ( ${LAPACK_DEPS} )"
	else
		REQUIRED_USE="${LAPACK_REQUIRED_USE}"
		RDEPEND="${LAPACK_DEPS}"
	fi
	DEPEND="${RDEPEND}"
}

_lapack_set_globals
unset -f _lapack_set_globals


function lapack_pkg_setup(){
	LAPACK_IMPL="$(_lapack_best_impl)"
	mkdir "${T}/pkg-config/"
	local NORMAL_PKGCONFIG="${EROOT}/usr/lib/pkgconfig"
	ln -s "${EROOT}/usr/lib/pkgconfig/$LAPACK_IMPL.pc" "${T}/pkg-config/lapack.pc"
	export PKG_CONFIG_PATH="${T}/pkg-config/:${PKG_CONFIG_PATH:-${NORMAL_PKGCONFIG}}"
}

EXPORT_FUNCTIONS pkg_setup
