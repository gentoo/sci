# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="Extract catalogs of sources from astronomical FITS images."
HOMEPAGE="http://terapix.iap.fr/soft/sextractor"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND=""
RESTRICT="test"

src_compile() {
	CONFDIR=/usr/share/${PN}/config
	# change default configuration files location from current dir
	sed -i -e "s:default\.:${CONFDIR}/default\.:" src/preflist.h
	local myconf
	[[ "$(tc-getCC)" == "icc" ]] \
		&& myconf="${myconf} --enable-icc"
	econf "${myconf}" || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog HISTORY README THANKS
	insinto ${CONFDIR}
	doins config/*
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*
	fi
}

pkg_postinst() {
	elog "SExtractor configuration files are located"
	elog "in ${CONFDIR} and loaded by default."
}
