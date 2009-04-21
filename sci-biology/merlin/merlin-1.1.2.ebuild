# Copyright 1999-2009 Gentoo Foundation
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
	sed -i -e 's/CXX=g++/CXX='$(tc-getCXX)'/' -e 's/CFLAGS=/CFLAGS+=/' "${S}/Makefile" || die
}

src_install() {
	make install INSTALLDIR="${D}usr/bin" || die
}
