# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs versionator

# @ECLASS: cuda.eclass
# @MAINTAINER:
# Justin Lecher <jlec@gentoo.org>
# @BLURB: Common functions for cuda packages

#  @ECLASS-VARIABLE: 


# @ECLASS-FUNCTION: CUDA_SUPPORTED_GCC
# @DESCRIPTION:
# Listing of gcc version slots supported by nvidia cuda tool.
# Generally only needed py

cuda_pkg_postinst() {
   if [[ $(tc-getCC) == *gcc* ]] && version_is_at_least 4.7 "$(gcc-version)"; then
      ewarn "gcc >= 4.6 will not work with CUDA"
      ewarn "Make sure you set an earlier version of gcc with gcc-config"
		ewarn "or append --compiler-bindir= to the nvcc compiler flags"
		ewarn "pointing to a gcc installation dir like"
		ewarn "${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc4.6"
   fi
}

EXPORT_FUNCTIONS pkg_postinst
case "${EAPI:-0}" in
   0|1|2|3|4|5) ;;
   *) die "EAPI=${EAPI} is not supported" ;;
esac

