# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Secure file transfer software with its own transfer protocol optimized for files larger than 2GB"

HOMEPAGE="http://doc.in2p3.fr/bbftp/"
SRC_URI="http://doc.in2p3.fr/bbftp/dist/${P}.tar.gz"
S="${WORKDIR}/${P}/bbftpd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pam ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/${P}"
	epatch "${FILESDIR}"/${PV}-deffixes.patch
}

src_compile() {
	sed -i -e '/@INSTALL@\|mkdir/s:${\(prefix\|mandir\|bindir\)}:${DESTDIR}${\1}:' -e '/\/etc/d' Makefile.in
	econf $(use_with ssl) $(use_with pam) --with-gzip \
		--without-rfio \
		--without-afs || die "configure failed"
	emake || die "compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	newinitd "${FILESDIR}/bbftpd.init.d" bbftpd
	dodoc ../README ../ChangeLog ../TODO
	dodoc ../doc/*
	doman ../doc/bbftpd.1
	if use pam; then
		echo -e "#%PAM-1.0\nauth include system-auth\naccount include system-auth" >> "${T}/bbftp.pam"
		insinto /etc/pam.d
		newins "${T}/bbftp.pam" bbftp
	fi
}
