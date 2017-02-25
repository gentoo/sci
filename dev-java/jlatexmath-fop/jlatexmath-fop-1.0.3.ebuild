# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="jlatexmath plugin for dev-java/fop"
HOMEPAGE="http://forge.scilab.org/index.php/p/jlatexmath"
SRC_URI="http://forge.scilab.org/upload/jlatexmath/files/${PN}-src-${PV}.zip"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/jlatexmath:1
	dev-java/xmlgraphics-commons:2
	>=dev-java/fop-2.0-r1:0"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

EANT_BUILD_TARGET="buildJar"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fixpaths.patch"
	cp "${FILESDIR}/version.xml" "${S}" || die
	echo "fop.jar=$(java-pkg_getjar fop fop.jar)
xmlgraphics-commons.jar=$(java-pkg_getjar xmlgraphics-commons-2 xmlgraphics-commons.jar)
jlatexmath.jar=$(java-pkg_getjar jlatexmath-1 jlatexmath.jar)" \
		 >>fop.properties || die
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
