# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Freemat is a free environment for rapid engineering and scientific prototyping and data processing"
HOMEPAGE="http://freemat.sourceforge.net/"

MY_PN=FreeMat
MY_P="${MY_PN}-${PV}"

#### delete the next line when moving this ebuild to the main tree!
RESTRICT="nomirror"

SRC_URI="mirror://sourceforge/freemat/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=sys-libs/ncurses-5.4-r5 virtual/blas virtual/lapack dev-libs/ffcall\
	sci-libs/umfpack sci-libs/arpack >=x11-libs/qt-4.2"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PN}-${PV}.patch"
}

src_compile() {
	eautoconf
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
}
