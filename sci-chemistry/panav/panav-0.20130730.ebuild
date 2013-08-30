# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2

MY_PN="PANAV"

DESCRIPTION="Probabilistic approach for validating protein NMR chemical shift assignments"
HOMEPAGE="http://link.springer.com/article/10.1007%2Fs10858-010-9407-y/fulltext.html"
SRC_URI="http://www.wishartlab.com/download/${MY_PN}.zip -> ${P}.zip"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-java/cos
	>=virtual/jre-1.6"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_PN}

src_compile() { :; }

src_install() {
	java-pkg_newjar ${MY_PN}.jar ${PN}.jar
	java-pkg_dolauncher
	java-pkg_regjar "${EPREFIX}"/usr/share/cos/lib/cos.jar
	dodoc README
}
