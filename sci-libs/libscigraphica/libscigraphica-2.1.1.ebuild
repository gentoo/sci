# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Libraries for Scigraphica - a scientific application for data analysis and technical graphics"
SRC_URI="mirror://sourceforge/scigraphica/${P}.tar.gz"
HOMEPAGE="http://scigraphica.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"

DEPEND=">=x11-libs/gtk+extra-2.1.0
	>=dev-lang/python-2
	>=dev-python/numarray-1.3.1
	>=dev-libs/libxml2-2.4.10
	>=media-libs/libart_lgpl-2.3"

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

