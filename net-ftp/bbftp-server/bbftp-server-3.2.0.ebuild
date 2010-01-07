# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="bbFTP is a file transfer software. It implements its own transfer protocol, which is optimized for large files (larger than 2GB) and secure as it does not read the password in a file and encrypts the connection information."

HOMEPAGE="http://doc.in2p3.fr/bbftp/"
SRC_URI="http://doc.in2p3.fr/bbftp/dist/${P}.tar.gz"
S="${WORKDIR}/${P}/bbftpd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl pam"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-deffixes.patch
}

src_compile() {
	sed -i -e '/@INSTALL@\|mkdir/s:${\(prefix\|mandir\|bindir\)}:${DESTDIR}${\1}:' -e '/\/etc/d' Makefile.in
	econf $(use_with ssl) $(use_with pam) --with-gzip \
		--without-rfio \
		--without-afs || die "configure failed"
	emake
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

