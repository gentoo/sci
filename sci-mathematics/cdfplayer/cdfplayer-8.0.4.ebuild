# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

MY_SCRIPT=CDFPlayer_${PV}_LINUX.sh

DESCRIPTION="Player for Wolfram CDF"
HOMEPAGE="http://www.wolfram.com/cdf-player/"
SRC_URI="http://www.wolfram.com/cdf-player/${MY_SCRIPT}"
LICENSE="cdfplayer"

SLOT="0"
KEYWORDS="~x86"

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
	mkdir -p "${ED}/usr/share/applications" || die
	cp "${ED}/opt/wolfram/SystemFiles/Installation/wolfram-cdf8.desktop" \
		"${ED}/usr/share/applications" || die
}
