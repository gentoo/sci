# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2020_update1_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel Integrated Performance Primitive library"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="~dev-libs/intel-common-19.1.1.217[compiler]"

CHECKREQS_DISK_BUILD=6500M

MY_PV="$(ver_rs 2 '-')" # 2020.1-217

QA_PREBUILT="*"

INTEL_DIST_DAT_RPMS=(
	"ipp-common-${MY_PV}-${MY_PV}.noarch.rpm"
	"ipp-common-ps-${MY_PV}-${MY_PV}.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"ipp-mt-${MY_PV}-${MY_PV}.x86_64.rpm"
	"ipp-mt-devel-${MY_PV}-${MY_PV}.x86_64.rpm"
	"ipp-st-${MY_PV}-${MY_PV}.x86_64.rpm"
	"ipp-st-devel-${MY_PV}-${MY_PV}.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"ipp-mt-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"ipp-mt-devel-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"ipp-st-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"ipp-st-devel-32bit-${MY_PV}-${MY_PV}.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"ipp-doc-2020-${MY_PV}.noarch.rpm")
	fi
}
