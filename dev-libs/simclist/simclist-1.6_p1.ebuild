# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="SimCList is a high quality C (C++ embeddable) library for handling lists"
HOMEPAGE="https://mij.oltrelinux.com/devel/simclist"
COMMIT=6aef848d1743af66045a6f413cd3b8b1f1578c15
SRC_URI="https://github.com/mij/simclist/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc dump hash threads"

BDEPEND="doc? ( app-text/doxygen )"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	sed -i -e "/-O2/d" CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSIMCLIST_DEBUG=$(usex debug)
		-DSIMCLIST_THREADING=$(usex threads)
		-DSIMCLIST_NO_DUMPRESTORE=$(usex dump)
		-DSIMCLIST_ALLOW_LOCATIONBASED_HASHES=$(usex hash)
	)
	cmake_src_configure
}

src_compile(){
	cmake_src_compile
	if use doc; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	doheader simclist.h
	dolib.so libsimclist.so

	if use doc ; then
		dodoc -r doc/html/*
	fi
}
