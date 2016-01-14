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

DESCRIPTION="Common libraries and utilities needed for Intel compilers and libraries"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-compilers/"

IUSE="+compiler"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

CHECKREQS_DISK_BUILD=375M

INTEL_BIN_RPMS=(
	"openmp-l-all"
	"openmp-l-ps")
INTEL_DAT_RPMS=(
	"comp-l-all-common"
	"ccompxe-2016.1-056.noarch.rpm"
	"compxe-2016.1-056.noarch.rpm"
	"fcompxe-2016.1-056.noarch.rpm")

INTEL_X86_RPMS=(
	"openmp-l-ps-jp"
	"comp-l-all-32")
INTEL_AMD64_RPMS=(
	"openmp-l-ps-devel"
	"openmp-l-ps-devel-jp"
	"openmp-l-ps-mic"
	"openmp-l-ps-ss")

pkg_setup() {
	if use compiler; then
		INTEL_BIN_RPMS+=(
			"openmp-l-all-devel"
			"comp-l-all-devel"
			"comp-l-ps-ss-devel")
		INTEL_DAT_RPMS+=(
			"comp-l-all-vars")

		INTEL_X86_RPMS+=(
			"comp-l-ps-ss-wrapper")
		INTEL_AMD64_RPMS+=(
			"openmp-l-ps-mic-devel"
			"openmp-l-ps-mic-devel-jp"
			"openmp-l-ps-ss-devel"
			"comp-l-ps-devel")
	fi
	intel-sdp-r1_pkg_setup
}

src_install() {
	intel-sdp-r1_src_install
	local path rootpath ldpath arch fenv=35intelsdp
	cat > ${fenv} <<-EOF
		NLSPATH=${INTEL_SDP_R1_EDIR}/lib/locale/en_US/%N
		INTEL_LICENSE_FILE="${INTEL_SDP_R1_EDIR}"/licenses:"${EPREFIX}/opt/intel/license"
	EOF
	for arch in ${INTEL_ARCH}; do
			path=${path}:${INTEL_SDP_R1_EDIR}/linux/bin/${arch}:${INTEL_SDP_R1_EDIR}/mpirt/bin/${arch}
			rootpath=${rootpath}:${INTEL_SDP_R1_EDIR}/linux/bin/${arch}:${INTEL_SDP_R1_EDIR}/mpirt/bin/${arch}
			ldpath=${ldpath}:${INTEL_SDP_R1_EDIR}/linux/compiler/lib/${arch}:${INTEL_SDP_R1_EDIR}/mpirt/lib/${arch}
	done
	cat >> ${fenv} <<-EOF
		PATH=${path#:}
		ROOTPATH=${rootpath#:}
		LDPATH=${ldpath#:}
	EOF

	doenvd ${fenv}

	cat >> "${T}"/40-${PN} <<- EOF
	SEARCH_DIRS_MASK="${INTEL_SDP_R1_EDIR}"
	EOF
	insinto /etc/revdep-rebuild/
	doins "${T}"/40-${PN}
}
