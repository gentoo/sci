# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${PN}404"

DESCRIPTION="Tandem Repeats Finder"
HOMEPAGE="http://tandem.bu.edu/trf/trf.html"
SRC_URI="
	http://tandem.bu.edu/trf/downloads/${MY_P}.linux
	http://tandem.bu.edu/trf/trf.unix.help.html
	http://tandem.bu.edu/trf/trf.definitions.html
	http://tandem.bu.edu/trf/trf.whatnew.html"

LICENSE="trf"	# http://tandem.bu.edu/trf/trf.license.html
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

S="${WORKDIR}"

QA_PREBUILT="opt/${PN}/.*"

src_unpack() {
	cp "${DISTDIR}/${MY_P}.linux" "${S}/${MY_P}.linux.exe" || die
}

src_install() {
	exeinto /opt/${PN}
	doexe trf404.linux.exe
	dosym ../${PN}/${MY_P}.linux.exe /opt/bin/trf
	# GTK version (http://tandem.bu.edu/trf/downloads/trf400.linuxgtk.exe) has broken linking
	#if use gtk; then
	#	doexe trf400.linuxgtk.exe
	#	make_desktop_entry /opt/${PN}/trf400.linuxgtk.exe "Tandem Repeats Finder" || die
	#fi
	dodoc \
		"${DISTDIR}/"trf.unix.help.html \
		"${DISTDIR}/"trf.definitions.html \
		"${DISTDIR}/"trf.whatnew.html
}
