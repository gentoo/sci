# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools eutils

DESCRIPTION="Enhance astronomical object extraction with neural network filters"
HOMEPAGE="http://www.astromatic.net/software/eye"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc threads"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable threads)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS BUGS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die "pdf doc install failed"
	fi
}
