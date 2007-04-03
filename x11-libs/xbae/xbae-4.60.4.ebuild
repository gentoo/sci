# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Motif-based widget to display a grid of cells as a spreadsheet"
HOMEPAGE="http://xbae.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc examples"

RDEPEND="virtual/motif
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-tmpl.patch
	epatch "${FILESDIR}"/${P}-lxmp.patch
	epatch "${FILESDIR}"/${P}-Makefile.in.patch
}

src_compile() {
	econf \
	  --enable-production \
		|| die "econf failed"

	emake || die "emake failed"
}

src_test() {
	cd examples
	emake || die "emake examples failed"
	./testall
	make clean
}


src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto /usr/share/aclocal
	doins ac_find_xbae.m4
	dodoc README NEWS ChangeLog AUTHORS
	use doc && dohtml -r doc/*
	if use examples; then
		find examples -name '*akefile*' -exec rm -f {} \;
		rm -f examples/{testall,extest}
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
