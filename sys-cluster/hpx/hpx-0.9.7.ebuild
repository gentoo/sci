# Copyright 2014-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [ ${PV} == "9999" ] ; then
	inherit git-3
	EGIT_REPO_URI="https://github.com/STEllAR-GROUP/hpx.git"
	SRC_URI=""
	KEYWORDS=""
	S="${WORKDIR}/${PN}"
	CMAKE_USE_DIR="${S}"
else
	SRC_URI="http://stellar.cct.lsu.edu/files/${PN}_${PV}.7z"
	KEYWORDS="~amd64 ~ppc ~x86"
	S="${WORKDIR}/${PN}_${PV}"
fi

inherit cmake-utils

DESCRIPTION="A general C++ runtime system for parallel and distributed applications of any scale"
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"

SLOT="0"
LICENSE="Boost-1.0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.48"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/hpx-0.9.5-install-path.patch" )

src_configure() {
	CMAKE_BUILD_TYPE=Release
	cmake-utils_src_configure
}
