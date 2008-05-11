# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils autotools fdo-mime

DESCRIPTION="Universal Data Array Visualization"
HOMEPAGE="http://udav.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

DEPEND="sci-libs/mathgl x11-libs/fltk"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT=mirror

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-fltk.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}"usr/share/doc/udav/pics/.svn
	dodoc README AUTHORS || die "dodoc failed"

	make_desktop_entry ${PN}
	insinto /usr/share/icons/hicolor/48x48/apps
	doins xpm/${PN}.xpm
	dosym /usr/share/icons/hicolor/48x48/apps/${PN}.xpm /usr/share/pixmaps/${PN}.xpm
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
