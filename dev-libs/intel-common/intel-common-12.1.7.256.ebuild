# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2405
INTEL_DPV=2011_sp1_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Common libraries and utilities needed for Intel compilers and libraries"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-compilers/"

IUSE="+compiler"

QA_PREBUILT="
	${INTEL_SDP_DIR}/compiler/lib/*/*
	${INTEL_SDP_DIR}/bin/sourcechecker/*/*/*
	${INTEL_SDP_DIR}/bin/*/*"

QA_PRESTRIPPED="
	${INTEL_SDP_DIR}/compiler/lib/*/.*libFNP.so
	${INTEL_SDP_DIR}/bin/sourcechecker/lib/*/pinruntime/.*
	${INTEL_SDP_DIR}/bin/sourcechecker/*/*/.*"

pkg_setup() {
	einfo ${INTEL_SDP_DIR}
	INTEL_BIN_RPMS="openmp openmp-devel"
	INTEL_DAT_RPMS="compilerpro-common"
	if use compiler; then
		INTEL_BIN_RPMS="${INTEL_BIN_RPMS} compilerpro-devel sourcechecker-devel"
		INTEL_DAT_RPMS="${INTEL_DAT_RPMS} compilerpro-vars sourcechecker-common"
	fi
	intel-sdp_pkg_setup
}

src_install() {
	intel-sdp_src_install
	local path rootpath ldpath arch fenv=35intelsdp
	cat > ${fenv} <<-EOF
		NLSPATH=${INTEL_SDP_EDIR}/lib/locale/en_US/%N
		MANPATH=${INTEL_SDP_EDIR}/man/en_US
		INTEL_LICENSE_FILE=${INTEL_SDP_EDIR}/licenses
	EOF
	for arch in ${INTEL_ARCH}; do
			path=${path}:${INTEL_SDP_EDIR}/bin/${arch}:${INTEL_SDP_EDIR}/mpirt/bin/${arch}
			rootpath=${rootpath}:${INTEL_SDP_EDIR}/bin/${arch}:${INTEL_SDP_EDIR}/mpirt/bin/${arch}
			ldpath=${ldpath}:${INTEL_SDP_EDIR}/compiler/lib/${arch}:${INTEL_SDP_EDIR}/mpirt/lib/${arch}
	done
	cat >> ${fenv} <<-EOF
		PATH=${path#:}
		ROOTPATH=${rootpath#:}
		LDPATH=${ldpath#:}
	EOF

	doenvd ${fenv}
	dodir ${INTEL_SDP_DIR}/licenses
}
