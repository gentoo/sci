# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

INTEL_DPN=vtune_amplifier_xe
INTEL_DID=3290
INTEL_DPV=2013_update10
INTEL_SUBDIR=vtune_amplifier_xe
INTEL_TARX=tar.gz
INTEL_SINGLE_ARCH=false

inherit intel-sdp multilib

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

INTEL_BIN_RPMS="vtune-amplifier-xe-gui CLI_install/rpm/intel-vtune-amplifier-xe-cli"
INTEL_DAT_RPMS="vtune-amplifier-xe-gui-common CLI_install/rpm/intel-vtune-amplifier-xe-cli-common"

src_install() {
	intel-sdp_src_install

	cat >> "${T}"/50vtune <<- EOF
	PATH=${INTEL_SDP_EDIR}/bin64:${INTEL_SDP_EDIR}/bin32
	EOF
	doenvd "${T}"/50vtune

	make_desktop_entry amplxe-gui "VTune Amplifier XE" "" "Development;Debugger"
}
