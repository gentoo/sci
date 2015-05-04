# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Secure file transfer software with its own transfer protocol optimized for files larger than 2GB"

HOMEPAGE="http://doc.in2p3.fr/bbftp/"
SRC_URI="http://doc.in2p3.fr/bbftp/dist/${P}.tar.gz"
S="${WORKDIR}/${P}/bbftpc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_compile() {
	sed -i -e '/@INSTALL@\|mkdir/s:${\(prefix\|mandir\|bindir\)}:${DESTDIR}${\1}:' -e '/\/etc/d' Makefile.in
	econf $(use_with ssl) --with-gzip \
		--without-rfio \
		--without-afs || die "configure failed"
	emake
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ../README ../ChangeLog ../TODO
	dodoc ../doc/*
	doman ../doc/bbftp.1
}
