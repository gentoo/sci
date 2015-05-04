# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils eutils

DESCRIPTION="C++ library for handling of multiple co-processes"
HOMEPAGE="http://cadabra.phi-sci.com"
SRC_URI="http://cadabra.phi-sci.com/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

RDEPEND="dev-libs/libsigc++:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	# Respect LDFLAGS
	"${FILESDIR}"/${P}-ldflags.patch
	# fix parallel make. test are made at the same time as the library??
	"${FILESDIR}"/${P}-parallelmake.patch
	# take care of the lib/lib64 problem. Without this modglue installs
	# stuff in /usr/usr/lib64 on 64bits systems.
	"${FILESDIR}"/${P}-lib64.patch
)

src_install() {
	use doc && HTML_DOCS=( "${S}"/doc/. )
	autotools-utils_src_install DEVDESTDIR="${D}"
}

pkg_postinst() {
	elog "This version of the modglue ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=194393"
}
