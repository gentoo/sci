# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/qtiplot/qtiplot-0.8.4.ebuild,v 1.1 2006/05/18 15:54:43 cryos Exp $

inherit eutils multilib qt3

DESCRIPTION="Qt based clone of the Origin plotting package"
HOMEPAGE="http://soft.proindependent.com/qtiplot.html"
SRC_URI="http://soft.proindependent.com/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="$(qt_min_version 3.3)
	=x11-libs/qwt-4*
	>=x11-libs/qwtplot3d-0.2.6
	>=sci-libs/gsl-1.6
	>=sys-libs/zlib-1.2.3"

S=${WORKDIR}/${P}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	mv "${PN}.pro" "${PN}.pro.orig"
	tr -d '\r' < "${PN}.pro.orig" | sed -e '/^win32:/d' -e 's/^unix://' > "${PN}.pro"
	epatch "${FILESDIR}/${P}-qmake.patch" || die "epatch failed"
	sed -i -e "s|_LIBDIR_|/usr/$(get_libdir)|" ${PN}.pro || die "sed failed."
}

src_compile() {
	${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake ${PN}.pro || die 'qmake failed.'
	emake || die 'emake failed.'
}

src_install() {
	make_desktop_entry qtiplot qtiplot qtiplot Graphics
	dobin qtiplot || die 'Binary installation failed.'
}
