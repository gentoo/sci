# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Command line tools for developing high performance multi threaded programs"
HOMEPAGE="http://code.google.com/p/likwid/"
SRC_URI="http://gentryx.de/~gentryx/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${P}-paths.patch"
	epatch "${FILESDIR}/${P}-shared_lib.patch"
	sed -i -e "s:/usr/local:${ED}/usr:" config.mk || die "Couldn't set prefix!"
}

src_compile() {
	default
	emake likwid-bench
}

src_install() {
	default
	fperms 4755 /usr/bin/likwid-accessD
}
