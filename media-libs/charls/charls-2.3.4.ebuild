# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ JPEG-LS library implementation"
HOMEPAGE="https://github.com/team-charls/charls"
SRC_URI="https://github.com/team-charls/charls/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	# It doesn't seem like there is an automated way to run the test programs
	# The samples option builds them, but do not install the resulting binaries
	local mycmakeargs=(
		-DCHARLS_BUILD_TESTS=OFF
		-DCHARLS_BUILD_FUZZ_TEST=OFF
		-DCHARLS_BUILD_SAMPLES=OFF
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}
