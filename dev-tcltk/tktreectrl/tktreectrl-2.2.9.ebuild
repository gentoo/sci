# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="A flexible listbox widget for Tk"
HOMEPAGE="http://tktreectrl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="tktreectrl"
SLOT="0"
IUSE="X debug shellicon threads"
KEYWORDS="~x86 ~amd64"
RESTRICT="mirror"

RDEPEND=">=dev-lang/tcl-8.4"
DEPEND="${REDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-as-needed.patch
	)

src_compile() {
	econf \
	$(use_enable threads) \
	$(use_enable shellicon) \
	$(use_enable amd64 64bit) \
	$(use_enable debug symbols) \
	$(use_enable X x) \
	--enable-shared
	emake || die
}

src_test() {
	emake test || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ChangeLog README.txt
	mv "${D}"/usr/lib/treectrl${PV}/htmldoc "${D}"/usr/share/doc/${P}/
}
