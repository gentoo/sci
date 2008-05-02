# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils autotools

DESCRIPTION="Universal Data Array Visualization"
HOMEPAGE="http://udav.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

DEPEND="sci-libs/mathgl x11-libs/fltk"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT=mirror

src_unpack() {
	local FLTK_FLAGS,FLTK_LIBS,FLTK_H

	unpack ${A}
	cd "${S}"

	FLTK_FLAGS=`fltk-config --cxxflags`
	FLTK_LIBS=`fltk-config --use-images --ldflags`
	FLTK_H=`echo ${FLTK_FLAGS} | sed -e 's:-I/usr/include/::'`
	[ -n "${FLTK_H}" ] && FLTK_H="${FLTK_H}"/

	epatch "${FILESDIR}"/${PN}-fltk.patch
	sed -e "s:@FLTK_H@:${FLTK_H}:g" \
		-e "s:@FLTK_LIBS@:${FLTK_LIBS}:g" \
		-i configure.ac
	sed -e "s:@FLTK_FLAGS@:${FLTK_FLAGS}:g" \
		-i src/Makefile.am

	eautoreconf
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS || die "dodoc failed"
}
