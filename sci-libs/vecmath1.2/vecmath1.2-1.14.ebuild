# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

DESCRIPTION=" Unofficial free implementation of Sun javax.vecmath by Kenji Hiranabe"
HOMEPAGE="http://www.objectclub.jp/download/vecmath_e"
SRC_URI="http://www.objectclub.jp/download/files/vecmath/${P/_/-}.tar.gz"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	mkdir "${S}/classes"
}

src_compile() {
	find javax/ -name "*.java" > "${T}/src.list"
	ejavac -d "${S}/classes" "@${T}/src.list"

	cd "${S}/classes"
	jar -cf "${S}/${P}.jar" * || die "failed to create jar"
}

src_install() {
	java-pkg_dojar "${S}/${P}.jar"
}
