# Copyright 2013-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

SRC_URI="http://www.libgeodecomp.org/archive/${P}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~x86"
S="${WORKDIR}/${P}/src"

inherit cmake-utils

DESCRIPTION="An auto-parallelizing library to speed up computer simulations"
HOMEPAGE="http://www.libgeodecomp.org"

LICENSE="LGPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/boost-1.48"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/cmake.patch" )

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
