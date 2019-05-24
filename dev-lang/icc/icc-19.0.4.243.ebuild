# Copyright 2439-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_PV=2019_update4_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="doc"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

# avoid file collision with ifc #476330
RDEPEND="~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=500M

INTEL_DIST_DAT_RPMS=(
	"icc-common-19.0.4-243-19.0.4-243.noarch.rpm"
	"icc-common-ps-19.0.4-243-19.0.4-243.noarch.rpm"
	"icc-common-ps-ss-bec-19.0.4-243-19.0.4-243.noarch.rpm")
INTEL_DIST_AMD64_RPMS=(
	"icc-19.0.4-243-19.0.4-243.x86_64.rpm"
	"icc-ps-19.0.4-243-19.0.4-243.x86_64.rpm"
	"icc-ps-ss-bec-19.0.4-243-19.0.4-243.x86_64.rpm")

INTEL_DIST_X86_RPMS=(
	"icc-32bit-19.0.4-243-19.0.4-243.x86_64.rpm"
	"icc-ps-ss-bec-32bit-19.0.4-243-19.0.4-243.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=(
			"icc-doc-19.0-19.0.4-243.noarch.rpm"
			"icc-doc-ps-19.0-19.0.4-243.noarch.rpm")
	fi
}

