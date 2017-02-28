# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="High quality C (C++ embeddable) library for handling lists"
HOMEPAGE="http://mij.oltrelinux.com/devel/simclist"
SRC_URI="${HOMEPAGE}/${P/_/}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S="${WORKDIR}/${P/_/}"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_compile(){
	cmake-utils_src_compile
	if use doc; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	doheader simclist.h
	dolib.so "${BUILD_DIR}"/libsimclist.so*
	use doc && dohtml -r "${S}"/doc/html/*
	use examples &&  dodoc -r "${S}"/examples
}
