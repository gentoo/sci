# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Intel Instrumentation and Tracing Technology and Just-In-Time API "
HOMEPAGE="https://github.com/intel/ittapi"
SRC_URI="https://github.com/intel/ittapi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	# Make it a shared library
	sed -i -e 's/STATIC/SHARED/g' CMakeLists.txt || die
	cmake_src_prepare
}

src_install() {
	dolib.so "${BUILD_DIR}/bin/"*.so
	doheader -r "${S}/include/"*
	einstalldocs
}
