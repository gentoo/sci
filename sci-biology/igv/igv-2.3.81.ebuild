# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

[ "$PV" == "9999" ] && inherit git-r3

if [ "$PV" == "9999" ]; then
	#ESVN_REPO_URI="http://igv.googlecode.com/svn/trunk"
	#ESVN_REPO_URI="http://igv.googlecode.com/svn/tags/Version_${PV}"
	EGIT_REPO_URI="https://github.com/broadinstitute/IGV.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/broadinstitute/IGV/archive/v${PV}.zip -> ${P}.zip"
	KEYWORDS=""
	# binaries
	# http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.40.zip
	# http://www.broadinstitute.org/igv/projects/downloads/igvtools_2.3.40.zip
fi

DESCRIPTION="Integrative Genomics Viewer"
HOMEPAGE="http://www.broadinstitute.org/igv/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="" # igv-2.3.81/src/com/iontorrent/views/FlowSignalDistributionPanel.java:222: error: cannot access PublicCloneable

# actually more exactly the COMMON_DEPS should contain:
#   >=dev-java/commons-compress-1.11 # use bundled library until dev-java/commons-compress is bumped, see bug #591696
COMMON_DEPS="
	dev-java/absolutelayout:0
	dev-java/jama:0
	dev-java/commons-compress
	dev-java/commons-logging:0
	>=dev-java/commons-io-2.1:1
	dev-java/commons-math:2
	dev-java/commons-jexl:2
	dev-java/jcommon:*
	dev-java/jfreechart:1.0
	dev-java/jlfgr:0
	dev-java/log4j:0
	dev-java/gson:2.2.2
	dev-java/guava:20
	dev-java/swing-layout:1
	dev-java/jgrapht:0
	dev-java/junit:4"

DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.7
	${COMMON_DEPS}"

S="${WORKDIR}/igv-${PV}" # if the file unpacks into IGV_"${PV}" then you fetched wrong file with the precompiled jar

EANT_BUILD_TARGET="all"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_NEEDS_TOOLS="true"
EANT_EXTRA_ARGS="-Dnotests=true"

EANT_GENTOO_CLASSPATH="absolutelayout,jama,commons-logging,commons-math-2,commons-jexl-2,jfreechart-1.0,jlfgr,log4j,commons-io-1,"
EANT_GENTOO_CLASSPATH+="gson-2.2.2,guava-20,swing-layout-1,jgrapht,junit-4"

java_prepare() {
	mv lib oldlib || die
	mkdir lib || die

	mv -v oldlib/{htsjdk-1.139-patched.jar,jide-oss-3.5.5.jar,goby-io-igv__V1.0.jar,jargs.jar,mongo-java-driver-2.11.3.jar,na12878kb-utils.jar,picard-lib.jar,mysql-connector-java-3.1.14-bin.jar} lib || die
	mv -v oldlib/batik* lib || die

	rm -rvf oldlib/* || die
}

src_install() {
	java-pkg_newjar igv.jar

	for i in lib/*.jar; do java-pkg_dojar $i; done

	java-pkg_dolauncher igv --jar igv.jar --main org.broad.igv.ui.Main
}

pkg_postinst(){
	einfo "You may want to install sci-biology/blat for easy sequence searches inside igv"
}
