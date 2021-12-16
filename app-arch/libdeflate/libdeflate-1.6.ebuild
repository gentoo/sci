# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Heavily optimized DEFLATE/zlib/gzip (de)compression"
HOMEPAGE="https://github.com/ebiggers/libdeflate"
SRC_URI="https://github.com/ebiggers/libdeflate/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

src_install() {
	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi
	emake install DESTDIR="${ED}" PREFIX=/usr LIBDIR=/usr/"$(get_libdir)"
	dodoc NEWS README.md
}
