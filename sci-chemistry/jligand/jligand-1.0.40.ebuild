# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN="JLigand"

DESCRIPTION="Java interface which allows links descriptions to be created"
HOMEPAGE="http://www.ysbl.york.ac.uk/mxstat/JLigand/"
SRC_URI="http://www.ysbl.york.ac.uk/mxstat/${MY_PN}/${MY_PN}.${PV}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${MY_PN}.${PV}"

src_compile() {
	sed 's:makefile::g' -i Makefile || die
	default
}

src_install() {
	java-pkg_newjar JLigand.jar "${PN}.jar"
	java-pkg_dolauncher JLigand \
		--jar "${PN}.jar"
}
