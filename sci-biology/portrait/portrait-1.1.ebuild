# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Ab initio ncRNA prediction"
HOMEPAGE="http://bioinformatics.cenargen.embrapa.br/portrait"
SRC_URI="http://bioinformatics.cenargen.embrapa.br/portrait/download/portrait.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-lang/perl
	sci-biology/ANGLE-bin
	sci-biology/cast-bin
	sci-libs/libsvm"
# was only tested with sci-libs/libsvm-2.84

src_install(){
	sed -e 's/\r//' -i *.pl || die "Failed to convert from DOS line endings to Unix"
	sed -e 's#/home/rtarrial/prog#/usr/bin#' -i *.pl
	dobin *.pl
	dodoc README.txt
	insinto /usr/share/"${PN}"
	doins *.model
}
