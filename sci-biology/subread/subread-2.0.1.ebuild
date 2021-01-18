# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NGS suite for analysis of mapped reads, summary of exon/intron/gene counts"
HOMEPAGE="http://bioinf.wehi.edu.au/featureCounts/" # no https
if [ "$PV" == "9999" ]; then
	inherit subversion
	ESVN_REPO_URI="https://subread.svn.sourceforge.net/svnroot/subread/trunk"
	KEYWORDS=""
else
	SRC_URI="https://sourceforge.net/projects/subread/files/${P}/${P}-source.tar.gz"
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${S}"-source

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
