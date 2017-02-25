# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-antlr ant-contrib dev-java/cpptasks:0"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Automatically generate the JNI code necessary to call C libraries"
HOMEPAGE="http://jogamp.org/gluegen/www/"
SRC_URI="https://github.com/sgothel/gluegen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="
	dev-java/ant-core:0
	dev-java/antlr:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	dev-java/cpptasks:0
	test? (
		dev-java/junit:4
		dev-java/ant-junit4
	)"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_XML="make/build.xml"
EANT_BUILD_TARGET="all.no_junit"
EANT_DOC_TARGET=""
EANT_GENTOO_CLASSPATH="antlr,ant-core"
EANT_NEEDS_TOOLS="yes"
EANT_TEST_TARGET="junit.run"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/build/${PN}{,-rt}.jar"
EANT_EXTRA_ARGS="-Dc.strip.libraries=false"

java_prepare() {
	rm -rf make/lib
	epatch "${FILESDIR}"/${PV}-*.patch
	java-ant_bsfix_files "${S}/make/build-test.xml"
}

src_test() {
	EANT_TASKS="ant-junit4" java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/${PN}{,-rt}.jar
	java-pkg_doso build/obj/*.so

	use doc && dohtml -r doc/manual
	use source && java-pkg_dosrc src/java/*

	# for building jogl
	insinto /usr/share/${PN}-${SLOT}/make
	doins -r make/*
	insinto /usr/share/${PN}-${SLOT}/build
	doins build/artifact.properties
}
