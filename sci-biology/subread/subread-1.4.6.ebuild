# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="NGS suite for analysis of mapped reads, summary of exon/intron/gene counts"
HOMEPAGE="http://bioinf.wehi.edu.au/featureCounts/"
if [ "$PV" == "9999" ]; then
	ESVN_REPO_URI="https://subread.svn.sourceforge.net/svnroot/subread/trunk"
	#KEYWORDS="~amd64 ~x86"
else
	SRC_URI="http://sourceforge.net/projects/subread/files/"${P}"/"${P}"-source.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${S}"-source

src_prepare(){
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
