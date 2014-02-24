# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Free mathematics software for learning and teaching"
HOMEPAGE="http://geogebra.org/"
SRC_URI="
	x86? ( http://www.geogebra.net/linux/pool/main/g/geogebra44/geogebra44_4.4.12.0-32376_i386.deb )
	amd64? ( http://www.geogebra.net/linux/pool/main/g/geogebra44/geogebra44_4.4.12.0-32376_amd64.deb )
"

LICENSE="GeoGebra"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jre-1.6.0"
RDEPEND="$DEPEND"

S="${WORKDIR}"

src_unpack() {
	default
	cd "${WORKDIR}" || die
	unpack ./data.tar.gz
}

src_prepare(){
	rm *.tar.gz debian-binary || die
	mv usr opt || die
	epatch "$FILESDIR/geogebra_use_opt.patch"
}

src_install() {
	cp -r "${WORKDIR}"/* "${D}" || die
}
