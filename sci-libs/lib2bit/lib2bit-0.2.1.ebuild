# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="C library for accessing 2bit files"
HOMEPAGE="https://github.com/dpryan79/lib2bit"
SRC_URI="https://github.com/dpryan79/lib2bit/archive/0.2.1.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	default
	epatch "${FILESDIR}"/${P}_respect_DESTDIR.patch
	sed -e 's#/usr/local#/usr#' -i Makefile || die
}

src_install(){
	emake DESTDIR="${ED}" install
	if not use static; then
		rm "${ED}"/usr/lib/lib2bit.a || die
	fi
}
