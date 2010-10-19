# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java docking framework for use in cross-platform Swing applications"
HOMEPAGE="http://flexdock.dev.java.net/"
SRC_URI="https://flexdock.dev.java.net/files/documents/2037/152436/${P}-src.zip"

#S=${WORKDIR}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/skinlf
	dev-java/commons-logging"

EANT_BUILD_TARGET="build.with.native jar"
EANT_DOC_TARGET="doc"

java_prepare() {
	epatch "${FILESDIR}"/${P}-nativelib.patch
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-nodemo.patch

	#configure java environment
	cp workingcopy.properties-sample workingcopy.properties
	sed -i -e 's|sdk.home=C:\\\\jdk1.5.0_03|sdk.home=|' \
	-e "s|sdk.home=|sdk.home=$(java-config -O)|" workingcopy.properties|| die

	#some cleanups
	find . -name '*.so' -exec rm -v {} \;|| die
	find . -name '*.dll' -exec rm -v {} \;|| die

	#remove built-in jars and use the system ones
	cd "${WORKDIR}/lib" || die
	rm -rvf *.jar jmf|| die
	java-pkg_jar-from skinlf
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from jgoodies-looks-2.0 looks.jar
}

src_install() {
	java-pkg_newjar "build/${P}.jar" "${PN}.jar"
	java-pkg_doso build/bin/org/flexdock/docking/drag/outline/xlib/*.so
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src
}
