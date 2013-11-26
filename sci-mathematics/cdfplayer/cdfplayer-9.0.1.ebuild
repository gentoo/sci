# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

MY_SCRIPT=CDFPlayer_${PV}_LINUX.sh
MY_DESKTOPFILE=${ED}/opt/wolfram/SystemFiles/Installation/wolfram-cdf9.desktop

DESCRIPTION="Player for Wolfram CDF"
HOMEPAGE="http://www.wolfram.com/cdf-player/"
SRC_URI="http://www.wolfram.com/cdf-player/${MY_SCRIPT}"
LICENSE="cdfplayer"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="fetch test"

pkg_nofetch() {
	einfo Download ${MY_SCRIPT} from ${HOMEPAGE}
	einfo and move it to ${DISTDIR}
}

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}/${MY_SCRIPT}" "${S}/${MY_SCRIPT}" || die
	chmod u+x "${S}/${MY_SCRIPT}" || die
}

src_prepare() {
	epatch "${FILESDIR}/${P}-installer.patch"
}

src_install() {
	"${S}/${MY_SCRIPT}" --target "${S}/${P}" -- -auto -verbose -createdir=y \
		-targetdir="${ED}/opt/wolfram" -execdir="${ED}/usr/bin" || die
	find "${ED}" -name '*.desktop' -exec \
		sed -i "s%${ED}%/%g" {} \; || die
	sed -i "s/WolframCDFPlayer %F/WolframCDFPlayer -graphicssystem native %F/g" \
		"${MY_DESKTOPFILE}" \
		|| die
	mkdir -p "${ED}/usr/share/applications" || die
	domenu "${MY_DESKTOPFILE}"
}

pkg_postinst() {
	elog "If you want to start CDFPlayer from command line"
	elog "you will need to set your qtgraphicssystem to native"
	elog "or start CDFPlayer with the '-graphicssystem native' option"
	elog "see http://forums.gentoo.org/viewtopic-p-7202068.html for details."
}
