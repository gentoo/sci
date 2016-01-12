# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

INTEL_DPN=parallel_studio_xe
INTEL_DID=8365
INTEL_DPV=2016_update1
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp-r1

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse linguas_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	!dev-lang/ifc[linguas_ja]
	eclipse? ( dev-util/eclipse-sdk )"
RDEPEND="${DEPEND}
	~dev-libs/intel-common-${PV}[compiler]"

#INTEL_BIN_RPMS="compilerproc compilerproc-devel"
#INTEL_DAT_RPMS="compilerproc-common compilerproc-vars"

CHECKREQS_DISK_BUILD=325M

pkg_setup() {
	INTEL_BIN_RPMS="icc-l-all-devel"
	INTEL_DAT_RPMS="icc-doc-16.0.1-150.noarch.rpm icc-l-all-common icc-l-all-vars icc-l-ps-common icc-ps-doc-16.0.1-150.noarch.rpm icc-ps-doc-jp-16.0.1-150.noarch.rpm icc-ps-ss-doc-16.0.1-150.noarch.rpm"

	INTEL_X86_RPMS="icc-l-all-32 icc-l-ps icc-l-ps-ss-wrapper"
	INTEL_AMD64_RPMS="icc-l-all icc-l-ps-devel icc-l-ps-ss icc-l-ps-ss-devel"

	intel-sdp-r1_pkg_setup
}

src_install() {
	if ! use linguas_ja; then
		find "${S}" -type d -name ja_JP -exec rm -rf '{}' + || die
	fi
	intel-sdp-r1_src_install
}
