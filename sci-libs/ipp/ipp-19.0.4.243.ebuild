# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2019_update4_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel Integrated Performance Primitive library"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND=""
RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=6500M

INTEL_DIST_DAT_RPMS=(
	"ipp-common-2019.4-243-2019.4-243.noarch.rpm"
	"ipp-common-ps-2019.4-243-2019.4-243.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"ipp-mt-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-mt-devel-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-st-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-st-devel-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-st-devel-ps-2019.4-243-2019.4-243.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"ipp-mt-32bit-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-mt-devel-32bit-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-st-32bit-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-st-devel-32bit-2019.4-243-2019.4-243.x86_64.rpm"
	"ipp-st-devel-ps-32bit-2019.4-243-2019.4-243.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"ipp-doc-2019-2019.4-243.noarch.rpm")
	fi
}
