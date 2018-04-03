# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

INTEL_DIST_SKU=3235
INTEL_DIST_PV=2018_update2_professional_edition

inherit intel-sdp-r1

DESCRIPTION="Common libraries and utilities needed for Intel compilers and libraries"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-compilers/"

IUSE="+compiler doc +mpi +openmp"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

CHECKREQS_DISK_BUILD=750M

INTEL_DIST_BIN_RPMS=()
INTEL_DIST_DAT_RPMS=(
	"c-comp-common-18.0.2-199-18.0.2-199.noarch.rpm"
	"comp-l-all-common-18.0.2-199-18.0.2-199.noarch.rpm"
	"comp-l-all-vars-18.0.2-199-18.0.2-199.noarch.rpm"
	"comp-nomcu-vars-18.0.2-199-18.0.2-199.noarch.rpm")
INTEL_DIST_X86_RPMS=(
	"comp-32bit-18.0.2-199-18.0.2-199.x86_64.rpm"
	"comp-ps-32bit-18.0.2-199-18.0.2-199.x86_64.rpm"
	"comp-ps-ss-bec-32bit-18.0.2-199-18.0.2-199.x86_64.rpm")
INTEL_DIST_AMD64_RPMS=(
	"comp-18.0.2-199-18.0.2-199.x86_64.rpm"
	"comp-ps-18.0.2-199-18.0.2-199.x86_64.rpm"
	"comp-ps-ss-18.0.2-199-18.0.2-199.x86_64.rpm"
	"comp-ps-ss-bec-18.0.2-199-18.0.2-199.x86_64.rpm")

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "comp-doc-18.0-18.0.2-199.noarch.rpm" )
	fi

	if use mpi; then
		INTEL_DIST_AMD64_RPMS+=( "mpi-rt-2018.2-199-2018.2-199.x86_64.rpm" )

		if use doc; then
			INTEL_DIST_DAT_RPMS+=( "mpi-doc-2018-2018.2-199.x86_64.rpm" )
		fi
	fi

	if use openmp; then
		INTEL_DIST_DAT_RPMS+=( "openmp-common-18.0.2-199-18.0.2-199.noarch.rpm" )
		INTEL_DIST_AMD64_RPMS+=( "openmp-18.0.2-199-18.0.2-199.x86_64.rpm" )
		INTEL_DIST_X86_RPMS+=( "openmp-32bit-18.0.2-199-18.0.2-199.x86_64.rpm" )

		if use compiler; then
			INTEL_DIST_DAT_RPMS+=(
				"openmp-common-icc-18.0.2-199-18.0.2-199.noarch.rpm"
				"openmp-common-ifort-18.0.2-199-18.0.2-199.noarch.rpm")
			INTEL_DIST_AMD64_RPMS+=(
				"openmp-ifort-18.0.2-199-18.0.2-199.x86_64.rpm")
			INTEL_DIST_X86_RPMS+=(
				"openmp-ifort-32bit-18.0.2-199-18.0.2-199.x86_64.rpm")
		fi
	fi
}

src_install() {
	intel-sdp-r1_src_install
	local path rootpath ldpath arch fenv=35intelsdp
	cat > ${fenv} <<-EOF
		NLSPATH=$(isdp_get-sdp-edir)/linux/compiler/lib/$(isdp_get-native-abi-arch)/locale/en_US/%N
		INTEL_LICENSE_FILE=${EPREFIX%/}/opt/intel/licenses:$(isdp_get-sdp-edir)/licenses
	EOF
	for arch in $(isdp_get-sdp-installed-arches); do
		path="${path}:$(isdp_get-sdp-edir)/linux/bin/${arch}"
		rootpath="${rootpath}:$(isdp_get-sdp-edir)/linux/bin/${arch}"
		ldpath="${ldpath}:$(isdp_get-sdp-edir)/linux/compiler/lib/${arch}"
	done
	if use mpi && use amd64; then
		path="${path}:$(isdp_get-sdp-edir)/linux/mpi/intel64/bin/"
		rootpath="${rootpath}:$(isdp_get-sdp-edir)/linux/mpi/intel64/bin/"
		ldpath="${ldpath}:$(isdp_get-sdp-edir)/linux/mpi/intel64/lib/"
	fi
	cat >> ${fenv} <<-EOF
		PATH=${path#:}
		ROOTPATH=${rootpath#:}
		LDPATH=${ldpath#:}
	EOF

	doenvd ${fenv}

	cat >> "${T}"/40-${PN} <<- EOF
	SEARCH_DIRS_MASK=$(isdp_get-sdp-edir)
	EOF
	insinto /etc/revdep-rebuild/
	doins "${T}"/40-${PN}
}
