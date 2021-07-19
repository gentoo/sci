# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_NAME=system_studio
INTEL_DIST_PV=2020_u3_ultimate_edition_offline
INTEL_DIST_TARX=tar.gz
INTEL_DIST_MINOR=4
INTEL_RPMS_DIR=pset/yum.cache/l_comp_lib_p_2020.4.304

INTEL_PID=17148		# from registration center

inherit intel-sdp-r2

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"
SRC_URI="https://registrationcenter-download.intel.com/akdlm/irc_nas/${INTEL_PID}/${INTEL_DIST_NAME}_${INTEL_DIST_PV}.tar.gz"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

RESTRICT=${RESTRICT//fetch/}

MY_PV="$(ver_rs 3 '-')"                             # 19.1.3-304

CHECKREQS_DISK_BUILD=500M

QA_PREBUILT="*"

INTEL_DIST_DAT_RPMS=(
	"icc-common-${MY_PV}-${MY_PV}.noarch.rpm"
	"icc-common-ps-${MY_PV}-${MY_PV}.noarch.rpm"
)
INTEL_DIST_AMD64_RPMS=(
	"icc-${MY_PV}-${MY_PV}.x86_64.rpm"
	"icc-ps-${MY_PV}-${MY_PV}.x86_64.rpm"
	"icc-ps-ss-bec-${MY_PV}-${MY_PV}.x86_64.rpm")

INTEL_DIST_X86_RPMS=(
	"icc-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"icc-ps-ss-bec-32bit-${MY_PV}-${MY_PV}.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "icc-doc-19.1-${MY_PV}.noarch.rpm" )
	fi
}
