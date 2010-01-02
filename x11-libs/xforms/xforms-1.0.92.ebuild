# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="A graphical user interface toolkit for X"
HOMEPAGE="http://www.nongnu.org/xforms/"
SRC_URI="http://savannah.nongnu.org/download/xforms/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc opengl"

RDEPEND="
	media-libs/jpeg
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXpm
	x11-proto/xproto
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"

src_prepare() {
	rm "${S}"/config/libtool.m4 "${S}"/acinclude.m4
	AT_M4DIR=config eautoreconf
}

src_configure() {
	local myopts
	use opengl || myopts="--disable-gl"
	use doc && myopts="${myopts} --enable-docs"

	econf ${myopts} || die "econf failed"
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS README
}
