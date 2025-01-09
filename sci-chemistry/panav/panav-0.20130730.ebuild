# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PN="PANAV"

DESCRIPTION="Probabilistic approach for validating protein NMR chemical shift assignments"
HOMEPAGE="https://link.springer.com/article/10.1007%2Fs10858-010-9407-y/fulltext.html"
SRC_URI="https://www.wishartlab.com/download/${MY_PN}.zip -> ${P}.zip"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.7:*"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"/${MY_PN}

src_compile() {
	return
}

src_install() {
	java-pkg_newjar ${MY_PN}.jar ${PN}.jar
	java-pkg_dolauncher
	dodoc README
}
