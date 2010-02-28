# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Another implementation of the double description method"
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-libs/gmp"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}.patch"
	epatch "${FILESDIR}/makefile.patch"
}

src_compile() {
	export LDFLAGS="${LDFLAGS}"
	export CFLAGS="${CFLAGS}"
	emake \
		CC="$(tc-getCC)" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		GMPLIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		GMPINCLUDE="${EPREFIX}/usr/include" \
		all || die

}

src_install() {
	dobin cddr+ cddf+ || die
}
