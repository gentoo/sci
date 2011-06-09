# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

JAVA_PKG_IUSE="examples source"

inherit java-pkg-2 java-ant-2

MY_PN="${PN/-fop/}"
MY_P="${P/-fop/}"
DESCRIPTION="jlatexmath plugin for dev-java/fop"
SRC_URI="http://forge.scilab.org/upload/jlatexmath/files/${MY_PN}-src-all-${PV}.zip"
HOMEPAGE="http://forge.scilab.org/index.php/p/jlatexmath"

IUSE=""
DEPEND=">=virtual/jdk-1.5
	dev-java/jlatexmath
	dev-java/avalon-framework
	dev-java/fop"
RDEPEND=${DEPEND}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EANT_BUILD_TARGET="buildJar"

S="${WORKDIR}/${MY_P}/plugin/fop"

src_prepare() {
	cd "${WORKDIR}/${MY_P}"
	sed -i -e "s:/usr/share/java/fop.jar:$(java-pkg_getjar fop fop.jar):g" \
		-e "s:/usr/share/java/xmlgraphics-commons.jar:$(java-pkg_getjar xmlgraphics-commons-1.3 xmlgraphics-commons.jar):g" \
		-e "s:/usr/share/java/batik.jar:$(java-pkg_getjar batik-1.7 batik-all.jar):g" \
		-e "s:/usr/share/java/avalon-framework.jar:$(java-pkg_getjar avalon-framework-4.2 avalon-framework.jar):g" \
		-e "s:/usr/share/java/commons-io.jar:$(java-pkg_getjar commons-io-1 commons-io.jar):g" \
		-e "s:/usr/share/java/commons-logging.jar:$(java-pkg_getjar commons-logging commons-logging.jar):g" \
		-e "s:/usr/share/java/xml-apis-ext.jar:$(java-pkg_getjar xml-commons-external-1.3 xml-apis-ext.jar):g" \
		fop.properties
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples examples
}
