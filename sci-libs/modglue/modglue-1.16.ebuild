# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="C++ library for handling of multiple co-processes"
HOMEPAGE="http://cadabra.phi-sci.com"
SRC_URI="http://cadabra.phi-sci.com/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc"
DEPEND="dev-util/pkgconfig
	>=dev-libs/libsigc++-2.0"
RDEPEND=">=dev-libs/libsigc++-2.0"

src_prepare() {
	# Respect LDFLAGS
	epatch "${FILESDIR}"/${P}-ldflags.patch
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
