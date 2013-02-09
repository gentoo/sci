# Copyright 2013-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Command line tools for developing high performance multi threaded programs"
HOMEPAGE="http://code.google.com/p/likwid/"
SRC_URI="http://likwid.googlecode.com/files/${P}.0.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE="+access-daemon"

src_prepare() {
	use access-daemon && epatch "${FILESDIR}/use_access_daemon.patch"
	epatch "${FILESDIR}/likwid.patch"
	sed -i -e "s:/usr/local:${D}/usr:" config.mk || die "Couldn't set prefix!"
}

src_compile() {
	default
	emake likwid-bench
}

pkg_preinst() {
	use access-daemon && fperms 4755 /usr/bin/likwid-accessD
}
