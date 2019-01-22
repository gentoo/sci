# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/ebiggers/libdeflate"
SRC_URI="https://github.com/ebiggers/libdeflate/archive/v1.2.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare(){
	sed -e 's/ -O2 / /' -i Makefile || die
	sed -e "s#${DESTDIR}${PREFIX}/lib#${ED}/usr/$(get_libdir)#" -i Makefile || die
	default
}

src_install() {
	default
	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi
}
