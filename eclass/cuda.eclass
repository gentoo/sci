# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs versionator

# @ECLASS: cuda.eclass
# @MAINTAINER:
# Justin Lecher <jlec@gentoo.org>
# @BLURB: Common functions for cuda packages

# @ECLASS-VARIABLE: NVCCFLAGS
# DESCRIPTION:
# nvcc compiler flags (see nvcc --help)
: ${NVCCFLAGS:=-O2}

# @ECLASS-VARIABLE: CUDA_VERBOSE
# DESCRIPTION:
# Being verbose during compilation to see underlying commands
: ${CUDA_VERBOSE:=true}

[[ "${CUDA_VERBOSE}" == true ]] && NVCCFLAGS+=" -v"

# @ECLASS-FUNCTION: cuda_gccdir
# @DESCRIPTION:
# Helper for determination of the latest bindir supported by nvidia cuda toolkit.
#
# Calling plain it returns simply the path, but you probably want to add \"-f\""
# to get the full flag to add to nvcc call.
#
# cuda_gccdir -f
# -> --compiler-bindir="/usr/x86_64-pc-linux-gnu/gcc-bin/4.6.3"
cuda_gccdir() {
	local _gcc_bindir _ver _args="" _flag _ret

	# Currently we only support the gnu compiler suite
	[[ $(tc-getCXX) != *g++* ]] && return 2

	while [ "$1" ]; do
		case $1 in
			-f)
				_flag="--compiler-bindir="
				;;
			*)
				;;
		esac
		shift
	done

	if [[ ! $(type -P cuda-config) ]]; then
		eerror "Could not execute cuda-config"
		eerror "Make sure >=dev-util/nvidia-cuda-toolkit-4.2.9-r1 is installed"
		die "cuda-config not found"
	else
		_args="$(version_sort $(cuda-config -s))"
		if [[ ! -n ${_args} ]]; then
			die "Could not determine supported gcc versions from cuda-config"
		fi
	fi

	for _ver in ${_args}; do
      has_version sys-devel/gcc:${_ver} && \
         _gcc_bindir="$(ls -d ${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/${_ver}* | tail -n 1)"
   done

   if [[ -n ${_gcc_bindir} ]]; then
		if [[ -n ${_flag} ]]; then
			_ret="${_flag}\\\"${_gcc_bindir}\\\""
		else
	      _ret="${_gcc_bindir}"
		fi
		echo ${_ret}
		return 0
	else
      eerror "Only gcc version(s) ${_args} are supported,"
		eerror "of which none is installed"
      die "Only gcc version(s) ${_args} are supported"
      return 1
   fi
}

cuda_pkg_setup() {
	# Tell nvcc where to find a compatible compiler
	NVCCFLAGS+=" $(cuda_gccdir -f)"

	# Tell nvcc which flags should be used for underlying C compiler
	NVCCFLAGS+=" --compiler-options=\"${CXXFLAGS}\""

	export NVCCFLAGS
}

cuda_pkg_postinst() {
	local a
	a="$(version_sort $(cuda-config -s))"; a=($a)
   if [[ $(tc-getCC) == *gcc* ]] && version_is_at_least "$(gcc-version)" ${a[1]}; then
      ewarn "gcc >= 4.6 will not work with CUDA"
      ewarn "Make sure you set an earlier version of gcc with gcc-config"
		ewarn "or append --compiler-bindir= to the nvcc compiler flags"
		ewarn "pointing to a gcc installation dir like"
		ewarn "${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc4.6"
   fi
}

EXPORT_FUNCTIONS pkg_setup pkg_postinst
case "${EAPI:-0}" in
   0|1|2|3|4|5) ;;
   *) die "EAPI=${EAPI} is not supported" ;;
esac
