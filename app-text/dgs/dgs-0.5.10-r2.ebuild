# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Upstream is dead.

EAPI=5

WANT_AUTOCONF="2.1"

inherit autotools eutils

DESCRIPTION="A Ghostscript based Display Postscript (DPS) server"
HOMEPAGE="http://www.gnustep.org/developers/DGS.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/old/dgs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~hppa ~mips ~ppc64 ~ia64"
IUSE="tcpd"
RDEPEND="
	dev-libs/glib:1
	!<x11-base/xorg-x11-7"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"

DOCS=( ANNOUNCE ChangeLog FAQ NEWS NOTES README STATUS TODO Version )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gs-time_.h-gentoo.diff \
		"${FILESDIR}"/${P}-tcpd-gentoo.diff \
		"${FILESDIR}"/${P}-gcc-3.4.diff \
		"${FILESDIR}"/${PV}-workaround-include-in-comments.patch \
		"${FILESDIR}"/${PN}-fix-as-needed.patch

	eautoconf
	export MAKEOPTS+=" -j1"
}

src_configure() {
	econf --with-x $(use_enable tcpd)
}

src_install() {
	default

	rm -rf "${D}"/usr/share/man/manm || die
	newman "${S}"/DPS/demos/xepsf/xepsf.man xepsf.1
	newman "${S}"/DPS/demos/dpsexec/dpsexec.man dpsexec.1
	newman "${S}"/DPS/clients/makepsres/makepsres.man makepsres.1
}
