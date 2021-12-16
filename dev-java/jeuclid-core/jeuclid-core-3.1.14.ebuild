# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Core module of MathML rendering solution"
HOMEPAGE="https://github.com/rototor/jeuclid"
SRC_URI="https://github.com/rototor/jeuclid/archive/jeuclid-parent-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="
	dev-java/ant-core:0
	dev-java/batik:1.9
	dev-java/commons-logging:0
	dev-java/jcip-annotations:0
	dev-java/jsr305:0
	dev-java/xml-commons-external:1.3
	dev-java/xmlgraphics-commons:2
"

RDEPEND=">=virtual/jre-1.7
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.7
	${COMMON_DEPEND}"

S="${WORKDIR}/jeuclid-jeuclid-parent-${PV}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-no-freehep.patch
)

src_prepare() {
	default

	# create directory for dependencies
	mkdir lib && cd lib || die

	# add dependencies into the lib dir
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from batik-1.9 batik-all.jar
	java-pkg_jar-from commons-logging,jcip-annotations,xml-commons-external-1.3
	java-pkg_jar-from xml-commons-external-1.3,xmlgraphics-commons-2
	java-pkg_jar-from jsr305
}

src_install() {
	java-pkg_dojar target/${PN}.jar
}
