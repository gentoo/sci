# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

MY_P=${PN}-${PV/./}

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="http://josm.openstreetmap.de/"
SRC_URI="http://josm.fabian-fingerle.de/${MY_P}.tar.lzma"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${PN}"

IUSE=""

src_compile() {
	JAVA_ANT_ENCODING=UTF-8
	eant dist
}

src_install() {
	java-pkg_newjar "dist/${PN}-custom.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	newicon images/logo.png josm.png || die "newicon failed"
	make_desktop_entry "${PN}" "Java OpenStreetMap Editor" josm "Application"
}
