# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/beast-mcmc/beast-mcmc-1.5.1.ebuild,v 1.1 2009/10/02 21:47:11 weaver Exp $

EAPI="2"

EANT_GENTOO_CLASSPATH="jmol,castor-1.0,log4j,commons-logging,commons-discovery,wsdl4j,xerces-2,saaj,vecmath,javahelp,sun-jaf"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="distclean makedist"
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A multiple DNA sequence alignment editor"
HOMEPAGE="http://www.jalview.org/"
SRC_URI="http://www.jalview.org/source/jalview_2_6_1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPS=">=sci-chemistry/jmol-11.0.2 <sci-chemistry/jmol-11.1
	dev-java/castor:1.0
	dev-java/log4j"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.5
	dev-java/commons-discovery
	dev-java/commons-logging
	dev-java/saaj
	dev-java/xerces
	dev-java/wsdl4j
	dev-java/vecmath
	dev-java/javahelp
	dev-java/sun-jaf
	dev-java/sun-javamail
	${COMMON_DEPS}"

# Note: dev-java/vecmath is in the java overlay.

S="${WORKDIR}/${PN}"

java_prepare() {
	perl -i -ne'print unless /<jalopy/../<\/jalopy>/ or /<taskdef.+name="jalopy"/../<\/taskdef>/ or /<include name="jalview-jalopy.xml"/' build.xml
	find -name '*.jar' | egrep -v '(vamsas|axis|jaxrpc|roxes-ant-tasks|regex|xml-apis)' | xargs rm -v
}

src_install() {
	java-pkg_dojar dist/*.jar

	MY_CP=""
	for i in $(cd dist; ls *.jar); do
		MY_CP="${MY_CP}:${ROOT}usr/share/${PN}/lib/$i"
	done
	java-pkg_dolauncher jalview --main jalview.bin.Jalview \
		--java_args "-cp ${MY_CP}:$(java-config -p ${EANT_GENTOO_CLASSPATH})"

	use source && java-pkg_dosrc src
#	use doc && java-pkg_dojavadoc something - no docs to be seen
	dodoc README doc/*
}
