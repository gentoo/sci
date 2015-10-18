# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="Variant detection (germline, multi-sample, somatic mut., som. cp nr alterations (CNA)), SNP calls"
HOMEPAGE="http://varscan.sourceforge.net/"

# binary
#http://downloads.sourceforge.net/project/varscan/VarScan.v2.3.7.jar
#SRC_URI="http://downloads.sourceforge.net/project/varscan/${PN}.v${PV}.jar"
SRC_URI="http://downloads.sourceforge.net/project/varscan/${PN}.v${PV}.source.jar"

LICENSE="Non-profit-OSL-3.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.5:*"
RDEPEND=">=virtual/jre-1.5:*"

S="${WORKDIR}"/net/sf/varscan

src_compile(){
	javac *.java
}
