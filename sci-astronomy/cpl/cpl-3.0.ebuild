# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="ESO common pipeline library for astronomical data reduction"
HOMEPAGE="http://www.eso.org/observing/cpl/"
SRC_URI="ftp://ftp.hq.eso.org/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND="sci-libs/qfits"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README AUTHORS NEWS TODO BUGS ChangeLog
	if use doc; then
		make htmldir=usr/share/doc/${PF} install-html \
			|| die "make install-html failed"
	fi
}
