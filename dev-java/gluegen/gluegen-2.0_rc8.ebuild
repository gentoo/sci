# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV=v${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Automatically generate the JNI code necessary to call C libraries"
HOMEPAGE="http://jogamp.org/gluegen/www/"
SRC_URI="http://jogamp.org/deployment/${MY_PV}/archive/Sources/${MY_P}.tar.7z"

LICENSE="BSD"
SLOT="2"
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
	dev-java/junit:4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default
	unpack ./${MY_P}.tar
}

java_prepare() {
	# preserve android.jar, FIXME can be built form source!
	mv make/lib/android-sdk "${T}" || die
	find -name '*.jar' -exec rm -v {} + || die
	mv "${T}"/android-sdk make/lib/ || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_XML="make/build.xml"
EANT_BUILD_TARGET="all"
EANT_DOC_TARGET=""
EANT_GENTOO_CLASSPATH="antlr,ant-core"
EANT_NEEDS_TOOLS="yes"
EANT_ANT_TASKS="ant-antlr ant-contrib ant-nodeps cpptasks"
src_compile() {
	# FIXME don't copy around jars
	EANT_EXTRA_ARGS+=" -Dantlr.jar=\"$(java-pkg_getjar --build-only antlr antlr.jar)\""
	# FIXME don't build tests just yet
	EANT_EXTRA_ARGS+=" -Djunit.jar=\"$(java-pkg_getjar --build-only junit-4 junit.jar)\""

	java-pkg-2_src_compile
}

# FIXME src_test

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
