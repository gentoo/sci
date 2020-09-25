# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C++ parallel agorithms library"
HOMEPAGE="https://github.com/NVIDIA/thrust"
SRC_URI="https://github.com/NVIDIA/thrust/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	local mycmakeargs=(
		-DTHRUST_ENABLE_HEADER_TESTING=OFF
		-DTHRUST_ENABLE_TESTING=OFF
		-DTHRUST_ENABLE_EXAMPLES=OFF
		-DTHRUST_INCLUDE_CUB_CMAKE=OFF
	)
	cmake_src_configure
}
