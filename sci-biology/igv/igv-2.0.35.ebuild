# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

#ESVN_REPO_URI="http://igv.googlecode.com/svn/trunk"
ESVN_REPO_URI="http://igv.googlecode.com/svn/tags/Version_${PV}"

EANT_BUILD_TARGET="all"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_NEEDS_TOOLS="true"
WANT_ANT_TASKS="ant-apache-bcel"

inherit subversion java-pkg-2 java-ant-2

DESCRIPTION="Integrative Genomics Viewer"
HOMEPAGE="http://www.broadinstitute.org/igv/"
SRC_URI=""
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

COMMON_DEPS="dev-java/batik
	dev-java/absolutelayout
	dev-java/jama
	dev-java/commons-logging
	dev-java/commons-math
	dev-java/concurrent-util
	dev-java/jcommon
	dev-java/jfreechart
	dev-java/hdf-java
	dev-java/jlfgr
	dev-java/junit
	dev-java/log4j
	dev-db/mysql-connector-c++
	sci-biology/samtools
	dev-java/swing-layout
	sci-biology/vcftools"
DEPEND=">=virtual/jdk-1.6
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPS}"

src_install() {
	java-pkg_newjar igv.jar

	# probably could drop some of these below
	#
	# /usr/share/igv/lib/AbsoluteLayout.jar
	# /usr/share/igv/lib/Jama-1.0.2.jar
	# /usr/share/igv/lib/batik-awt-util.jar
	# /usr/share/igv/lib/batik-bridge.jar
	# /usr/share/igv/lib/batik-codec.jar
	# /usr/share/igv/lib/batik-css.jar
	# /usr/share/igv/lib/batik-dom.jar
	# /usr/share/igv/lib/batik-ext.jar
	# /usr/share/igv/lib/batik-gui-util.jar
	# /usr/share/igv/lib/batik-gvt.jar
	# /usr/share/igv/lib/batik-parser.jar
	# /usr/share/igv/lib/batik-svg-dom.jar
	# /usr/share/igv/lib/batik-svggen.jar
	# /usr/share/igv/lib/batik-transcoder.jar
	# /usr/share/igv/lib/batik-util.jar
	# /usr/share/igv/lib/batik-xml.jar
	# /usr/share/igv/lib/commons-logging-1.1.1.jar
	# /usr/share/igv/lib/commons-math-1.1.jar
	# /usr/share/igv/lib/concurrent.jar
	# /usr/share/igv/lib/goby-io-igv.jar
	# /usr/share/igv/lib/igv.jar
	# /usr/share/igv/lib/jargs.jar
	# /usr/share/igv/lib/jcommon-1.0.16.jar
	# /usr/share/igv/lib/jfreechart-1.0.13.jar
	# /usr/share/igv/lib/jhdf.jar
	# /usr/share/igv/lib/jhdf5.jar
	# /usr/share/igv/lib/jide-action.jar
	# /usr/share/igv/lib/jide-common.jar
	# /usr/share/igv/lib/jide-components.jar
	# /usr/share/igv/lib/jide-dialogs.jar
	# /usr/share/igv/lib/jide-dock.jar
	# /usr/share/igv/lib/jide-grids.jar
	# /usr/share/igv/lib/jlfgr-1_0.jar
	# /usr/share/igv/lib/junit-4.5.jar
	# /usr/share/igv/lib/log4j-1.2.15.jar
	# /usr/share/igv/lib/mysql-connector-java-3.1.14-bin.jar
	# /usr/share/igv/lib/sam-1.53.jar
	# /usr/share/igv/lib/swing-layout-1.0.jar
	# /usr/share/igv/lib/vcf.jar
	# /usr/share/igv/lib/xml-apis-1.3.04.jar
	# /usr/share/igv/lib/xml-apis-ext-1.3.04.jar
	cd lib || die
	rm AbsoluteLayout.jar Jama*.jar batik*.jar commons-logging*.jar commons-math*.jar concurrent*.jar jcommon*.jar jfreechart*.jar jhdf*.jar jlfgr*.jar junit*.jar log4j*.jar sam*.jar swing*.jar vcf*.jar
	cd ..
	
	for i in lib/*.jar; do java-pkg_dojar $i; done

	java-pkg_dolauncher igv --jar igv.jar --main org.broad.igv.ui.Main
}
