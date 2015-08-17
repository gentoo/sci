# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV=v${PV/_/-}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Java(TM) Binding fot the OpenGL(TM) API"
HOMEPAGE="http://jogamp.org/jogl/www/"
SRC_URI="http://jogamp.org/deployment/${MY_PV}/archive/Sources/${MY_P}.tar.7z"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="cg"

COMMON_DEP="
	dev-java/ant-core:0
	dev-java/ant-junit:0
	dev-java/antlr:0
	dev-java/cpptasks:0
	=dev-java/gluegen-${PV}:${SLOT}
	dev-java/junit:4
	dev-java/swt:3.7
	x11-libs/libX11
	x11-libs/libXxf86vm
	virtual/opengl
	cg? ( media-gfx/nvidia-cg-toolkit )"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/p7zip
	dev-java/ant-antlr:0
	dev-java/ant-contrib:0
	dev-java/ant-nodeps:0
	dev-java/cpptasks:0"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default
	unpack ./${MY_P}.tar
}

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	# Empty filesets are never out of date!
	sed -i -e 's/<outofdate>/<outofdate force="true">/' make/build*xml || die
}

JAVA_PKG_BSFIX_NAME+=" build-jogl.xml build-nativewindow.xml build-newt.xml build-test.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_XML="make/build.xml"
EANT_BUILD_TARGET="all"
EANT_DOC_TARGET="" # FIXME there are a couple javadoc targets, pick one
EANT_GENTOO_CLASSPATH="ant-core,antlr,swt-3.7,ant-junit"
EANT_NEEDS_TOOLS="yes"
EANT_ANT_TASKS="ant-antlr ant-contrib ant-junit ant-nodeps cpptasks"

src_compile() {
	EANT_EXTRA_ARGS+=" -Dcommon.gluegen.build.done=true"
	EANT_EXTRA_ARGS+=" -Dgluegen.root=/usr/share/gluegen-${SLOT}/"
	EANT_EXTRA_ARGS+=" -Dgluegen.jar=$(java-pkg_getjar gluegen-${SLOT} gluegen.jar)"
	EANT_EXTRA_ARGS+=" -Dgluegen-rt.jar=$(java-pkg_getjar gluegen-${SLOT} gluegen-rt.jar)"

	# FIXME don't build tests just yet
	EANT_EXTRA_ARGS+=" -Djunit.jar=$(java-pkg_getjar --build-only junit-4 junit.jar)"

	use cg && EANT_EXTRA_ARGS+=" -Djogl.cg=1 -Dx11.cg.lib=/usr/lib"

	java-pkg-2_src_compile
}

EANT_TEST_TARGET="junit.run"
# FIXME src_test

src_install() {
	# There are many more
	java-pkg_dojar build/jar/*.jar
	java-pkg_doso build/lib/*.so

	if use doc; then
		#java-pkg_dojavadoc javadoc_public
		dodoc -r doc
	fi
	use source && java-pkg_dosrc src/jogl/classes/*
}
