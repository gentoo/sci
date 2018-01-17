# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Split Illumina Nextera long mate-pairs"
HOMEPAGE="https://github.com/richardmleggett/nextclip
	https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3928519"
SRC_URI="https://github.com/richardmleggett/nextclip/archive/NextClip_v1.3.1.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-lang/R-2.12.2
	>=sci-biology/bwa-0.6.1
	dev-texlive/texlive-latex"

S="${WORKDIR}"/"${PN}"-NextClip_v"${PV}"

src_prepare(){
	default
	sed -e 's/$(ARCH)//;s/$(MACFLAG)//' -i Makefile || die
	sed -e "s/CC=gcc/$(tc-getCC)/;s/-Wall -O3/${CFLAGS}/" -i Makefile || die
}

src_compile(){
	emake all
}

src_install(){
	dobin bin/nextclip
	insinto /usr/share/"${PN}"
	doins scripts/*
	dodoc nextclipmanual.pdf README.md
}
