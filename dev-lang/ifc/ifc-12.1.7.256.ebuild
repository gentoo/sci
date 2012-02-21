# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
INTEL_DPN=parallel_studio_xe
INTEL_DID=2405
INTEL_DPV=2011_sp1_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE=""

RDEPEND="~dev-libs/intel-common-${PV}[compiler]"
DEPEND="${RDEPEND}"

QA_PREBUILT="
	${INTEL_SDP_DIR}/bin/*/*
	${INTEL_SDP_DIR}/compiler/lib/*/*
	${INTEL_SDP_DIR}/mpirt/bin/*/*
	${INTEL_SDP_DIR}/mpirt/lib/*/*"
QA_PRESTRIPPED="${INTEL_SDP_DIR}/compiler/lib/*/.*libFNP.so"

INTEL_BIN_RPMS="compilerprof compilerprof-devel"
INTEL_DAT_RPMS="compilerprof-common"

src_install() {
	intel-sdp_src_install
	local i
	for i in /opt/intel/composerxe-2011.7.256/compiler/lib/{ia32,intel64}/locale/ja_JP/{diagspt,flexnet}.cat; do
		if [[ -e "${EPREFIX}${i}" ]]; then
			rm -rf "${ED}${i}" || die
		fi
	done
}
