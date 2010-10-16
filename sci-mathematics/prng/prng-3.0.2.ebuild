# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="Pseudo-Random Number Generator library"
HOMEPAGE="http://statmath.wu.ac.at/prng/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"
LICENSE="GPL-2"

SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="doc examples static-libs"
DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-shared.patch
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install ||  die "emake install failed"
	dodoc AUTHORS README NEWS ChangeLog KNOWN-PROBLEMS
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins doc/${PN}.pdf || die
	fi
	if use examples; then
		emake distclean -C examples
		rm -f examples/Makefile*
		doins -r examples
	fi
}
