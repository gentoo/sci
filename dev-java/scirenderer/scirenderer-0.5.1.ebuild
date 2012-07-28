# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A rendering library based on JoGL"
SRC_URI="http://forge.scilab.org/index.php/p/${PN}/downloads/get/${P}.tar.gz"
HOMEPAGE="http://forge.scilab.org/index.php/p/scirenderer/"

IUSE="doc source"
DEPEND=">=virtual/jdk-1.5
	dev-java/jogl:2
	dev-java/jlatexmath:0"
RDEPEND=">=virtual/jre-1.5"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EANT_DOC_TARGET="doc"

java_prepare() {
	sed -i \
	-e "s|jogl2.jar =.*|jogl2.jar =$(java-pkg_getjar jogl-2 jogl.all.jar)|" \
	-e "s|gluegen2-rt.jar =.*|gluegen2-rt.jar =$(java-pkg_getjar gluegen-2 \
	gluegen-rt.jar)|" \
	-e "s|jlatexmath.jar =.*|jlatexmath.jar = $(java-pkg_getjars jlatexmath)|" \
	scirenderer-libs.properties
}

src_install() {
	java-pkg_newjar jar/${P}.jar ${PN}.jar
	use doc && dodoc -r docs/
	use source && java-pkg_dosrc src/org
}
