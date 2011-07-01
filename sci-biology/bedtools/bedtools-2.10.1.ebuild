# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Tools for manipulation and analysis of BED, GFF/GTF, VCF, and SAM/BAM file formats"
HOMEPAGE="http://code.google.com/p/bedtools/"
SRC_URI="http://bedtools.googlecode.com/files/BEDTools.v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}"BEDTools-Version-${PV}

src_install(){
	newbin bin/overlap bt_ovelap
}
