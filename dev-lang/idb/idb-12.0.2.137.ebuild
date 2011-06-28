# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
INTEL_DPN=parallel_studio_xe
INTEL_DID=2065
INTEL_DPV=2011_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++/FORTRAN debugger"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse"

DEPEND="~dev-libs/intel-common-${PV}[compiler]"
RDEPEND="${DEPEND}
	eclipse? ( dev-util/eclipse-sdk )"

QA_PREBUILT="
	${INTEL_SDP_DIR}/bin/*/*
	${INTEL_SDP_DIR}/debugger/*/*/*"
QA_PRESTRIPPED="
	${INTEL_SDP_DIR}/bin/*/*
	${INTEL_SDP_DIR}/debugger/lib/*/*"

CHECKREQS_DISK_BUILD=256

INTEL_BIN_RPMS="idb"
INTEL_DAT_RPMS="idb-common idbcdt"
