# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
INTEL_DPN=parallel_studio_xe
INTEL_DID=2405
INTEL_DPV=2011_sp1_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE=""
DEPEND=""
RDEPEND=">=dev-libs/intel-common-12"

QA_PREBUILT="
	${INTEL_SDP_DIR}/ipp/lib/*/*
	${INTEL_SDP_DIR}/ipp/tools/*/*/*
	${INTEL_SDP_DIR}/ipp/interfaces/data-compression/*/*/*/*"

CHECKREQS_DISK_BUILD=1536M

INTEL_BIN_RPMS="ipp-sp1 ipp-sp1-devel"
INTEL_DAT_RPMS="ipp-sp1-common"
