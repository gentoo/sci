# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI=2
DESCRIPTION="C++ library for handling of multiple co-processes"
HOMEPAGE="http://www.aei.mpg.de/~peekas/modglue/"
SRC_URI="http://www.aei.mpg.de/~peekas/cadabra/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc"
DEPEND="( >=dev-libs/libsigc++-2.0 )"
RDEPEND="${DEPEND}"

src_prepare() {
#	fix src/makefile.in
	epatch "${FILESDIR}/${P}-makefile.in.patch"
}

src_install() {
	emake DESTDIR="${D}" DEVDESTDIR="${D}" install || die
	use doc && dohtml "${S}/doc/"*
	dodoc AUTHORS ChangeLog INSTALL
}

pkg_postinst() {
	elog "This version of the modglue ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=194393"
}
