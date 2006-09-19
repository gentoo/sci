# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="Converts astronomical FITS images to the TIFF format for illustration purposes."
HOMEPAGE="http://terapix.iap.fr/soft/stiff"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="doc icc"
DEPEND="icc? ( dev-lang/icc )"
RDEPEND=""

src_compile() {
	# trust cflags to be optimized.
	filter-flags ${CFLAGS}
	econf \
		$(use_enable icc) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog HISTORY README THANKS
	use doc && dodoc doc/*
}
