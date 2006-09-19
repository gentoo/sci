# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

DESCRIPTION="Libraries for data analysis and technical graphics"
SRC_URI="mirror://sourceforge/scigraphica/${P}.tar.gz"
HOMEPAGE="http://scigraphica.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"

DEPEND=">=x11-libs/gtk+extra-2.1.0
	>=dev-python/numarray-1.3.1
	>=dev-libs/libxml2-2.4.10
	>=media-libs/libart_lgpl-2.3
	>=dev-util/intltool-0.27.2"

src_unpack() {

	unpack ${A}

	# fixes arrayobject problems
	epatch "${FILESDIR}"/${P}-arrayobject.patch
	# fixes libart_gpl version
	epatch "${FILESDIR}"/${P}-libart.patch
	# fixes intltoolization
	epatch "${FILESDIR}"/${P}-intl.patch

	cd "${S}"
	sed -i \
		-e "s:/lib:/$(get_libdir):g" \
		configure.in || die "sed for configure.in failed"

	einfo "Running intltoolize --copy --force --automake"
	intltoolize --copy --force --automake || die "intltoolize failed"
	eautoreconf
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog FAQ.compile \
		INSTALL NEWS README TODO
}
