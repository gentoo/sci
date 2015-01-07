# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Search for sub-sequences matching PCR primers with correct order, orientation, and spacing"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/projects/e-pcr/"
SRC_URI="ftp://ftp.ncbi.nlm.nih.gov/pub/schuler/e-PCR/e-PCR-"${PV}"-src.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}"/e-PCR-"${PV}

src_prepare(){
	epatch ${FILESDIR}"/config.mk.patch"
}

src_compile(){
	make -j1 srcdir=${S} objdir=${S} || die "make -j1 failed"
}

src_install(){
	dobin e-PCR famap fahash re-PCR
	dodoc README.TXT
}
