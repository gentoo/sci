# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="GFF/GTF utility providing format conversions, filter/extract regions from FASTA"
HOMEPAGE="http://ccb.jhu.edu/software/stringtie/gff.shtml
	https://github.com/gpertea/gffread"
SRC_URI="https://github.com/gpertea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gpertea/gclib/archive/v${PV}.tar.gz -> gclib-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	src_unpack "${DISTDIR}"/gclib-${PV}.tar.gz
	default
	sed -e "s/-g -O3/${CXXFLAGS}/" -i Makefile || die
	cd .. && ln -s gclib-"${PV}" gclib || die
}

src_compile(){
	emake release
}

src_install(){
	dobin gffread
}
