# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Error corrector for Illumina and Roche/454 reads using multiple alignment info"
HOMEPAGE="http://www.cs.helsinki.fi/u/lmsalmel/coral"
SRC_URI="http://www.cs.helsinki.fi/u/lmsalmel/coral/coral-1.4.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s#-O3 -Wall -g#${CXXFLAGS}#; s#g++#$(tc-getCXX)#" -i Makefile || die
}

src_install(){
	dobin coral
	dodoc README
}
