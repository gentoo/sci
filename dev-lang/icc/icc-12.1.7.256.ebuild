# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2405
INTEL_DPV=2011_sp1_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse"

DEPEND="~dev-libs/intel-common-${PV}[compiler]"
RDEPEND="${DEPEND}
	eclipse? ( dev-util/eclipse-sdk )"

QA_PREBUILT="
	${INTEL_SDP_DIR}/bin/*/*
	${INTEL_SDP_DIR}/compiler/lib/*/*
	${INTEL_SDP_DIR}/mpirt/bin/*/*
	${INTEL_SDP_DIR}/mpirt/lib/*/*"
QA_PRESTRIPPED="${INTEL_SDP_DIR}/compiler/lib/*/.*libFNP.so"

INTEL_BIN_RPMS="compilerproc compilerproc-devel"
INTEL_DAT_RPMS="compilerproc-common"
