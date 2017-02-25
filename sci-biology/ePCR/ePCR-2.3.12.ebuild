# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Search for sub-sequences matching PCR primers"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/tools/epcr/"
SRC_URI="ftp://ftp.ncbi.nlm.nih.gov/pub/schuler/e-PCR/e-PCR-"${PV}"-src.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}"/e-PCR-"${PV}

src_prepare(){
	epatch "${FILESDIR}"/config.mk.patch
}

src_compile(){
	emake -j1 srcdir="${S}" objdir="${S}"
}

src_install(){
	dobin e-PCR famap fahash re-PCR
	dodoc README.TXT
}
