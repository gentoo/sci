# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV//_/-}"

LUA_COMPAT=( lua5-{1..4} )

inherit cmake llvm lua-single

DESCRIPTION="A low-level counterpart to Lua"
HOMEPAGE="http://terralang.org/"
SRC_URI="https://github.com/zdevito/terra/archive/release-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

IUSE="cuda"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}
	cuda? ( dev-util/nvidia-cuda-toolkit )"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/clang:*
	sys-devel/llvm:=
	dev-lang/luajit:=
"

S="${WORKDIR}/${PN}-release-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="$(get_llvm_prefix)"
		-DTERRA_ENABLE_CUDA="$(usex cuda ON OFF)"
		-DTERRA_STATIC_LINK_LLVM=OFF
		-DTERRA_SLIB_INCLUDE_LLVM=OFF
		-DTERRA_STATIC_LINK_LUAJIT=OFF
		-DTERRA_SLIB_INCLUDE_LUAJIT=OFF
	)

	cmake_src_configure
}
