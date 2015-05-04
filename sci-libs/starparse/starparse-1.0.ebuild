# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Library for parsing NMR star files (peak-list format) and CIF files"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
# Created from rev 19 @ http://oregonstate.edu/~benisong/software/projects/starparse/releases/1.0
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="guile static-libs"

RDEPEND="guile? ( dev-scheme/guile )"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=( $(use_enable guile) )
	autotools-utils_src_configure
}
