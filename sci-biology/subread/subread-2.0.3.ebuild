# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NGS suite for analysis of mapped reads, summary of exon/intron/gene counts"
HOMEPAGE="http://bioinf.wehi.edu.au/featureCounts/" # no https
SRC_URI="https://sourceforge.net/projects/subread/files/${P}/${P}-source.tar.gz"
S="${S}-source"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/zlib:="
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e "s/-mtune=core2//g" -e "s/-O9//g" -i src/Makefile.Linux || die
}

src_compile(){
	cd src || die
	emake -f Makefile.Linux
}

src_install(){
	dobin bin/[a-s]* bin/utilities/*
	dodoc README.txt doc/SubreadUsersGuide.pdf
	insinto  /usr/share/subread
	doins annotation/*.txt
}
