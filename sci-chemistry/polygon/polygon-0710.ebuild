# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DB="pdb_2009-04-29_ord"
MY_P="${PN}${PV}"

DESCRIPTION="shows qualitatively if some models parameters are over- or under-refined"
HOMEPAGE="http://www-ibmc.u-strasbg.fr/arn/Site_UPR9002/Polygon/Polygon.html"
SRC_URI="
	http://www-ibmc.u-strasbg.fr/arn/Site_UPR9002/Polygon/${MY_P}.tcl
	http://www-ibmc.u-strasbg.fr/arn/Site_UPR9002/Polygon/${DB}.zip
"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
IUSE=""

RDEPEND="dev-lang/tcl"
DEPEND="app-arch/unzip"

src_unpack() {
	unpack ${DB}.zip
	cp "${DISTDIR}"/${MY_P}.tcl "${WORKDIR}"
	cd "${WORKDIR}"
	epatch "${FILESDIR}"/${PV}-db.patch
}

src_install() {
	edos2unix ${MY_P}.tcl
	newbin ${MY_P}.tcl ${PN} || die
	insinto /usr/share/${PN}
	doins ${DB}.txt || die
}
