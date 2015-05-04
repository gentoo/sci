# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Replacement for the Java Date and Time classes"
HOMEPAGE="http://joda-time.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-dist.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/joda-convert"
DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit4 )
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_PKG_WANT_SOURCE="5"
# chokes on static inner class making instance of non-static inner class
EANT_FILTER_COMPILER="jikes"
# Keep ant from trying to use maven internally
EANT_EXTRA_ARGS="-Djunit.ant=1 -Djunit.present=1 -Djodaconvert.present=1"
EANT_GENTOO_CLASSPATH="joda-convert"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_test() {
	ANT_TASKS="ant-junit" eant \
		-Djunit.jar="$(java-pkg_getjar junit-4 junit.jar)" \
		-Djodaconvert.jar="$(java-pkg_getjar joda-convert joda-convert.jar)" \
		test
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar
	dodoc NOTICE.txt RELEASE-NOTES.txt ToDo.txt
	use doc && java-pkg_dojavadoc build/docs
	use examples && java-pkg_doexamples src/example
	use source && java-pkg_dosrc src/java/org
}
