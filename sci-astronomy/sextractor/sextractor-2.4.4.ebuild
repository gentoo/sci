# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="Extract catalogs of sources from astronomical FITS images."
HOMEPAGE="http://terapix.iap.fr/soft/${PN}"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static doc icc"
DEPEND="icc? ( dev-lang/icc >= 9 )"

CONFDIR=/usr/share/${PN}/config

src_compile() {
	# trust sextractor cflags to be optimized.
	filter-flags ${CFLAGS}
	# change default configuration files location from current dir
	sed -i -e "s:default\.:${CONFDIR}/default\.:" src/preflist.h
    econf \
        $(use_enable static) \
        $(use_enable icc) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog COPYING HISTORY README THANKS
	dodir /usr/share/${PN}
	dodir ${CONFDIR}
	insinto ${CONFDIR}
	doins config/*
	if use doc; then
		insinto /usr/share/doc/${PF} 
		doins doc/*
	fi
}

pkg_postinst() {
	einfo
    einfo "You can find sextractor configuration files"
    einfo "in /usr/share/${PN}/config and are enabled by default."
	einfo
}

