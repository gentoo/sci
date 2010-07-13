# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="Tool for automatic generation of astronomical catalogs"
HOMEPAGE="http://astromatic.iap.fr/software/stuff/"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/stuff/${P}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"

DEPEND=""
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
