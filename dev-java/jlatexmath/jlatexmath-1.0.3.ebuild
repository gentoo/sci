# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java API to render LaTeX"
HOMEPAGE="http://forge.scilab.org/index.php/p/jlatexmath"
SRC_URI="http://forge.scilab.org/upload/jlatexmath/files/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

EANT_BUILD_TARGET="buildJar"
EANT_DOC_TARGET="doc"

src_install() {
	java-pkg_newjar dist/"${P}.jar" "${PN}.jar"
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
