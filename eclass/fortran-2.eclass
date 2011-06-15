# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author Justin Lecher <jlec@gentoo.org>
# Test functions provided by Sebastien Fabbro and Kacper Kowalik

# @ECLASS: fortran-2.eclass
# @MAINTAINER:
# jlec@gentoo.org
# sci@gentoo.org
# @BLURB: Packages, which need a fortran compiler should inherit this eclass.
# @DESCRIPTION:
# If you need a fortran compiler, inherit this eclass. This eclass tests for
# working fortran compilers. Optional, it checks for openmp capability of the
# current fortran compiler through FORTRAN_NEED_OPENMP=1.
# Only phase function exported is pkg_setup.

# @ECLASS-VARIABLE: FORTRAN_NEED_OPENMP
# @DESCRIPTION:
# Set FORTRAN_NEED_OPENMP=1 in order to test FC for openmp capabilities
#
# Default is 0

inherit toolchain-funcs

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

# internal function
#
# FUNCTION: _speaks_fortran_generic
# DESCRIPTION:
# Takes fortran compiler as argument.
# Checks whether the passed fortran compiler is working
_speaks_fortran_generic() {
	local base=${T}/test-fortran-generic
	local fcomp=${1}

	[[ -z ${fcomp} ]] && die "_speaks_fortran_generic needs one argument"

	cat <<- EOF > "${base}.f"
	       end
	EOF
	${fcomp} "${base}.f" -o "${base}" >&/dev/null
	local ret=$?

	rm -f "${base}"*
	return ${ret}
}

# internal function
#
# FUNCTION: _speaks_fortran_2003
# DESCRIPTION:
# Takes fortran compiler as argument.
# Checks whether the passed fortran compiler is working
_speaks_fortran_2003() {
	local base=${T}/test-fortran-2003
	local fcomp=${1}

	[[ -z ${fcomp} ]] && die "_speaks_fortran_2003 needs one argument"

	cat <<- EOF > "${base}.f"
	       procedure(), pointer :: p
	       end
	EOF
	${fcomp} "${base}.f" -o "${base}" >&/dev/null
	local ret=$?

	rm -f "${base}"*
	return ${ret}
}

# internal function
#
# FUNCTION: _fortran-has-openmp
# DESCRIPTION:
# See if the fortran supports OpenMP.
_fortran-has-openmp() {
	local flag
	local base=${T}/test-fc-openmp

	cat <<- EOF > "${base}.f"
	       call omp_get_num_threads
	       end
	EOF

	for flag in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
		$(tc-getFC "$@") ${flag} "${base}.f" -o "${base}" >&/dev/null
		local ret=$?
		(( ${ret} )) || break
	done

	rm -f "${base}"*
	return ${ret}
}

# @FUNCTION: get_fcomp
# @DESCRIPTION:
# Returns the canonical name or the native compiler of the current fortran compiler
#
# e.g.
#
# x86_64-linux-gnu-gfortran -> gfortran
get_fcomp() {
	case $(tc-getFC) in
		*gfortran* )
			echo "gfortran" ;;
		*g77* )
			echo "g77" ;;
		ifort )
			echo "ifc" ;;
		pathf*)
			echo "pathcc" ;;
		mpi*)
			local _fcomp=$($(tc-getFC) -show | awk '{print $1}')
			echo $(FC=${_fcomp} get_fcomp) ;;
		* )
			echo $(tc-getFC) ;;
	esac
}

# @FUNCTION: fortran-2_pkg_pretend
# @DESCRIPTION:
# Setup functionallity, checks for a valid fortran compiler and optionally for its openmp support.
fortran-2_pkg_pretend() {
	local dialect

	_speaks_fortran_generic $(tc-getFC) || \
		_speaks_fortran_generic $(tc-getF77) || \
		die "Please emerge the current gcc with USE=fortran or export FC defining a working fortran compiler"

	[[ -n ${FORTRAN_STANDARD} ]] || FORTRAN_STANDARD="77"

	for dialect in ${FORTRAN_STANDARD}; do
		case ${dialect} in
			77|90|95) _speaks_fortran_generic $(tc-getFC) || \
				die "Your fortran compiler does not speak the Fortran ${dialect}" ;;
			2003) _speaks_fortran_${dialect} $(tc-getFC) ||  \
				die "Your fortran compiler does not speak the Fortran ${dialect}" ;;
			2008) die "Future";;
			*) die "This dialect is not a fortran ";;
		esac
	done

	if [[ ${FORTRAN_NEED_OPENMP} == 1 ]]; then
		_fortran-has-openmp || \
			die "Please emerge current gcc with USE=openmp or export FC with compiler that supports OpenMP"
	fi
}

case "${EAPI:-0}" in
	4) EXPORT_FUNCTIONS pkg_pretend;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac
