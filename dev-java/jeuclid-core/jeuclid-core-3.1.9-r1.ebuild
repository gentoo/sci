# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="source"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Core module of MathML rendering solution"
HOMEPAGE="http://jeuclid.sourceforge.net/"
SRC_URI="mirror://sourceforge/jeuclid/jeuclid-parent-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="dev-java/ant-core
	dev-java/batik:1.8=
	dev-java/commons-logging
	dev-java/jcip-annotations
	dev-java/xml-commons-external:1.3
	dev-java/xmlgraphics-commons:2"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"

S="${WORKDIR}/jeuclid-parent-${PV}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-no-freehep.patch \
		"${FILESDIR}"/${PN}-cast-issue.patch

	# create directory for dependencies
	mkdir lib && cd lib || die

	# add dependencies into the lib dir
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from batik-1.8 batik-all.jar
	java-pkg_jar-from commons-logging,jcip-annotations,xml-commons-external-1.3
	java-pkg_jar-from xml-commons-external-1.3,xmlgraphics-commons-2
}

src_install() {
	java-pkg_dojar target/${PN}.jar
}
