# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="MPIR is an open source multiprecision integer library derived from version 4.2.1 of gmp"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nocxx"
DEPEND=""

RDEPEND="${DEPEND}"

src_configure() {
	# A hack for amd64
	unset ABI

	econf $(use_enable !nocxx cxx) \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
