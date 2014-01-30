# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

MY_PV=$(replace_all_version_separators -)
MY_P="${P}-gpl"

DESCRIPTION="Provides a common base for graphical component to build a graphical console."
HOMEPAGE="http://dev.artenum.com/projects/JRosetta"
SRC_URI="http://dev.artenum.com/projects/JRosetta/download/JRosetta-${MY_PV}/data/src-gpl?action=download&nodecorator -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

EANT_BUILD_TARGET="make"

src_install() {
	java-pkg_dojar dist/${PN}-API.jar
	java-pkg_dojar dist/${PN}-engine.jar
	dodoc CHANGE.txt || die
	use source && java-pkg_dosrc src/com
}
