# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=2987
INTEL_DPV=2013_update2
INTEL_SUBDIR=vtune_amplifier_xe

inherit intel-sdp multilib

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

INTEL_BIN_RPMS="vtune-amplifier-xe-gui"
INTEL_DAT_RPMS="vtune-amplifier-xe-gui-common"
#INTEL_RPMS_DIRS="rpm CLI_install/rpm"

create_bin_symlink() {
	_libdir=$(get_libdir)
	_arch=${_libdir/lib/}
	dosym /${INTEL_SDP_DIR}/bin${_arch}/${1} /opt/bin/${1}
}

src_install() {
	intel-sdp_src_install

	# Create symbolic links
	create_bin_symlink amplxe-gui
	create_bin_symlink amplxe-configurator

	make_desktop_entry amplxe-gui "VTune Amplifier XE" "" "Development;Debugger"
}
