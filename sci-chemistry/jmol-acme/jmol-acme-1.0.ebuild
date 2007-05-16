# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

MY_P="Acme"

# It proved difficult to recompile the whole Acme package, so we'll only take what we need.

DESCRIPTION="Portions of the Acme collection required for jMol. Courtesy of ACME - Purveyors of fine freeware since 1972."
HOMEPAGE="http://www.acme.com/"
SRC_URI="http://www.acme.com/resources/classes/${MY_P}.tar.gz"

LICENSE="ACME"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	mkdir -p "${S}/classes"
	unpack ${A}
}

src_compile() {
	cp "${FILESDIR}/src.list" "${T}"
	ejavac -d "${S}/classes" "@${T}/src.list"
	cd "${S}/classes"
	jar -cf "${PN}.jar" * || die "failed to create jar"
}

src_install() {
	java-pkg_dojar "${S}/classes/${PN}.jar"
}
