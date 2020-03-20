# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="C library for accessing 2bit files"
HOMEPAGE="https://github.com/dpryan79/lib2bit"
SRC_URI="https://github.com/dpryan79/lib2bit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}_respect_LDFLAGS.patch
	"${FILESDIR}"/${P}_test_support_python3.patch
)

src_install(){
	dodoc README.md
	dolib.so lib2bit.so
	doheader 2bit.h
	if use static; then
		dolib.a lib2bit.a
	fi
}
