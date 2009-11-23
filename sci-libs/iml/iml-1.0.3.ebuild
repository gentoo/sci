# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"
IUSE=""

DEPEND="dev-util/pkgconfig
	dev-libs/gmp
	virtual/cblas"
RDEPEND="dev-libs/gmp
	virtual/cblas"

src_prepare() {
	# do not need atlas specifically any cblas will do...
	epatch "${FILESDIR}/${P}-cblas.patch"
	# apply patch supplied by debian bugreport #494819
	epatch "${FILESDIR}/fix-undefined-symbol.patch"
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--with-cblas-lib="$(pkg-config cblas --libs)" \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README
}
