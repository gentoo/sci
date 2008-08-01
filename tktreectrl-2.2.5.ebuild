# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="TkTreeCtrl is a flexible listbox widget for Tk"
HOMEPAGE="http://tktreectrl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="tktreectrl"
SLOT="0"
IUSE="X threads debug"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"
DEPEND=">=dev-lang/tcl-8.4"

src_compile() {
	econf \
	$(use_enable threads) \
	$(use_enable amd64 64bit) \
	$(use_enable debug symbols) \
	$(use_enable X x) \
	--enable-shared || die
	emake
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README.txt
	mv "${D}"/usr/lib/treectrl${PV}/htmldoc "${D}"/usr/share/doc/${P}/
}