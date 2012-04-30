# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

My_PN="gDEBugger"
My_PV=$(delete_all_version_separators)

DESCRIPTION="OpenCL and OpenGL debugger and memory analyzer"
HOMEPAGE="http://developer.amd.com/tools/gDEBugger/Pages/default.aspx"

if [[ "${ARCH}" == "amd64" ]]; then
    _arch="x86_64"
elif [[ "${ARCH}" == "x86" ]]; then
    _arch="x86"
fi

SRC_URI="
    x86?    ( http://developer.amd.com/Downloads/AMD${My_PN}${PV}x86.tar.gz )
    amd64?  ( http://developer.amd.com/Downloads/AMD${My_PN}${PV}x86_64.tar.gz )"

LICENSE="${My_PN}"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/libstdc++"
DEPEND="${RDEPEND}"

RESTRICT="mirror strip"

S="${WORKDIR}/${My_PN}${PV}-${_arch}"
_destination=/opt/${My_PN}

src_install() {
    dodir /usr/bin
    dodir /usr/share/applications

    cd ${WORKDIR}
    dodir `dirname ${_destination}`
    cp -a ${S} ${D}${_destination}

    # The included launcher gets the directory where it is being run; a symbolic
    # link to it in /usr/bin thus cannot work. Instead, copy it to /usr/bin and
    # remove the autodetection of the script's directory and hardcode it to ${_destination}.
    # Then create a lowercase symbolic link to this new launcher.
    cp ${D}${_destination}/${My_PN} ${D}/usr/bin/${My_PN}
    sed "s|gDEBuggerBinariesDir=.*|gDEBuggerBinariesDir=\"${_destination}\"|g" -i ${D}/usr/bin/${My_PN}
    dosym /usr/bin/${My_PN} /usr/bin/${PN}

    cat >> ${D}/usr/share/applications/${PN}.desktop <<- EOF
		[Desktop Entry]
		Name=${My_PN}
		Exec=${_destination}/${My_PN}
		Type=Application
		GenericName=OpenCL/OpenGL debugger
		Terminal=false
		Icon=${My_PN}
		Caption=OpenCL/OpenGL debugger
		Categories=Application;Development;
EOF

    insinto /usr/share/icons/hicolor/64x64/apps/
    newins ${D}${_destination}/tutorial/images/applicationicon_64.png ${My_PN}.png
}
