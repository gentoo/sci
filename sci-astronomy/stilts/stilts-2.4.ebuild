# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2

DESCRIPTION="Command line tools to process astronomical tables"
HOMEPAGE="http://www.star.bris.ac.uk/~mbt/stilts/"
SRC_URI="ftp://andromeda.star.bris.ac.uk/pub/star/${PN}/v${PV}/${PN}.jar -> ${P}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=""

src_install() {
	java-pkg_newjar "${DISTDIR}"/${P}.jar
	java-pkg_dolauncher ${PN}
}
