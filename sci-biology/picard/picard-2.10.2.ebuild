# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java-based command-line utilities that manipulate SAM/BAM/CRAM/VCF files"
HOMEPAGE="http://picard.sourceforge.net
	http://broadinstitute.github.io/picard"
SRC_URI="https://github.com/broadinstitute/picard/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS=""

CDEPEND="dev-java/snappy:1.1
	dev-java/cofoja:0
	dev-java/commons-jexl:2
	dev-java/ant-core:0
	dev-java/htsjdk:0"

DEPEND=">=virtual/jdk-1.8
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.8
	${CDEPEND}"

EANT_BUILD_TARGET="all"
EANT_NEEDS_TOOLS="true"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="snappy-1.1,cofoja,commons-jexl-2,ant-core,htsjdk"

java_prepare() {
	default
	rm -r src/java/picard/util/TestNGUtil.java src/tests/java/* || die
	epatch "${FILESDIR}"/${PV}-build.xml.patch
}

src_compile(){
	# work around gradle writing $HOME/.gradle and requiring $HOME/.git
	# https://github.com/samtools/htsjdk/issues/660#issuecomment-232155965
	GRADLE_USER_HOME="${WORKDIR}" ./gradlew --stacktrace --debug || die
}

#src_install() {
#	cd dist || die
#	java-pkg_dojar ${PN}.jar
#	java-pkg_dojar ${PN}-lib.jar
#
#	java-pkg_dolauncher ${PN} --main picard.cmdline.PicardCommandLine
#
#	use source && java-pkg_dosrc "${S}"/src/java/*
#	use doc && java-pkg_dojavadoc "${S}"/javadoc
#}
