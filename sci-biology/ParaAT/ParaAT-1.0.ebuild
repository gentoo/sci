# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Create multiple protein-coding DNA alignments and back-Translation"
HOMEPAGE="https://code.google.com/p/paraat
	http://cbb.big.ac.cn/software
	https://www.sciencedirect.com/science/article/pii/S0006291X12003518"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/paraat/${PN}${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}"

src_prepare(){
	rm -f ._Epal2nal.pl ._ParaAT.pl
	default
}

src_install(){
	dobin *.pl
	dodoc readme.txt
}
