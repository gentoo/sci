# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Statistical analysis of gene flow in pedigrees"
HOMEPAGE="http://www.sph.umich.edu/csg/abecasis/Merlin/"
SRC_URI="http://www.sph.umich.edu/csg/abecasis/Merlin/download/${P}.tar.gz"

LICENSE="merlin"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i -e 's/CXX=g++/CXX='$(tc-getCXX)'/' -e 's/CFLAGS=/CFLAGS+= /' "${S}/Makefile" || die
}

src_compile() {
	emake INSTALLDIR="${S}/bin" install
}

src_install() {
	dobin "${S}"/bin/*
	insinto /usr/share/${PN}
	doins -r examples
	dodoc README
}
