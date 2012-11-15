# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/icc/icc-13.0.0.079.ebuild,v 1.1 2012/09/16 19:17:52 jlec Exp $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2749
INTEL_DPV=2013
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse"

DEPEND="
	eclipse? ( dev-util/eclipse-sdk )"
RDEPEND="${DEPEND}
	~dev-libs/intel-common-${PV}[compiler]"

INTEL_BIN_RPMS="compilerproc compilerproc-devel"
INTEL_DAT_RPMS="compilerproc-common"

src_install() {
	intel-sdp_src_install
	local i
	local idir=${INTEL_SDP_EDIR}/compiler/lib
	for i in ${idir}/{ia32,intel64}/locale/ja_JP/{diagspt,flexnet,helpxi}.cat; do
		if [[ -e "${i}" ]]; then
			rm -rvf "${D}${i}" || die
		fi
	done
}
