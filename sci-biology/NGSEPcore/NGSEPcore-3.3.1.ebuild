# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="NGSEP (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home"
SRC_URI="https://sourceforge.net/projects/ngsep/files/SourceCode/NGSEPcore_${PV}.tar.gz
	https://sourceforge.net/projects/ngsep/files/training/UserManualNGSEP_V330.pdf -> ${P}_UserManual.pdf
	https://sourceforge.net/projects/ngsep/files/training/Tutorial.txt -> ${P}_Tutorial.txt
	https://sourceforge.net/projects/ngsep/files/training/QuickStart.txt -> ${P}_QuickStart.txt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-java/htsjdk"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}_${PV}"

src_prepare(){
	rm -f *.jar lib/htsjdk-1.129.jar || die
	default
}

src_compile(){
	make -j1
}

src_install(){
	java-pkg_dojar *.jar
	dodoc "$DISTDIR}"/${P}_user_manual.pdf
}
