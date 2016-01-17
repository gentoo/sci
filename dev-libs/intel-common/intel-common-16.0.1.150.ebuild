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

IUSE="+compiler doc examples mpi openmp linguas_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

CHECKREQS_DISK_BUILD=375M

INTEL_BIN_RPMS=()
INTEL_DAT_RPMS=(
	"ccompxe-2016.1-056.noarch.rpm"
	"comp-l-all-common"
	"comp-l-all-vars"
	"comp-l-ps-common")
INTEL_X86_RPMS=(
	"comp-l-all-32"
	"comp-l-ps-ss-wrapper")
INTEL_AMD64_RPMS=()

pkg_setup() {
	if use doc; then
		INTEL_DAT_RPMS+=(
			"comp-all-doc-16.0.1-150.noarch.rpm"
			"comp-ps-ss-doc-16.0.1-150.noarch.rpm"
			"ccompxe-doc-2016.1-056.noarch.rpm")

		if use linguas_ja; then
			INTEL_DAT_RPMS+=(
				"comp-ps-doc-jp-16.0.1-150.noarch.rpm")
		fi
	fi

	if use examples; then
		INTEL_DAT_RPMS+=(
			"ccomp-doc-2016.1-056.noarch.rpm")
	fi

	if use mpi; then
		INTEL_X86_RPMS+=(
			"mpirt-l-ps-150-16.0.1-150.i486.rpm")
		INTEL_AMD64_RPMS+=(
			"mpi-psxe-056-5.1.2-056.x86_64.rpm"
			"mpi-rt-core-150-5.1.2-150.x86_64.rpm"
			"mpi-rt-core-150-5.1.2-150.x86_64.rpm"
			"mpi-rt-mic-150-5.1.2-150.x86_64.rpm"
			"mpi-sdk-core-150-5.1.2-150.x86_64.rpm"
			"mpi-sdk-mic-150-5.1.2-150.x86_64.rpm")

		if use doc; then
			INTEL_AMD64_RPMS+=(
				"mpi-doc-5.1.2-150.x86_64.rpm")
		fi
	fi

	if use openmp; then
		INTEL_BIN_RPMS+=(
			"openmp-l-all"
			"openmp-l-ps")
		INTEL_AMD64_RPMS+=(
			"openmp-l-ps-ss"
			"openmp-l-ps-mic")

		if use compiler; then
			INTEL_BIN_RPMS+=(
				"openmp-l-all-devel")
			INTEL_AMD64_RPMS+=(
				"openmp-l-ps-devel"
				"openmp-l-ps-ss-devel"
				"openmp-l-ps-mic-devel")
			
			if use linguas_ja; then
				INTEL_AMD64_RPMS+=(
					"openmp-l-ps-devel-jp"
					"openmp-l-ps-mic-devel-jp")
			fi
		fi

		if use linguas_ja; then
			INTEL_X86_RPMS+=(
				"openmp-l-ps-jp")
		fi
	fi

	if use compiler; then
		INTEL_BIN_RPMS+=(
			"comp-l-all-devel"
			"comp-l-ps-ss-devel")
		INTEL_AMD64_RPMS+=(
			"comp-l-ps-devel")
	fi
	intel-sdp-r1_pkg_setup
}

src_install() {
	intel-sdp-r1_src_install
	local path rootpath ldpath arch fenv=35intelsdp
	cat > ${fenv} <<-EOF
		NLSPATH=${INTEL_SDP_EDIR}/lib/locale/en_US/%N
		INTEL_LICENSE_FILE="${INTEL_SDP_EDIR}"/licenses:"${EPREFIX}/opt/intel/license"
	EOF
	for arch in ${INTEL_ARCH}; do
		path=${path}:${INTEL_SDP_EDIR}/linux/bin/${arch}
		rootpath=${rootpath}:${INTEL_SDP_EDIR}/linux/bin/${arch}
		ldpath=${ldpath}:${INTEL_SDP_EDIR}/linux/compiler/lib/${arch}
	done
	if use mpi && use amd64; then
		path=${path}:${INTEL_SDP_EDIR}/linux/mpi/intel64/bin/
		rootpath=${rootpath}:${INTEL_SDP_EDIR}/linux/mpi/intel64/bin/
		ldpath=${ldpath}:${INTEL_SDP_EDIR}/linux/mpi/intel64/lib/
	fi
	cat >> ${fenv} <<-EOF
		PATH=${path#:}
		ROOTPATH=${rootpath#:}
		LDPATH=${ldpath#:}
	EOF

	doenvd ${fenv}

	cat >> "${T}"/40-${PN} <<- EOF
	SEARCH_DIRS_MASK="${INTEL_SDP_EDIR}"
	EOF
	insinto /etc/revdep-rebuild/
	doins "${T}"/40-${PN}
}
