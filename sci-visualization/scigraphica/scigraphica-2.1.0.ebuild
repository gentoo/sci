# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Scientific application for data analysis and technical graphics"
SRC_URI="mirror://sourceforge/scigraphica/${P}.tar.gz"
HOMEPAGE="http://scigraphica.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"

DEPEND=">=sci-libs/libscigraphica-2.1.0
	>=dev-python/pygtk-2.8.1-r1
	>=media-libs/imlib-1.9.7"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-configure.in.patch
	sed -i \
		-e "s:/lib:/$(get_libdir):g" \
		configure.in || die "sed for configure.in failed"
	eautoreconf || die "eautoreconf failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install Failed"
	dodoc AUTHORS ChangeLog FAQ.compile \
		INSTALL NEWS README TODO
}

pkg_postinst() {
	ewarn "Please be shure to rm your old scigraphica"
	ewarn "configuration directory."
	ewarn "Otherwise sg won't work."
	sleep 5
}
