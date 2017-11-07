# @ECLASS: blas.eclass
# @MAINTAINER:
# schmidom@student.ethz.ch
# @BLURB: Selects a proper BLAS implementation to build the package
# @DESCRIPTION:
# Here a BLAS-implementation is chosen from the cutset of available,
# compatible and implementations in the USE-flags
# The implementation is then enforced upon every dependency of the package

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
	for impl in "${BLAS_SUPP_IMPLS[@]}"
	do
		if [[ $BLAS_USE_CBLAS ]]
		then
			eval "cblas=\$_cblas_provider_$impl"
		else
			cblas=""
		fi
		eval "echo \"$(_blas_useflag_by_impl $impl)? ( \$_blas_provider_$impl $cblas )\""
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
