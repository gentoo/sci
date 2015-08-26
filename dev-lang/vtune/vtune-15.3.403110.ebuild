# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=7538
INTEL_DPV=2015_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false
INTEL_SDP_DIR=opt/intel/

inherit intel-sdp multilib

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

INTEL_BIN_RPMS=(
	vtune-amplifier-xe-2015-cli
	vtune-amplifier-xe-2015-gui
	)
INTEL_AMD64_RPMS=(
	vtune-amplifier-xe-2015-collector-64linux
	)
INTEL_X86_RPMS=(
	vtune-amplifier-xe-2015-collector-32linux
	)
INTEL_DAT_RPMS=(
	vtune-amplifier-xe-2015-cli-common
	vtune-amplifier-xe-2015-common
	vtune-amplifier-xe-2015-common-pset
	vtune-amplifier-xe-2015-doc
	vtune-amplifier-xe-2015-gui-common
	vtune-amplifier-xe-2015-sep
	)

src_install() {
	intel-sdp_src_install

	cat >> "${T}"/50vtune <<- EOF
	PATH=${INTEL_SDP_EDIR}/bin64:${INTEL_SDP_EDIR}/bin32
	EOF
	doenvd "${T}"/50vtune

	make_desktop_entry amplxe-gui "VTune Amplifier XE" "" "Development;Debugger"
}
