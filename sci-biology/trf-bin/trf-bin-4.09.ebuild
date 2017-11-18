# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_PV="${PV/.}" # drop the dot
MY_PN="trf"
MY_P="trf${MY_PV}"

DESCRIPTION="Tandem Repeats Finder"
HOMEPAGE="http://tandem.bu.edu/trf/trf.html"
SRC_URI="
	amd64? ( http://tandem.bu.edu/trf/downloads/${MY_P}.linux64 )
	x86? ( http://tandem.bu.edu/trf/downloads/${MY_P}.linux32 )"
# trf: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by trf)

LICENSE="trf"	# http://tandem.bu.edu/trf/trf.license.html
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

S="${WORKDIR}"

QA_PREBUILT="opt/${MY_PN}/.*"

src_unpack() {
	if use x86; then
		cp "${DISTDIR}/${MY_P}".linux32 "${S}/${MY_PN}" || die
	elif use amd64; then
		cp "${DISTDIR}/${MY_P}".linux64 "${S}/${MY_PN}" || die
	else
		eerror "Unsupported platform, check http://tandem.bu.edu/trf/downloads/"
	fi
	default
}

src_install() {
	exeinto /opt/"${MY_PN}"/bin
	doexe "${MY_PN}"
	dosym ../"${MY_PN}"/bin/"${MY_PN}" /opt/bin/"${MY_PN}"
	# GTK version (http://tandem.bu.edu/trf/downloads/trf400.linuxgtk.exe) has broken linking
	#if use gtk; then
	#	doexe trf400.linuxgtk.exe
	#	make_desktop_entry /opt/${PN}/trf400.linuxgtk.exe "Tandem Repeats Finder" || die
	#fi
	# http://tandem.bu.edu/trf/trf.unix.help.html
	# http://tandem.bu.edu/trf/trf.definitions.html
	# http://tandem.bu.edu/trf/trf.whatnew.html
	dodoc \
		"${FILESDIR}/"trf.txt \
		"${FILESDIR}/"trf.definitions.txt \
		"${FILESDIR}/"trf.whatsnew.txt
}
