# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils versionator

MY_PN=AsmJit
MY_PV=$(replace_version_separator _ -)
MY_PV=${MY_PV/_p/}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="complete x86/x64 JIT-Assembler for C++ language"
HOMEPAGE="http://code.google.com/p/asmjit/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.zip"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-test.patch )

#TODO: Debug is currenlty handled by CMAKE_BUILD_TYPE=debug, fix that

src_prepare() {
	sed -i -e "s:lib):lib\${LIB_SUFFIX}):" CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
	  -DASMJIT_BUILD_LIBRARY=1
	  $(cmake-utils_use test ASMJIT_BUILD_TEST)
	)
	cmake-utils_src_configure
}
