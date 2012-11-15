# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ifc/ifc-13.0.0.079-r1.ebuild,v 1.1 2012/09/20 21:13:24 jlec Exp $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2749
INTEL_DPV=2013
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE=""

RDEPEND="~dev-libs/intel-common-${PV}[compiler]"
DEPEND="${RDEPEND}"

INTEL_BIN_RPMS="compilerprof compilerprof-devel"
INTEL_DAT_RPMS="compilerprof-common"

CHECKREQS_DISK_BUILD=300M

src_install() {
	rm ${INTEL_SDP_DIR}/Documentation/en_US/gs_resources/intel_logo.gif || die
	intel-sdp_src_install
	local i
	local idir=${INTEL_SDP_EDIR}/compiler/lib
	for i in ${idir}/{ia32,intel64}/locale/ja_JP/{diagspt,flexnet,helpxi}.cat; do
		if [[ -e "${i}" ]]; then
			rm -rvf "${D}${i}" || die
		fi
	done
}
