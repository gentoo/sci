# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils eutils

DESCRIPTION="C++ template static library of common data structures and algorithms"
HOMEPAGE="https://lemon.cs.elte.hu/trac/lemon/"
SRC_URI="http://lemon.cs.elte.hu/pub/sources/${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="coin doc static-libs test tools"

RDEPEND="
	sci-mathematics/glpk
	coin? ( sci-libs/coinor-cbc sci-libs/coinor-clp )"
DEPEND="${RDEPEND}
	test? ( dev-util/valgrind )"

PATCHES=( "${FILESDIR}"/${P}-gcc47.patch )

src_configure() {
	#	$(use_enable test valgrind)
	local myeconfargs=(
		$(use_enable tools)
		$(use_with coin)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && emake DESTDIR="${D}" install-html
}
