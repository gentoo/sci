# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="HMM-based prokaryotic and eukaryotic gene prediction tool"
HOMEPAGE="http://korflab.ucdavis.edu/software.html"
SRC_URI="http://korflab.ucdavis.edu/Software/snap-2013-11-29.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/snap

src_prepare(){
	sed -e "s#CC=\"gcc.*#CC=$(tc-getCC)#" -i Zoe/Makefile || die
	sed -e "s#CC=\"gcc.*#CC=$(tc-getCC)#" -i Makefile || die
}

src_install(){
	echo "ZOE=/usr/share/snap/HMM" > 99snap || die
	doenvd 99snap
	insinto /usr/share/snap/HMM
	doins HMM/[a-zA-Z]*.hmm
	dobin snap fathom forge *.pl
	dodoc 00README
}
