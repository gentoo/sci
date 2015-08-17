# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="Display, edit next-gen sequence alignment (BED, BLAST, Eland, mapview processed MAQ, Corona formats)"
HOMEPAGE="http://sourceforge.net/projects/ngsview"
SRC_URI="mirror://sourceforge/projects/${PN}/files/${PN}/${P}.tar.gz"

# http://ngsview.sourceforge.net/manual.html

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-gfx/graphviz
	sys-libs/db:*
	dev-qt/qtcore:4"
RDEPEND="${DEPEND}"

src_configure(){
	cd src/trapper || die "Cannot cd to src/trapper"
	eqmake4
}

src_compile() {
	cd src/trapper || die "Cannot cd to src/trapper"
	default
}
