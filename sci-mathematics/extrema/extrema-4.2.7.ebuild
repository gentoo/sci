# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils

DESCRIPTION="Interactive data analysis and visualization tool"
HOMEPAGE="http://exsitewebware.com/extrema/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
SRC_URI="mirror://sourceforge/extrema/${P}.tar.gz"
DEPEND=">=x11-libs/wxGTK-2.6.3
	dev-libs/libxml2
	dev-util/desktop-file-utils"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="nomirror"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog 
	use doc && dodoc doc/*
	make_desktop_entry "${PN}"
	dodir /usr/share/icons/hicolor
	tar xjf extrema_icons.tar.bz2 -C "${D}usr/share/icons/hicolor"
}

pkg_postinst() {
	update-desktop-database /usr/share/applications
}

pkg_postrm() {
	update-desktop-database /usr/share/applications
}
