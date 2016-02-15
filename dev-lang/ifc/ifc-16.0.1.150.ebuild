# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

INTEL_DPN=parallel_studio_xe
INTEL_DID=8365
INTEL_DPV=2016_update1
INTEL_SUBDIR=compilers_and_libraries
INTEL_SINGLE_ARCH=false

inherit intel-sdp-r1

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

LINGUAS="ja"
IUSE="doc examples linguas_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="!dev-lang/ifc[linguas_ja]"
RDEPEND="${DEPEND}
	~dev-libs/intel-common-${PV}[compiler]"

CHECKREQS_DISK_BUILD=375M

INTEL_BIN_RPMS=(
	"ifort-l-ps"
	"ifort-l-ps-devel")
INTEL_DAT_RPMS=(
	"fcompxe-2016.1-056.noarch.rpm"
	"ifort-l-ps-common"
	"ifort-l-ps-vars")
INTEL_X86_RPMS=()
INTEL_AMD64_RPMS=()

pkg_setup() {
	if use doc; then
		INTEL_DAT_RPMS+=(
			"fcompxe-doc-2016.1-056.noarch.rpm"
			"ifort-ps-doc-16.0.1-150.noarch.rpm")

		if use linguas_ja; then
			INTEL_DAT_RPMS+=(
				"ifort-ps-doc-jp-16.0.1-150.noarch.rpm")
		fi
	fi

	if use examples; then
		INTEL_DAT_RPMS+=(
			"fcomp-doc-2016.1-056.noarch.rpm")
	fi

	if use linguas_ja; then
		INTEL_BIN_RPMS+=(
			"ifort-l-ps-jp")
	fi

	intel-sdp-r1_pkg_setup
}
