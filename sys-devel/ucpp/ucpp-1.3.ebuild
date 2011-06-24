# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="A quick and light preprocessor, but anyway fully compliant to C99"
HOMEPAGE="http://code.google.com/p/ucpp/"
SRC_URI="http://ucpp.googlecode.com/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/tune.h.patch
}

src_compile() {
	emake \
		FLAGS="${CFLAGS} -DSTAND_ALONE" \
		CC=$(tc-getCC) \
		STAND_ALONE="-DSTAND_ALONE" || die
}

src_install() {
	dolib.a lib${PN}.a || die
	doman ${PN}.1 || die
	dobin ${PN} || die
	dodoc README || die
}
