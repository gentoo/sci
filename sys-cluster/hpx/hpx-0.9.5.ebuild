# Copyright 2013-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

MY_P="${PN}_${PV}"

DESCRIPTION="A general C++ runtime system for parallel and distributed applications of any scale"
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"
SRC_URI="http://stellar.cct.lsu.edu/files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.48"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
PATCHES=( "${FILESDIR}/hpx-0.9.5-install-path.patch" )

src_configure() {
	CMAKE_BUILD_TYPE=Release
	cmake-utils_src_configure
}
