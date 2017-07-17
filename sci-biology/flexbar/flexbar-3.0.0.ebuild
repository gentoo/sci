# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Barcode, MID tag and adapter sequence removal"
HOMEPAGE="https://github.com/seqan/flexbar"
SRC_URI="https://github.com/seqan/flexbar/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-cpp/tbb
	>=sci-biology/seqan-2.1.1:0
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"

# TODO: need to call 'pkg-config --cflags seqan-2.2' and pass it down
src_configure() {
	local CPPFLAGS=${CPPFLAGS}
	append-cppflags `pkg-config --cflags seqan-2.2`
	local CXXFLAGS="${CXXFLAGS}"
	append-cxxflags "-std=c++14"
	cmake-utils_src_configure
}

# SeqAn requires C++14! You must compile your application with -std=c++14, -std=gnu++14 or -std=c++1y
# https://github.com/seqan/flexbar/issues/8

src_install(){
	elog `pwd`
	dobin ../"${P}"_build/flexbar
	dodoc ../"${P}"/README.md
}
