# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/wxmaxima/wxmaxima-0.7.4.ebuild,v 1.6 2008/04/19 09:46:48 bicatali Exp $

WX_GTK_VER="2.8"
inherit eutils autotools wxwidgets fdo-mime

MYP=wxMaxima-${PV}

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit."
HOMEPAGE="http://wxmaxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="unicode"

DEPEND=">=dev-libs/libxml2-2.5.0
	>=x11-libs/wxGTK-2.8.7"
RDEPEND="${DEPEND}
	>=sci-mathematics/maxima-5.14.0"

S="${WORKDIR}/${MYP}"

src_compile () {

	# consistent package names
	sed -i \
		-e "s:${datadir}/wxMaxima:${datadir}/${PN}:g" \
		Makefile.in data/Makefile.in || die "sed failed"

	sed -i \
		-e 's:share/wxMaxima:share/wxmaxima:g' \
		src/wxMaxima.cpp || die "sed failed"

	econf \
		--enable-dnd \
		--enable-printing \
		--with-wx-config=${WX_CONFIG} \
		$(use_unicode unicode-glyphs) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	doicon wxmaxima.png
	make_desktop_entry wxmaxima wxMaxima wxmaxima
	dodir /usr/share/doc/${PF}
	dosym /usr/share/${PN}/README /usr/share/doc/${PF}/README
	dodoc AUTHORS
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
