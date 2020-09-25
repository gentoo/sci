# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs cmake

DESCRIPTION="library for processing UTF-8 encoded Unicode strings"
HOMEPAGE="http://www.public-software-group.org/utf8proc"
SRC_URI="https://github.com/JuliaLang/utf8proc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${P}-libdir.patch )

src_configure() {
	local mycmakeargs=(
		-DUTF8PROC_INSTALL=ON
		-DUTF8PROC_ENABLE_TESTING=$(usex test)
	)
	cmake_src_configure
}