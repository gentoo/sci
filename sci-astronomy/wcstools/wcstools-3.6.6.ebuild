# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs autotools

DESCRIPTION="Astronomy Library to handle World Coordinate System for FITS images"
HOMEPAGE="http://tdc-www.harvard.edu/software/wcstools"
SRC_URI="http://tdc-www.harvard.edu/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	# fixed some warnings
	epatch "${FILESDIR}"/${P}-codewarn.patch
	# autotoolization
	epatch "${FILESDIR}"/${P}-autotools.patch
	cd "${S}"
	eautoreconf
}

src_install () {
	emake DESTDIR=${D} install || die "emake install failed"
	doman Man/man1/*
	dodoc Readme Programs NEWS
	docinto libwcs
	dodoc libwcs/{Readme,NEWS}
}
