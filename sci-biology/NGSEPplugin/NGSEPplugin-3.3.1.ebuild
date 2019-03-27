# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="NGSEP with Eclipse Plugin (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home"
SRC_URI="https://sourceforge.net/projects/ngsep/files/SourceCode/NGSEPplugin_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.7:*
	dev-java/jcommon
	dev-util/eclipse-sdk
	dev-java/htsjdk
	sci-biology/NGSEPcore"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}/${PN}_${PV}"

src_prepare(){
	rm -f lib/NGSEPcore_3.3.1.jar lib/SortSam.jar lib/jcommon-1.0.17.jar lib/xchart-2.4.2.jar || die
	default
}

src_install(){
	java-pkg_dojar *.jar
}
