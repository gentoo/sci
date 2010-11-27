# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="BEDTools for manipulation and analysis of BED, GFF/GTF, VCF, and SAM/BAM file formats"
HOMEPAGE="http://code.google.com/p/bedtools/"
SRC_URI="http://bedtools.googlecode.com/files/BEDTools.v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile(){
	cd BEDTools-Version-2.10.1 || die
	emake all || die
}

src_install(){
	cd BEDTools-Version-2.10.1 || die
	mv bin/overlap bin/bt_ovelap # prevent file collision with sci-biology/wgs-assembler
	dobin bin/*
}
