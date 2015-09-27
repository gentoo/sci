# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Secure file transfer software with its own transfer protocol optimized for files larger than 2GB"
HOMEPAGE="http://doc.in2p3.fr/bbftp/"
SRC_URI="http://doc.in2p3.fr/bbftp/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl:0 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/bbftpc"

src_prepare() {
	sed \
		-e '/@INSTALL@\|mkdir/s:${\(prefix\|mandir\|bindir\)}:${DESTDIR}${\1}:' \
		-e '/\/etc/d' \
		-i Makefile.in || die
	tc-export CC
}

src_configure() {
	econf \
		$(use_with ssl) \
		--with-gzip \
		--without-rfio \
		--without-afs
}

src_install() {
	DOCS=( ../README ../ChangeLog ../TODO ../doc/. )
	default
	doman ../doc/bbftp.1
}
