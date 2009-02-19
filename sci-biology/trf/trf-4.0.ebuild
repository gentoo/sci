# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Tandem Repeats Finder"
HOMEPAGE="http://tandem.bu.edu/trf/trf.html"
SRC_URI="http://tandem.bu.edu/trf/downloads/trf400.linux.exe"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""
# gtk? ( x11-libs/gtk+ ) x11-libs/pango[X]

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/trf400.linux.exe" "${S}"
}

src_install() {
	exeinto /opt/${PN}
	doexe trf400.linux.exe || die
	dosym /opt/${PN}/trf400.linux.exe /usr/bin/trf || die
	# GTK version (http://tandem.bu.edu/trf/downloads/trf400.linuxgtk.exe) has broken linking
	#if use gtk; then
	#	doexe trf400.linuxgtk.exe || die
	#	make_desktop_entry /opt/${PN}/trf400.linuxgtk.exe "Tandem Repeats Finder" || die
	#fi
}
