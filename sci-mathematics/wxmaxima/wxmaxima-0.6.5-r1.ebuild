# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools wxwidgets

MYP=wxMaxima-${PV}

DESCRIPTION="A Graphical frontend to Maxima, using the wxWidgets toolkit."
HOMEPAGE="http://wxmaxima.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static doc"

DEPEND=">=dev-libs/libxml2-2.5.0
	>=x11-libs/wxGTK-2.6"
RDEPEND=">=sci-mathematics/maxima-5.9.1"

S=${WORKDIR}/${MYP}

src_unpack () {
	unpack ${A}

	sed 's|#PF#|'${PF}'|g' \
		${FILESDIR}/${PF}-docfiles.patch > ${PF}-docfiles.patch

	epatch ${PF}-docfiles.patch

	cd ${S}
	einfo "Regenerating autotools files..."
	eautomake || die "eautomake failed"
}


src_compile () {
	WX_GTK_VER="2.6"
	econf \
		--with-wx-config=${WX_CONFIG} \
		--with-wxbase-config=${WX_CONFIG} \
		$(use_enable static static-wx) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	insinto /usr/share/pixmaps/
	doins maxima-new.png
	make_desktop_entry wxmaxima wxMaxima maxima-new

	cd ${S}/data

	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins docs.zip intro.zip
	fi
}
