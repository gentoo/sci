# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="SimCList is a high quality C (C++ embeddable) library for handling lists"
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
	mkdir -p "${D}"/usr/include
	cp simclist.h "${D}"/usr/include/
	cd "${BUILD_DIR}"
	dolib libsimclist.so
	cd "${S}"
	if use doc; then
		dohtml -r doc/html/*
	fi
	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}
