# Copyright 1999-2012 Gentoo Foundation
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

COMMON_DEPS=""
DEPEND=">=virtual/jdk-1.6
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPS}"

src_install() {
	java-pkg_newjar igv.jar
	for i in lib/*.jar; do java-pkg_dojar $i; done
	java-pkg_dolauncher igv --jar igv.jar --main org.broad.igv.ui.Main
}
