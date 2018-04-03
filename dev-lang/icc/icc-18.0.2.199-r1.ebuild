# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=3235
INTEL_DIST_PV=2018_update2_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

# avoid file collision with ifc #476330
RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=500M

INTEL_DIST_DAT_RPMS=(
	"icc-common-18.0.2-199-18.0.2-199.noarch.rpm"
	"icc-common-ps-18.0.2-199-18.0.2-199.noarch.rpm"
	"icc-common-ps-ss-bec-18.0.2-199-18.0.2-199.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"icc-18.0.2-199-18.0.2-199.x86_64.rpm"
	"icc-ps-18.0.2-199-18.0.2-199.x86_64.rpm"
	"icc-ps-ss-18.0.2-199-18.0.2-199.x86_64.rpm"
	"icc-ps-ss-bec-18.0.2-199-18.0.2-199.x86_64.rpm")
INTEL_DIST_X86_RPMS=(
	"icc-32bit-18.0.2-199-18.0.2-199.x86_64.rpm"
	"icc-ps-ss-bec-32bit-18.0.2-199-18.0.2-199.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"icc-doc-18.0-18.0.2-199.noarch.rpm"
			"icc-doc-ps-18.0-18.0.2-199.noarch.rpm")
	fi
}
