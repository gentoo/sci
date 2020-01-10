# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="NGSEP (CNV and indel discovery)"
HOMEPAGE="https://sourceforge.net/p/ngsep/wiki/Home
	https://github.com/NGSEP/NGSEPcore"
SRC_URI="https://sourceforge.net/projects/ngsep/files/SourceCode/NGSEPcore_${PV}.tar.gz
	https://sourceforge.net/projects/ngsep/files/training/UserManualNGSEP_V330.pdf -> ${P}_UserManual.pdf
	https://sourceforge.net/projects/ngsep/files/training/Tutorial.txt -> ${P}_Tutorial.txt
	https://sourceforge.net/projects/ngsep/files/training/QuickStart.txt -> ${P}_QuickStart.txt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-java/htsjdk
	dev-java/jsci-bin"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}_${PV}"

PATCHES=( "${FILESDIR}"/NGSEPcore_drop_utf8_chars.patch "${FILESDIR}"/NGSEPcore_fix_compilation.patch )

src_prepare(){
	rm lib/htsjdk-1.129.jar || die
	rm lib/jsci-core.jar || die
	default
}

src_compile(){
	emake -j1
}

src_install(){
	java-pkg_dojar *.jar lib/*.jar
	dodoc "${DISTDIR}"/${P}_UserManual.pdf \
	"${DISTDIR}"/${P}_Tutorial.txt \
	"${DISTDIR}"/${P}_QuickStart.txt \
	README.txt
}
