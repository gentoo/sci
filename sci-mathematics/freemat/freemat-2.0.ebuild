# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Freemat is a free environment for rapid engineering and scientific prototyping and data processing"
HOMEPAGE="http://freemat.sourceforge.net/"

MY_PN=FreeMat
MY_P="${MY_PN}-${PV}"

RESTRICT="nomirror"
SRC_URI="mirror://sourceforge/freemat/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=sys-libs/ncurses-5.4-r5 virtual/blas virtual/lapack dev-libs/ffcall\
	sci-libs/umfpack sci-libs/arpack sci-libs/matio"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	find -name '*.moc.cpp' | xargs rm -f
	epatch "${FILESDIR}/acinclude.m4.patch"
	epatch "${FILESDIR}/Inspect.cpp.patch"
}

src_compile() {
	autoconf
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
}
