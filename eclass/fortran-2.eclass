# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author Justin Lecher <jlec@gentoo.org>
# Test functions provided by Sebastien Fabbro and Kacper Kowalik

# @ECLASS: fortran-2.eclass
# @MAINTAINER:
# jlec@gentoo.org
# sci@gentoo.org
# @BLURB: Simplify fortran compiler management
# @DESCRIPTION:
# If you need a fortran compiler, then you should be inheriting this eclass.
# The eclass tests for working fortran compilers
# and exports the variables FC and F77.
# Optionally, it checks for extended capabilities based on
# the variable options selected in the ebuild
# The only phase functions exported are pkg_pretend and pkg_setup.

# @ECLASS-VARIABLE: FORTRAN_NEED_OPENMP
# @DESCRIPTION:
# Set to "1" in order to automatically have the eclass abort if the fortran
# compiler lacks openmp support.
: ${FORTRAN_NEED_OPENMP:=0}

# @ECLASS-VARIABLE: FORTRAN_STANDARD
# @DESCRIPTION:
# Set this, if a special dialect needs to be supported.
# Generally not needed as default is sufficient.
#
# Valid settings are any combination of: 77 90 95 2003
: ${FORTRAN_STANDARD:=77}

inherit toolchain-funcs

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

# @FUNCTION: _write_testsuite
# @DESCRIPTION: writes fortran test code
# @INTERNAL
_write_testsuite() {
	local filebase=${T}/test-fortran

	# f77 code
	cat <<- EOF > "${filebase}.f"
	       end
	EOF

	# f90/95 code
	cat <<- EOF > "${filebase}.f90"
	end
	EOF

	# f2003 code
	cat <<- EOF > "${filebase}.f03"
	       procedure(), pointer :: p
	       end
	EOF
}

# @FUNCTION: _compile_test
# @DESCRIPTION:
# Takes fortran compiler as first argument and dialect as second.
# Checks whether the passed fortran compiler speaks the fortran dialect
# @INTERNAL
_compile_test() {
	local filebase=${T}/test-fortran
	local fcomp=${1}
	local fdia=${2}
	local fcode=${filebase}.f${fdia}
	local ret

	[[ $# -eq 0 ]] && die "_compile_test() needs at least one argument"

	[[ -f ${fcode} ]] || _write_testsuite

	${fcomp} "${fcode}" -o "${fcode}.x" >&/dev/null
	ret=$?

	rm -f "${fcode}.x"
	return ${ret}
}

# @FUNCTION: _fortran-has-openmp
# @DESCRIPTION:
# See if the fortran supports OpenMP.
# @INTERNAL
_fortran-has-openmp() {
	local flag
	local filebase=${T}/test-fc-openmp
	local fcode=${filebase}.f
	local ret
	local _fc=$(tc-getFC)

	cat <<- EOF > "${fcode}"
	       call omp_get_num_threads
	       end
	EOF

	for flag in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
		${_fc} ${flag} "${fcode}" -o "${fcode}.x" >&/dev/null
		ret=$?
		(( ${ret} )) || break
	done

	rm -f "${fcode}.x"
	return ${ret}
}

# @FUNCTION: _die_msg
# @DESCRIPTION: Detailed description how to handle fortran support
# @INTERNAL
_die_msg() {
	echo
	eerror "Please install currently selected gcc version with USE=fortran."
	eerror "If you intend to use a different compiler then gfortran, please"
	eerror "set FC variable accordingly and take care that the neccessary"
	eerror "fortran dialects are support."
	echo
	die "Currently no working fortran compiler is available"
}

# @FUNCTION: fortran-2_pkg_pretend
# @DESCRIPTION:
# Setup functionallity, checks for a valid fortran compiler and optionally for its openmp support.
fortran-2_pkg_pretend() {
	local dialect

	: ${F77:=$(tc-getFC)}

	: ${FORTRAN_STANDARD:=77}
	for dialect in ${FORTRAN_STANDARD}; do
		case ${dialect} in
			77) _compile_test $(tc-getF77) || _die_msg ;;
			90|95) _compile_test $(tc-getFC) 90 || _die_msg ;;
			2003) _compile_test $(tc-getFC) 03 || _die_msg ;;
			2008) die "Future" ;;
			*) die "${dialect} is not a Fortran dialect." ;;
		esac
	done

	if [[ ${FORTRAN_NEED_OPENMP} == 1 ]]; then
		_fortran-has-openmp || \
			die "Please install current gcc with USE=openmp or set the FC variable to a compiler that supports OpenMP"
	fi
}

# @FUNCTION: fortran-2_pkg_setup
# @DESCRIPTION:
# In EAPI < 4 it calls the compiler check. This behavior is deprecated
# and will be removed at 01-Okt-2011. Please migrate to EAPI=4.
#
# Exports the FC and F77 variable according to the compiler checks.
fortran-2_pkg_setup() {
	if has ${EAPI:-0} 0 1 2 3; then
		ewarn "The support for EAPI=${EAPI} by the fortran-2.eclass"
		ewarn "will be end at 01-Okt-2011"
		ewarn "Please migrate your package to EAPI=4"
		fortran-2_pkg_pretend
	fi
	[[ -n ${F77} ]] || export F77=$(tc-getFC)
	[[ -n ${FC} ]] || export FC=$(tc-getFC)
}

case ${EAPI:-0} in
	1|2|3) EXPORT_FUNCTIONS pkg_setup ;;
	4) EXPORT_FUNCTIONS pkg_pretend pkg_setup ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac
