# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF="true"

inherit autotools-utils git-2

DESCRIPTION="Library for parsing NMR star files (peak-list format) and CIF files"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
EGIT_REPO_URI="git://burrow-owl.git.sourceforge.net/gitroot/burrow-owl/starparse"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="guile static-libs"

RDEPEND="guile? ( dev-scheme/guile )"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=( $(use_enable guile) )
	autotools-utils_src_configure
}
