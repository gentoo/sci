# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Error corrector for Illumina and Roche/454 reads using multiple alignment info"
HOMEPAGE="https://www.cs.helsinki.fi/u/lmsalmel/coral"
SRC_URI="https://www.cs.helsinki.fi/u/lmsalmel/coral/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e "s#-O3 -Wall -g#${CXXFLAGS}#; s#g++#$(tc-getCXX)#" -i Makefile || die
}

src_install(){
	dobin coral
	dodoc README
}
