# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

inherit eutils

src_unpack() {
	unpack $A || die "Unpacking $A failed"
	cd "${WORKDIR}"
	unpack ./data.tar.gz
	epatch "$FILESDIR/geogebra_use_opt.patch"
}

src_compile() {
	rm *.tar.gz debian-binary || die
	mv usr opt || die
}

src_install() {
	cp -r "${WORKDIR}"/* "${D}" || die
}
