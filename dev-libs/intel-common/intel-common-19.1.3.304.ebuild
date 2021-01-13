# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

INTEL_DIST_NAME=system_studio
INTEL_DIST_PV=2020_u3_ultimate_edition_offline
INTEL_DIST_TARX=tar.gz
INTEL_DIST_MINOR=4
INTEL_RPMS_DIR=pset/yum.cache/l_comp_lib_p_2020.4.304

INTEL_PID=17148		# from registration center

inherit intel-sdp-r2

DESCRIPTION="Common libraries and utilities needed for Intel compilers and libraries"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-compilers/"
SRC_URI="https://registrationcenter-download.intel.com/akdlm/irc_nas/${INTEL_PID}/${INTEL_DIST_NAME}_${INTEL_DIST_PV}.tar.gz"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+compiler doc +openmp"

RESTRICT=${RESTRICT//fetch/}

MY_PV="$(ver_rs 3 '-')"                             # 19.1.3-304
MY_PV2="$(ver_cut 1-2)"                             # 19.1
MY_PV3="2020"                                       # 2020
MY_PV4="${MY_PV3}.${INTEL_DIST_MINOR}.$(ver_cut 4)" # 2020.4-304 sic!

CHECKREQS_DISK_BUILD=750M

QA_PREBUILT="*"

INTEL_DIST_BIN_RPMS=()
INTEL_DIST_DAT_RPMS=(
	"c-comp-common-${MY_PV}-${MY_PV}.noarch.rpm"
	"comp-l-all-common-${MY_PV}-${MY_PV}.noarch.rpm"
	"comp-l-all-vars-${MY_PV}-${MY_PV}.noarch.rpm"
	"comp-nomcu-vars-${MY_PV}-${MY_PV}.noarch.rpm"
)
INTEL_DIST_X86_RPMS=(
	"comp-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"comp-ps-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
	"comp-ps-ss-bec-32bit-${MY_PV}-${MY_PV}.x86_64.rpm"
)
INTEL_DIST_AMD64_RPMS=(
	"comp-${MY_PV}-${MY_PV}.x86_64.rpm"
	"comp-ps-${MY_PV}-${MY_PV}.x86_64.rpm"
	"comp-ps-ss-bec-${MY_PV}-${MY_PV}.x86_64.rpm"
)

pkg_setup() {
	if use doc; then
		INTEL_DIST_DAT_RPMS+=( "comp-doc-${MY_PV2}-${MY_PV}.noarch.rpm" )
	fi

	if use openmp; then
		INTEL_DIST_DAT_RPMS+=( "openmp-common-${MY_PV}-${MY_PV}.noarch.rpm" )
		INTEL_DIST_AMD64_RPMS+=( "openmp-${MY_PV}-${MY_PV}.x86_64.rpm" )
		INTEL_DIST_X86_RPMS+=( "openmp-32bit-${MY_PV}-${MY_PV}.x86_64.rpm" )

		if use compiler; then
			INTEL_DIST_DAT_RPMS+=(
				"openmp-common-icc-${MY_PV}-${MY_PV}.noarch.rpm")
		fi
	fi
}

src_install() {
	intel-sdp-r2_src_install
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
