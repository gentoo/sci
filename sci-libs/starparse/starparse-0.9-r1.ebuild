# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 1-8 )
inherit guile-single

DESCRIPTION="Library for parsing NMR star files (peak-list format) and CIF files"
HOMEPAGE="http://burrow-owl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/burrow-owl/starparse/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="guile test"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( guile ) guile? ( ${GUILE_REQUIRED_USE} )"

RDEPEND="guile? ( ${GUILE_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	if use guile; then
		guile-single_src_prepare
	fi
}

pkg_setup() {
	if use guile; then
		guile-single_pkg_setup
	fi
}

src_configure() {
	econf $(use_enable guile)
}

src_install() {
	default
	if use guile; then
		guile_unstrip_ccache
	fi
}
