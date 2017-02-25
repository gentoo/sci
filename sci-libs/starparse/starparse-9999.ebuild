# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils git-r3

DESCRIPTION="Library for parsing NMR star files (peak-list format) and CIF files"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
EGIT_REPO_URI="git://burrow-owl.git.sourceforge.net/gitroot/burrow-owl/starparse"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="guile static-libs test"

REQUIRED_USE="test? ( guile )"

RDEPEND="guile? ( dev-scheme/guile:12 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-guile1.8.patch )

src_configure() {
	local myeconfargs=( $(use_enable guile) )
	autotools-utils_src_configure
}
