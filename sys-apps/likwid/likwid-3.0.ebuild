# Copyright 1999-2014 Gentoo Foundation
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
IUSE="+access-daemon uncore"

src_prepare() {
	epatch "${FILESDIR}/likwid.patch"
	use access-daemon && epatch "${FILESDIR}/use_access_daemon.patch"
	use uncore        && epatch "${FILESDIR}/use_uncore.patch"
	sed -i -e "s:/usr/local:${D}/usr:" config.mk || die "Couldn't set prefix!"
}

src_compile() {
	default
	emake likwid-bench
}

src_install() {
	default
	use access-daemon && fperms 4755 /usr/bin/likwid-accessD
}
