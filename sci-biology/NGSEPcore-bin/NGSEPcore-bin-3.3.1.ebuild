# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="NGSEP (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home
	https://github.com/NGSEP/NGSEPcore"
SRC_URI="https://sourceforge.net/projects/ngsep/files/Library/NGSEPcore_3.3.1.jar
	https://sourceforge.net/projects/ngsep/files/training/UserManualNGSEP_V330.pdf -> ${P}_UserManual.pdf
	https://sourceforge.net/projects/ngsep/files/training/Tutorial.txt -> ${P}_Tutorial.txt
	https://sourceforge.net/projects/ngsep/files/training/QuickStart.txt -> ${P}_QuickStart.txt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-java/htsjdk"
#	dev-java/jsci-bin
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack(){
	echo
}

src_install(){
	java-pkg_dojar "${DISTDIR}"/*.jar
	dodoc "${DISTDIR}"/${P}_UserManual.pdf \
		"${DISTDIR}"/${P}_Tutorial.txt \
		"${DISTDIR}"/${P}_QuickStart.txt
}
