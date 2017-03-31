# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="C library for accessing 2bit files"
HOMEPAGE="https://github.com/dpryan79/lib2bit"
SRC_URI="https://github.com/dpryan79/lib2bit/archive/0.2.1.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}"/${P}_respect_DESTDIR.patch
	default
}
