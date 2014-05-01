# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Display and edit next-gen sequence alignment (BED, BLAST, Eland, mapview processed MAQ, Corona formats)"
HOMEPAGE="http://sourceforge.net/projects/ngsview"
SRC_URI="http://sourceforge.net/projects/ngsview/files/ngsview/ngsview-0.91.tar.gz"

# http://ngsview.sourceforge.net/manual.html

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-gfx/graphviz
		>=sys-libs/db-4.3
		>=dev-qt/qtcore-4"
RDEPEND="${DEPEND}"

src_compile(){
	cd src/trapper || die "Cannot cd to src/trapper"
	qmake || die
	make || die
}
