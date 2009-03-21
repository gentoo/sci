# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="C software to implement JPEG image compression and"
HOMEPAGE="decompressionftp://ftp.uu.net/graphics/jpeg"
SRC_URI="ftp://ftp.uu.net/graphics/jpeg/jpegsrc.v${PV}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"/jpeg-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-destdir.patch
}

src_test() {
	emake test || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README {wizard,usage,libjpeg,structure}.doc change.log || die "no docs"
}
