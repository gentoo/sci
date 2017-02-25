# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs versionator

MY_PN=gDEBugger
MY_PV=$(delete_all_version_separators)
MY_P=${MY_PN}${PV}

DESCRIPTION="OpenCL and OpenGL debugger and memory analyzer"
HOMEPAGE="http://developer.amd.com/tools/gDEBugger/Pages/default.aspx"
SRC_URI="
	x86? ( http://developer.amd.com/Downloads/AMD${MY_P}x86.tar.gz )
	amd64? ( http://developer.amd.com/Downloads/AMD${MY_P}x86_64.tar.gz )"

LICENSE="gDEBugger"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="
	virtual/libstdc++
	dev-libs/atk
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:1.2
	media-libs/mesa
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/pango"

RESTRICT="mirror strip"

S=${WORKDIR}

QA_PREBUILT="
	/opt/${MY_PN}/libGROSWrappers.so
	/opt/${MY_PN}/libGRProcessDebugger.so
	/opt/${MY_PN}/libGRAPIClasses.so
	/opt/${MY_PN}/libgDEBuggerAppCode.so
	/opt/${MY_PN}/libGRApiFunctions.so
	/opt/${MY_PN}/libAMDTApplicationFramework.so
	/opt/${MY_PN}/libGRApplicationComponents.so
	/opt/${MY_PN}/libAMDTgDEBuggerAppWrapper.so
	/opt/${MY_PN}/libGRSpiesUtilities.so
	/opt/${MY_PN}/libGRBaseTools.so
	/opt/${MY_PN}/gDEBugger
"

src_prepare() {
	cat >> "${T}"/99${PN} <<- EOF
		PATH="/opt/${MY_PN}"
		LDPATH="/opt/${MY_PN}"
	EOF
}

src_install() {
	pushd ${MY_P}-$(tc-arch-kernel) &> /dev/null
	local _dest=/opt/${MY_PN}

	exeinto ${_dest}
	doexe $(find . -maxdepth 1 -type f -name '*.so*')
	for f in lib*.so.?.?.?; do
		dosym $f ${_dest}/${f%.?.?.?}
		dosym $f ${_dest}/${f%.?.?}
	done
	newexe ${MY_PN}-bin ${MY_PN}

	insinto ${_dest}
	doins -r Images webhelp	tutorial

	insinto ${_dest}/Legal
	doins Legal/EndUserLicenseAgreement.htm

	if use examples ; then
		insinto ${_dest}/examples
		doins -r examples/*
	fi

	newicon tutorial/images/applicationicon_64.png ${MY_PN}.png
	popd &> /dev/null

	doenvd "${T}"/99${PN}
	make_desktop_entry ${MY_PN} ${MY_PN} ${MY_PN} \
		"Application;Development"
}
