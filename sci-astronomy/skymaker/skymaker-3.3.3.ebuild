# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools eutils

DESCRIPTION="Program that simulates astronomical images"
HOMEPAGE="http://www.astromatic.net/software/skymaker"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

DEPEND=">=sci-libs/fftw-3"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-configure.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable threads)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS BUGS
}
