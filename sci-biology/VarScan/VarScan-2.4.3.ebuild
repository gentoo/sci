# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2

DESCRIPTION="Variant detection (germline, multi-sample, somatic mutations, CNA, SNP calls)"
HOMEPAGE="http://varscan.sourceforge.net/"

# binary
#https://github.com/dkoboldt/varscan/blob/master/VarScan.v2.4.3.jar
SRC_URI="https://github.com/dkoboldt/varscan/blob/master/VarScan.v2.4.3.source.jar?raw=true -> ${PN}.v${PV}.source.jar"

LICENSE="Non-profit-OSL-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=virtual/jdk-1.5:*
	!sci-biology/VarScan-bin"
RDEPEND=">=virtual/jre-1.5:*
	sci-biology/bam-readcount"

S="${WORKDIR}"/net/sf/varscan

src_compile(){
	javac *.java
}

src_install(){
	java-pkg_newjar "${DISTDIR}"/${PN}.v${PV}.source.jar ${PN}.source.jar
	java-pkg_dolauncher VarScan
}
