# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
INTEL_DPN=parallel_studio_xe
INTEL_DID=2065
INTEL_DPV=2011_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE=""
DEPEND=""
RDEPEND=">=dev-libs/intel-common-12"

QA_PREBUILT="${INTEL_SDP_DIR}/ipp/lib/*/*"

CHECKREQS_DISK_BUILD=1536

INTEL_BIN_RPMS="ipp ipp-devel"
INTEL_DAT_RPMS="ipp-common"
