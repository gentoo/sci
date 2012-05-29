# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib

DESCRIPTION="dev-util/ccache symlinks for dev-lang/icc"
HOMEPAGE="http://ccache.samba.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	dev-util/ccache
	dev-lang/icc
	"
DEPEND=""

src_install() {
	dosym "/usr/bin/ccache" "/usr/$(get_libdir)/ccache/bin/icc"
	dosym "/usr/bin/ccache" "/usr/$(get_libdir)/ccache/bin/icpc"
}
