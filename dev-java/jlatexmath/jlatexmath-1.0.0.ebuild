# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java API to render LaTeX"
SRC_URI="http://forge.scilab.org/index.php/p/${PN}/downloads/get/${PN}-src-${PV}.zip"
HOMEPAGE="http://forge.scilab.org/index.php/p/jlatexmath"

IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.5
	  app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"

EANT_BUILD_TARGET="buildJar"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
