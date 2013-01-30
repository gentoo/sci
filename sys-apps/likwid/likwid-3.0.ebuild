# Copyright 2013-2013 Andreas Schäfer
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Likwid stands for Like I knew what I am doing. This project contributes easy to use command line tools for Linux to support programmers in developing high performance multi threaded programs."
HOMEPAGE="http://code.google.com/p/likwid/"
SRC_URI="http://likwid.googlecode.com/files/${P}.0.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="access-daemon"

src_prepare() {
    if use access-daemon ; then 
	epatch "${FILESDIR}/use_access_daemon.patch"
    fi
    epatch "${FILESDIR}/likwid.patch"
    sed -i -e "s:/usr/local:$D/usr:" config.mk || die "Couldn't set prefix!"
}

src_compile() {
    emake || die "emake failed"
    emake likwid-bench || die "emake likwid-bench failed"
 }

pkg_preinst()
{
    if use access-daemon ; then 
	chmod +s $D/usr/bin/likwid-accessD || die "Couldn't set SUID for access daemon"
    fi
}
