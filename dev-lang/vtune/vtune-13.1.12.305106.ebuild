# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=3447
INTEL_DPV=2013_sp1
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp multilib

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

INTEL_BIN_RPMS="
	vtune-amplifier-xe-cli
	vtune-amplifier-xe-collector-linux
	vtune-amplifier-xe-gui"
INTEL_DAT_RPMS="
	vtune-amplifier-xe-cli-common
	vtune-amplifier-xe-common
	vtune-amplifier-xe-common-pset
	vtune-amplifier-xe-doc
	vtune-amplifier-xe-gui-common
	vtune-amplifier-xe-pwr
	vtune-amplifier-xe-sep"

src_install() {
	intel-sdp_src_install

	cat >> "${T}"/50vtune <<- EOF
	PATH=${INTEL_SDP_EDIR}/bin64:${INTEL_SDP_EDIR}/bin32
	EOF
	doenvd "${T}"/50vtune

	make_desktop_entry amplxe-gui "VTune Amplifier XE" "" "Development;Debugger"
}
