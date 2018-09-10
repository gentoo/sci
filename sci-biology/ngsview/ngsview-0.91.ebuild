# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Display, edit NGS alignments"
HOMEPAGE="http://sourceforge.net/projects/ngsview"
#SRC_URI="mirror://sourceforge/projects/${PN}/files/${PN}/${P}.tar.gz"
SRC_URI="https://sourceforge.net/projects/ngsview/files/ngsview/ngsview-0.91.tar.gz"

# http://ngsview.sourceforge.net/about.html
#   a qt3 package needs >=sys-libs/db-4.3:*[cxx]
# http://ngsview.sourceforge.net/manual.html

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-gfx/graphviz
	>=sys-libs/db-4.3:*[cxx]
	dev-qt/qtcore:5"
RDEPEND="${DEPEND}"

src_configure(){
	cd src/trapper || die "Cannot cd to src/trapper"
	/usr/lib/qt5/bin/qmake || die
}

src_compile() {
	cd src/trapper || die "Cannot cd to src/trapper"
	default
}
