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
	mkdir "${S}"
	cp "${DISTDIR}/${MY_SCRIPT}" "${S}/${MY_SCRIPT}"
	chmod u+x "${S}/${MY_SCRIPT}"
}

src_prepare() {
	epatch "${FILESDIR}/${P}-installer.patch"
}

src_install() {
	"${S}/${MY_SCRIPT}" --target "${S}/${P}" -- -auto -verbose -createdir=y \
		-targetdir="${D}/opt" -execdir="${D}/usr/bin"
}
