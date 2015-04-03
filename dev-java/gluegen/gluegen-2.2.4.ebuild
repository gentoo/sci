# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

###############################################################################
# WARNING: don't add to main tree without fixing QA issues first!
###############################################################################

EAPI=5

RESTRICT="test" #require jardiff

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2
MY_PV=v"${PV}"
MY_P="${PN}"-"${MY_PV}"

DESCRIPTION="GlueGen is a tool which automatically generates the Java and JNI
code necessary to call C libraries"
HOMEPAGE="http://jogamp.org/gluegen/www/"
SRC_URI="http://jogamp.org/deployment/archive/rc/${MY_PV}/archive/Sources/${MY_P}.tar.7z"

LICENSE="BSD"
SLOT="2.2"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="
	dev-java/ant-core:0
	dev-java/antlr:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/p7zip
	dev-java/ant-antlr:0
	dev-java/ant-contrib:0
	dev-java/ant-nodeps:0
	dev-java/cpptasks:0
	test? ( dev-java/junit:4 )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default
	unpack ./${MY_P}.tar
}

java_prepare() {
	rm -rf make/lib
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_XML="make/build.xml"
EANT_BUILD_TARGET="init gluegen.build.java gluegen.build.c tag.build"
EANT_TEST_TARGET="junit.run"
EANT_DOC_TARGET=""
EANT_GENTOO_CLASSPATH="antlr,ant-core"
EANT_NEEDS_TOOLS="yes"
EANT_ANT_TASKS="ant-antlr ant-contrib ant-nodeps cpptasks"

src_configure() {
	use test && EANT_GENTOO_CLASSPATH+=",junit-4"
	default
}

src_compile() {
	# FIXME don't copy around jars
	EANT_EXTRA_ARGS+=" -Dantlr.jar=\"$(java-pkg_getjar --build-only antlr antlr.jar)\""
	java-pkg-2_src_compile
}

src_test() {
	EANT_EXTRA_ARGS+=" -Djunit.jar=\"$(java-pkg_getjar --build-only junit-4 junit.jar)\""
	java-pkg-2_src_test
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
