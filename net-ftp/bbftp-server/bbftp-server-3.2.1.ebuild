# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Secure file transfer software with its own transfer protocol optimized for files larger than 2GB"
HOMEPAGE="http://doc.in2p3.fr/bbftp/"
SRC_URI="http://doc.in2p3.fr/bbftp/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pam ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/bbftpd"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-deffixes.patch

	sed \
		-e '/@INSTALL@\|mkdir/s:${\(prefix\|mandir\|bindir\)}:${DESTDIR}${\1}:' \
		-e '/\/etc/d' \
		-i Makefile.in

	tc-export CC
}

src_configure() {
	econf \
		$(use_with ssl) \
		$(use_with pam) \
		--with-gzip \
		--without-rfio \
		--without-afs
}

src_install() {
	default

	newinitd "${FILESDIR}"/bbftpd.init.d bbftpd
	dodoc ../README ../ChangeLog ../TODO ../doc/*
	doman ../doc/bbftpd.1
	if use pam; then
		echo -e "#%PAM-1.0\nauth include system-auth\naccount include system-auth" >> "${T}"/bbftp.pam
		insinto /etc/pam.d
		newins "${T}"/bbftp.pam bbftp
	fi
}
