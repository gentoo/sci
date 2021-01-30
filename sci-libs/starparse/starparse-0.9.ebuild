# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library for parsing NMR star files (peak-list format) and CIF files"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/burrow-owl/starparse/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="guile test"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( guile )"

RDEPEND="guile? ( dev-scheme/guile:12 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf $(use_enable guile)
}
