# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib

DESCRIPTION="dev-util/ccache symlinks for sys-devel/clang"
HOMEPAGE="http://ccache.samba.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	dev-util/ccache
	sys-devel/clang
	"
DEPEND=""

S="${T}"

src_install() {
	dosym "/usr/bin/ccache" "/usr/$(get_libdir)/ccache/bin/clang"
	dosym "/usr/bin/ccache" "/usr/$(get_libdir)/ccache/bin/clang++"
}
