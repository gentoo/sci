# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ wrappers for SIMD intrinsics and math implementations"
HOMEPAGE="https://github.com/xtensor-stack/xsimd"
SRC_URI="https://github.com/xtensor-stack/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/doctest )"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}"/remove-libdir-in-pc.patch )

src_configure() {
	local mycmakeargs=( -DBUILD_TESTS="$(usex test ON OFF)" )
	cmake_src_configure
}
