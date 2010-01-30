# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils versionator autotools

DESCRIPTION="MPIR is a library for arbitrary precision integer arithmetic derived from version 4.2.1 of gmp"
HOMEPAGE="http://www.mpir.org/"
SRC_URI="http://www.mpir.org/${PN}-$(replace_version_separator 3 -).tar.gz"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nocxx"

DEPEND="dev-lang/yasm"
RDEPEND=""

src_prepare(){
	epatch "${FILESDIR}/${P}-yasm.patch"
	eautoreconf
}

src_configure() {
	unset ABI

	econf $(use_enable !nocxx cxx) \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS
}
