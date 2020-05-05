# Copyright 2439-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2020_update1_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=500M

MY_PV="$(ver_rs 3 '-')" # 20.1.0-607630

QA_PREBUILT="*"

INTEL_DIST_DAT_RPMS=(
	"icc-common-${MY_PV}-${MY_PV}.noarch.rpm"
	"icc-common-ps-${MY_PV}-${MY_PV}.noarch.rpm"
	"idesupport-icc-common-ps-19.1-${MY_PV}.noarch.rpm")
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

