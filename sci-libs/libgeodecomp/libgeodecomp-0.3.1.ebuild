# Copyright 2014-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="http://www.libgeodecomp.org"
SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND=">=dev-libs/boost-1.48"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_make doc
}

src_install() {
	DOCS=( ../README )
	use doc && HTML_DOCS=( ../doc/html/* )
	cmake-utils_src_install
}

src_test() {
	cmake-utils_src_make test
}
