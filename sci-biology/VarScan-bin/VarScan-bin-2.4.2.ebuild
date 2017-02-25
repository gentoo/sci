# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2

MY_PN="VarScan"
DESCRIPTION="Variant detection (germline, multi-sample, somatic mut., CNA), SNP"
HOMEPAGE="http://dkoboldt.github.io/varscan"

# binary
#http://downloads.sourceforge.net/project/varscan/VarScan.v2.3.7.jar
#SRC_URI="http://downloads.sourceforge.net/project/varscan/${PN}.v${PV}.jar"
SRC_URI="https://github.com/dkoboldt/varscan/blob/master/${MY_PN}.v${PV}.jar?raw=true -> ${MY_PN}.v${PV}.jar"

LICENSE="Non-profit-OSL-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=virtual/jdk-1.5:*"
RDEPEND=">=virtual/jre-1.5:*"

S="${WORKDIR}"/net/sf/varscan

src_install(){
	java-pkg_newjar "${DISTDIR}"/${MY_PN}.v${PV}.jar ${MY_PN}.jar
	java-pkg_dolauncher VarScan
}
