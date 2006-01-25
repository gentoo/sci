# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic

DESCRIPTION="Extract catalogs of sources from astronomical FITS images."
HOMEPAGE="http://terapix.iap.fr/soft/sextractor"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="static doc icc"
DEPEND="icc? ( dev-lang/icc >= 9 )"
RDEPEND=""

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
	dodoc AUTHORS BUGS ChangeLog HISTORY README THANKS
	insinto ${CONFDIR}
	doins config/*
	if use doc; then
		insinto /usr/share/doc/${PF} 
		doins doc/*
	fi
}

pkg_postinst() {
	einfo
    einfo "SExtractor configuration files are located"
    einfo "in ${CONFDIR} and loaded by default."
	einfo
}

