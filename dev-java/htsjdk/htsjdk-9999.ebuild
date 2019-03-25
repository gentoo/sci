# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit git-r3 java-pkg-2 java-ant-2

DESCRIPTION="Java API for high-throughput sequencing data (HTS) formats"
HOMEPAGE="https://samtools.github.io/htsjdk/"
EGIT_REPO_URI="https://github.com/samtools/htsjdk.git"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS=""

CDEPEND="dev-java/commons-jexl:2
	dev-java/commons-compress:0
	dev-java/commons-logging:0
	dev-java/gradle-bin:*"

DEPEND=">=virtual/jdk-1.8
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.8
	${CDEPEND}"

EANT_BUILD_TARGET="all"
EANT_NEEDS_TOOLS="true"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-jexl-2,commons-compress,commons-logging"

java_prepare(){
	default
}

src_compile(){
	# work around gradle writing $HOME/.gradle and $HOME/.git
	# https://github.com/samtools/htsjdk/issues/660#issuecomment-232155965
	GRADLE_USER_HOME="${WORKDIR}" ./gradlew || die
}

src_install() {
	cd build/libs || die

	#for i in *-SNAPSHOT.jar; do
	#	java-pkg_newjar $i ${i/-[0-9]*.jar/.jar}
	#done
	java-pkg_newjar "${S}"/build/libs/*-SNAPSHOT.jar htsjdk.jar
	use source && java-pkg_dosrc "${S}"/build/libs/*-sources.jar
	use doc && java-pkg_dojavadoc "${S}"/build/libs/*-javadoc.jar
}
