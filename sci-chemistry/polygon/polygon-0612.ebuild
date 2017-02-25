# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

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
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tcl"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack ${DB}.zip
	cp "${DISTDIR}"/${MY_P}.tcl "${S}" || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-db.patch
}

src_install() {
	edos2unix ${MY_P}.tcl
	newbin ${MY_P}.tcl ${PN}
	insinto /usr/share/${PN}
	doins ${DB}.txt
}
