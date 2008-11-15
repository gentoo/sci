# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# cvs -d :pserver:alistair64@cvs.dev.java.net:/cvs login
# cvs -d :pserver:alistair64@cvs.dev.java.net:/cvs export -r rel-1_5_1-fcs vecmath
# tar -cjf vecmath-1.5.1.tar.bz2 vecmath/
# cvs -d :pserver:alistair64@cvs.dev.java.net:/cvs export -r rel-1_5_1-fcs vecmath-test
# tar -cjf vecmath-test-1.5.1.tar.bz2 vecmath-test/

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Sun J3D: 3D vector math package"
HOMEPAGE="https://vecmath.dev.java.net/"

SRC_URI="http://dev.gentoo.org/~ali_bush/distfiles/${P}.tar.bz2
		test? ( http://dev.gentoo.org/~ali_bush/distfiles/${PN}-test-${PV}.tar.bz2 )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="|| ( sun-jrl sun-jdl )"
IUSE=""
DEPEND=">=virtual/jdk-1.5
		dev-java/ant-core
		test? ( =dev-java/junit-4* )"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${PN}"
S_TEST="${WORKDIR}/${PN}-test"

EANT_DOC_TARGET="docs"
EANT_BUILD_TARGET="jar"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use test && java-ant_rewrite-classpath "${S_TEST}/build.xml"
}

src_test() {
	cd "${S}/../${PN}-test"
	ANT_TASKS="ant-junit"
	eant \
		-Dgentoo.classpath="$(java-pkg_getjar --build-only junit-4 \
		junit.jar):${S}/build/opt/lib/ext/${PN}.jar" test
}

src_install() {
	java-pkg_dojar "build/opt/lib/ext/${PN}.jar"

	use source && java-pkg_dosrc "${S}/src/*"

	dodoc *.txt docs/*.txt
	if use doc; then
		java-pkg_dojavadoc "build/javadocs/"
		dohtml -r *.html
	fi
}

