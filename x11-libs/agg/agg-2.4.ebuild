# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Anti-Grain Geometry - A High Quality Rendering Engine for C++"
HOMEPAGE="http://antigrain.com/"
SRC_URI="http://antigrain.com/${P}.tar.gz"
# get license from http://www.fsf.org/licensing/licenses/index_html#ModifiedBSD
LICENSE="ModifiedBSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl truetype X"

DEPEND="sdl? ( >=media-libs/libsdl-1.2.0 )
	X? ( || ( x11-libs/libX11 virtual/x11 ) )
	truetype? ( >=media-libs/freetype-2 )"

src_compile() {
	# work around buggy sdl test
	use sdl || sed -i -e 's/sdl//' src/platform/Makefile.am

	eautoreconf || die "eautoreconf failed"
	# examples are not (yet) installed, so do not compile them
	econf \
		--enable-ctrl \
		--enable-gpc \
		--disable-examples \
		$(use_enable sdl sdltest) \
		$(use_enable truetype freetype) \
		$(use_with X x) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc readme authors ChangeLog news
}
