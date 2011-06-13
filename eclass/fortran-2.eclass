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
# current fortran compiler through FC_NEED_OPENMP=1.
# Only phase function exported is pkg_setup.

# @ECLASS-VARIABLE: FC_NEED_OPENMP
# @DESCRIPTION:
# Set FC_NEED_OPENMP=1 in order to test FC for openmp capabilities
#
# Default is 0

inherit toolchain-funcs

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

# internal function
#
# FUNCTION: _have-valid-fortran
# DESCRIPTION:
# Check whether FC returns a working fortran compiler
_have-valid-fortran() {
	local base=${T}/test-tc-fortran
	cat <<- EOF > "${base}.f"
	       end
	EOF
	$(tc-getFC "$@") "${base}.f" -o "${base}" >&/dev/null
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
	case $(tc-getFC) in
		*gfortran*|pathf*)
			flag=-fopenmp ;;
		ifort)
			flag=-openmp ;;
		mpi*)
			local _fcomp=$($(tc-getFC) -show | awk '{print $1}')
			FC=${_fcomp} _fortran-has-openmp
			return $? ;;
		*)
			return 0 ;;
	esac
	local base=${T}/test-fc-openmp
	# leave extra leading space to make sure it works on fortran 77 as well
	cat <<- EOF > "${base}.f"
       call omp_get_num_threads
       end
	EOF
	$(tc-getFC "$@") ${flag} "${base}.f" -o "${base}" >&/dev/null
	local ret=$?
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

# @FUNCTION: fortran-2_pkg_setup
# @DESCRIPTION:
# Setup functionallity, checks for a valid fortran compiler and optionally for its openmp support.
fortran-2_pkg_setup() {
	_have-valid-fortran || \
		die "Please emerge the current gcc with USE=fortran or export FC defining a working fortran compiler"
	export FC=$(tc-getFC)
	export F77=$(tc-getFC)
	export F90=$(tc-getFC)
	export F95=$(tc-getFC)
	if [[ ${FC_NEED_OPENMP} == 1 ]]; then
		_fortran-has-openmp || \
		die "Please emerge current gcc with USE=openmp or export FC with compiler that supports OpenMP"
	fi
}

EXPORT_FUNCTIONS pkg_setup
