# @ECLASS: lapack.eclass
# @MAINTAINER:
# schmidom@student.ethz.ch
# @BLURB: Selects a proper LAPACK implementation to build the package
# @DESCRIPTION:
# Here a LAPACK-implementation is chosen from the cutset of available,
# compatible and implementations in the USE flags
# If inherited, it automatically adds the dependencies to the right
# implementation to RDEPEND and DEPEND, and adds the USE flags corresponding
# to the compatible implementations to IUSE
# Additionally it provides a pkg_setup that does the actual heavy-lifting
# by forcing pkg-config to resolve the right parameters.

# @ECLASS-VARIABLE: LAPACK_COMPAT
# @DESCRIPTION:
# This variable contains a list of LAPACK implementations the package
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
# Since packages can depend on LAPACK either in Fortran or in C, the package
# may add a header specifier in front of the compatibility-list, e.g.
# "c: <list>". By default, "fortran:" is assumed.
# 
# If a package is compatible with any LAPACK implementation, "<list>" can
# be expressed with an asterisk ("*")
# 
# This variable defaults to "fortran: *"
#
# Example:
# @CODE
# LAPACK_COMPAT=( c: reflapack )
# @CODE
# This forces linking against sci-libs/lapacke-reference

# @ECLASS-VARIABLE: LAPACK_CONDITIONAL_FLAG
# @DEFAULT_UNSET
# @DESCRIPTION:
# This variable contains the USE-flag that selects whether the package
# should depend on LAPACK or not.
# If non-empty, it gets prepended to REQUIRED_USE, DEPEND and RDEPEND.
# If it is an array, we will depend on LAPACK when at least one of the 
# USE-flags is activated (logical OR)
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

# @ECLASS-VARIABLE: LAPACK_REQ_USE
# @DEFAULT_UNSET
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

LAPACK_COMPAT="${LAPACK_COMPAT:-fortran: *}"

# @ECLASS-VARIABLE: LAPACK_IMPLS
# @INTERNAL
# @DESCRIPTION:
# A list of all available LAPACK implementations providing fortran bindings
LAPACK_IMPLS=(reflapack mkl atlas)

# @ECLASS-VARIABLE: LAPACKE_IMPLS
# @INTERNAL
# @DESCRIPTION:
# A list of all available LAPACK implementations providing C bindings
LAPACKE_IMPLS=(reflapack mkl)

# @ECLASS-VARIABLE: LAPACK_SUPP_IMPLS
# @INTERNAL
# @DESCRIPTION:
# An ordered list of all the ebuild-supported implementations
# The order is the same as in LAPACK_IMPLS
LAPACK_SUPP_IMPLS=()

# @ECLASS-VARIABLE: LAPACK_USE_LAPACKE
# @INTERNAL
# @DESCRIPTION:
# Contains whether we depend on the C or the Fortran header.
LAPACK_USE_LAPACKE=false

# @ECLASS-VARIABLE: _lapack_provider_*
# @INTERNAL
# @DESCRIPTION:
# Sets the package that provides the fortran bindings to the corresponding
# implementation
_lapack_provider_reflapack="sci-libs/lapack-reference"
_lapack_provider_atlas="sci-libs/atlas[lapack]"
_lapack_provider_mkl="sci-libs/mkl"

# @ECLASS-VARIABLE: _lapacke_provider_*
# @INTERNAL
# @DESCRIPTION:
# Sets the package that provides the fortran bindings to the corresponding
# implementation
_lapacke_provider_reflapack="sci-libs/lapacke-reference"
_lapacke_provider_mkl="sci-libs/mkl"


# @ECLASS-VARIABLE: _lapack_special_pkgconfig_*
# @INTERNAL
# @DESCRIPTION:
# An array of size two containing the base-names for the package-config
# files installed by the implementation. The first one is for the 
# Fortran-headers the second one for the C-headers
_lapack_special_pkgconfig_reflapack=(reflapack reflapacke)

# @FUNCTION:  _lapack_impl_valid
# @INTERNAL
# @USAGE: <Implementation>
# @RETURN: Echos the pkgconfig-file for the given LAPACK implementation
# @DESCRIPTION:
# Echos the pkgconfig-file for the given LAPACK implementation
function _lapack_impl_get_pkgconfig(){
	local var
	eval "var=(\"\${_lapack_special_pkgconfig_${1}[@]}\")"
	if [ -z "${var[*]}" ]
	then
		echo "$1"
	fi
	
	if $LAPACK_USE_LAPACKE
	then
		echo "${var[1]}"
	else
		echo "${var[0]}"
	fi
}

# @FUNCTION:  _lapack_impl_valid
# @INTERNAL
# @USAGE: <Implementation>
# @RETURN: 0 if valid, 1 if invalid
# @DESCRIPTION:
# Checks whether the given implementation is in the set LAPACK_IMPLS
function _lapack_impl_valid(){
	local impl
	local impls
	if $LAPACK_USE_LAPACKE
	then
		impls=( "${LAPACKE_IMPLS[@]}" )
	else
		impls=( "${LAPACK_IMPLS[@]}" )
	fi
	for impl in "${impls[@]}"
	do
		if [ "$1" == "$impl" ]
		then
			return 0
		fi
	done
	return 1
}

# @FUNCTION:  _lapack_best_impl
# @INTERNAL
# @USAGE:
# @RETURN: Echos the name of the best allowed implementation
# @DESCRIPTION:
# This function returns the highest-ranked (as in LAPACK_IMPLS) implementation
# whose use-flag is set (i.e. the "best" implementation)
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

# @FUNCTION:  _lapack_useflag_by_impl
# @INTERNAL
# @USAGE: <Implementation> [Implementation,...]
# @RETURN: Echos the USE flag corresponding to the implementations
# @DESCRIPTION:
# This function echos the USE flag corresponding to the given implementation(s)
function _lapack_useflag_by_impl(){
	echo "${@/#/lapack_}"
}

# @FUNCTION:  _lapack_useflag_by_impl
# @INTERNAL
# @USAGE: <Implementation> [Implementation,...]
# @RETURN: Echos the USE flag corresponding to the implementations
# @DESCRIPTION:
# This function echos the USE flag corresponding to the given implementation(s)
function _lapack_get_depends(){
	local impl
	local lapack
	local provider
	if $LAPACK_USE_LAPACKE
	then
		lapack="lapacke"
	else
		lapack="lapack"
	fi
	local i=${#LAPACK_SUPP_IMPLS[@]}
	for impl in "${LAPACK_SUPP_IMPLS[@]}"
	do
		eval "provider=\"\${_${lapack}_provider_${impl}}\""
		if [[ $LAPACK_REQ_USE ]]
		then
			#Does the provider also have USE flag constraints?
			if [ "${provider: -1}" == "]" ]
			then
				provider="${provider:0:-1},${LAPACK_REQ_USE}]"
			else
				provider="${provider}[${LAPACK_REQ_USE}]"
			fi
		fi
		
		echo "$(_lapack_useflag_by_impl $impl)? ( ${provider} )"
		if [ "$i" -gt 1 ]
		then
			echo "!$(_lapack_useflag_by_impl $impl)? ("
		fi
		i=$((i-1))
	done
	i=1
	while [ "$i" -lt "${#LAPACK_SUPP_IMPLS[@]}" ]
	do
		echo ")"
		i=$((i+1))
	done
}

function _lapack_set_globals(){
	local impl
	
	#Prevent shell-expansion by prepending a \ to ever *
	local lapack_array=(${LAPACK_COMPAT[*]//\*/\\*})
	
	case "${lapack_array[0]}" in
		"c:")
			LAPACK_USE_LAPACKE=true
			lapack_array=("${lapack_array[@]:1}")
			;;
		"fortran:")
			lapack_array=("${lapack_array[@]:1}")
			;;
	esac
	
	for impl in "${lapack_array[@]}"
	do
		if [ "$impl" == '\*' ]
		then
			if $LAPACK_USE_LAPACKE
			then
				LAPACK_SUPP_IMPLS=( "${LAPACKE_IMPLS[@]}" )
			else
				LAPACK_SUPP_IMPLS=( "${LAPACK_IMPLS[@]}" )
			fi
		elif _lapack_impl_valid "$impl"
		then
			LAPACK_SUPP_IMPLS+=( "$impl" )
		else
			die "Unknown LAPACK implementation ${impl}"
		fi
	done
	
	IUSE="${IUSE[@]} $(_lapack_useflag_by_impl "${LAPACK_SUPP_IMPLS[@]}")"
	
	LAPACK_DEPS="$(_lapack_get_depends)"
	RDEPEND=""
	if [[ ${LAPACK_CONDITIONAL_FLAG} ]]
	then
		for flag in "${LAPACK_CONDITIONAL_FLAG[@]}"
		do
			RDEPEND="${RDEPEND} ${flag}? ( ${LAPACK_DEPS} )"
		done
	else
		RDEPEND="${LAPACK_DEPS}"
	fi
	DEPEND="${RDEPEND}"
}

_lapack_set_globals
unset -f _lapack_set_globals


# @FUNCTION: lapack_pkg_setup
# @USAGE:
# @DESCRIPTION:
# This function adds a temporary directory to the environment variable 
# PKG_CONFIG_PATH, and exports it.
# This directory contains a lapack.pc (or lapacke.pc, if LAPACK_COMPAT specifies
# the C-headers), that is linked to the pkgconfig-file installed by the 
# corresponding provider.
# Hence, any subsequent call to "pkg-config lapack" will yield the correct
# result.
# Note: If you override the default pkg_setup, make sure to call lapack_pkg_setup.
function lapack_pkg_setup(){
	debug-print-function ${FUNCNAME} "${@}"
	
	local LAPACK_IMPL="$(_lapack_best_impl)"
	local PKGCONFIG="$(_lapack_impl_get_pkgconfig $LAPACK_IMPL)"
	local PKGCONFIG_LOCAL
	if $LAPACK_USE_LAPACKE
	then
		PKGCONFIG_LOCAL=lapacke
	else
		PKGCONFIG_LOCAL=lapack
	fi
	mkdir "${T}/pkg-config/"
	local NORMAL_PKGCONFIG="${EROOT}/usr/lib/pkgconfig"
	ln -s "${EROOT}/usr/lib/pkgconfig/${PKGCONFIG}.pc" "${T}/pkg-config/${PKGCONFIG_LOCAL}.pc"
	export PKG_CONFIG_PATH="${T}/pkg-config/:${PKG_CONFIG_PATH:-${NORMAL_PKGCONFIG}}"
}

EXPORT_FUNCTIONS pkg_setup
