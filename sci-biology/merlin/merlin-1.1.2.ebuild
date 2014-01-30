# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

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
	emake INSTALLDIR="${S}/bin" install || die
}

src_install() {
	dobin "${S}"/bin/* || die
	insinto /usr/share/${PN}
	doins -r examples || die
	dodoc README
}
