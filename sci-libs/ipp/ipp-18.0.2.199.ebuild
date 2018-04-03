# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=3235
INTEL_DIST_PV=2018_update2_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel Integrated Performance Primitive library"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=6500M

INTEL_DIST_DAT_RPMS=(
	"ipp-common-2018.2-199-2018.2-199.noarch.rpm"
	"ipp-common-ps-2018.2-199-2018.2-199.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"ipp-mt-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-mt-devel-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-st-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-st-devel-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-st-devel-ps-2018.2-199-2018.2-199.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"ipp-mt-32bit-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-mt-devel-32bit-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-st-32bit-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-st-devel-32bit-2018.2-199-2018.2-199.x86_64.rpm"
	"ipp-st-devel-ps-32bit-2018.2-199-2018.2-199.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"ipp-doc-2018-2018.2-199.noarch.rpm")
	fi
}
