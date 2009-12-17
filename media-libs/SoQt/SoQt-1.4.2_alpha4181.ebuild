# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

EAPI="2"

inherit flag-o-matic

DESCRIPTION="The glue between Coin3D and Qt"
SRC_URI="http://omploader.org/vMnl1Zw/${P}.tar.gz"
HOMEPAGE="http://www.coin3d.org/"

SLOT="0"
LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="=media-libs/coin-3.1.2[javascript]
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	append-ldflags $(no-as-needed)
	econf --with-coin --disable-html-help $(use_enable doc html) htmldir=/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README* || die "dodoc failed"
}
