# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ computer vision research libraries"
HOMEPAGE="https://vxl.github.io/"
SRC_URI="https://github.com/vxl/vxl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/libgeotiff"
RDEPEND="${DEPEND}"

src_install() {
	cmake_src_install
	# install lib files to correct dir
	mv "${ED}/usr/lib" "${ED}/usr/$(get_libdir)"
}
