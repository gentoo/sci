# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C math library supporting IEEE 754 floating-point arithmetic"
HOMEPAGE="https://www.netlib.org/fdlibm"
SRC_URI="https://github.com/batlogic/fdlibm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}/${PN}-no-Werror.patch"
)

src_prepare() {
	mv CMakelists.txt CMakeLists.txt || die
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	mv "${ED}/usr/lib" "${ED}/usr/$(get_libdir)" || die
}
