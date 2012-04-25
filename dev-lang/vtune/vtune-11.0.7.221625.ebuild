# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="primaryuri"

EAPI=4

INTEL_DPN=vtune_amplifier_xe
INTEL_DID=2526
INTEL_DPV=2011_update8
INTEL_SUBDIR=vtune_amplifier_xe

inherit intel-sdp

DESCRIPTION="Intel VTune Amplifier XE"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-vtune-amplifier-xe/"
SRC_URI="http://registrationcenter-download.intel.com/akdlm/irc_nas/${INTEL_DID}/${INTEL_DPN}_${INTEL_DPV}.tar.gz"

IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="
    ${INTEL_SDP_DIR}/bin32/*
    ${INTEL_SDP_DIR}/bin64/*
    ${INTEL_SDP_DIR}/lib32/*
    ${INTEL_SDP_DIR}/lib64/*"
QA_PRESTRIPPED="
    ${INTEL_SDP_DIR}/bin32/*
    ${INTEL_SDP_DIR}/bin64/*
    ${INTEL_SDP_DIR}/lib32/*
    ${INTEL_SDP_DIR}/lib64/*"

INTEL_BIN_RPMS="vtune-amplifier-xe-cli vtune-amplifier-xe-gui"
INTEL_DAT_RPMS="vtune-amplifier-xe-sep vtune-amplifier-xe-pwr vtune-amplifier-xe-cli-common vtune-amplifier-xe-common vtune-amplifier-xe-doc vtune-amplifier-xe-gui-common"
INTEL_RPMS_DIRS="rpm CLI_install/rpm"


create_bin_symlink() {
    _libdir=$(get_libdir)
    _arch=${_libdir/lib/}
    dosym /${INTEL_SDP_DIR}/bin${_arch}/${1} /usr/bin/
}

src_install() {
    intel-sdp_src_install

    # Create symbolic links
    create_bin_symlink amplxe-gui
    create_bin_symlink amplxe-cl
    create_bin_symlink amplxe-configurator
    create_bin_symlink amplxe-feedback
    create_bin_symlink amplxe-runsa
    create_bin_symlink amplxe-runss

    # Create desktop file
    insinto /usr/share/pixmaps/
    newins ${D}/${INTEL_SDP_DIR}/documentation/en/help/GUID-A894E299-C7E2-4635-AD52-D98A09736EC8-low.jpg vtune.jpg
    dodir /usr/share/applications
    echo "[Desktop Entry]
Encoding=UTF-8
Name=VTune Amplifier XE
GenericName=VTune Amplifier XE
Comment=VTune Amplifier XE
Type=Application
Exec=amplxe-gui
Icon=vtune
Categories=Development;Debugger;" > ${D}/usr/share/applications/vtune.desktop || die "Can't create desktop file!"
}
