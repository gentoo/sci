# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GFF/GTF utility providing format conversions, filter/extract regions from FASTA"
HOMEPAGE="http://ccb.jhu.edu/software/stringtie/gff.shtml
	https://github.com/gpertea/gffread"
SRC_URI="https://github.com/gpertea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gpertea/gclib/archive/v${PV}.tar.gz -> gclib-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare(){
	default
	sed -e "s/-g -O3/${CXXFLAGS}/" -i Makefile || die
	cd .. && ln -s gclib-"${PV}" gclib || die
}

src_compile(){
	emake release
}

src_install(){
	dobin gffread
	einstalldocs
}
