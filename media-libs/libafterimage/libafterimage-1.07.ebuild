# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

MY_PN="libAfterImage"

DESCRIPTION="Afterstep's standalone generic image manipulation library"
HOMEPAGE="http://www.afterstep.org/afterimage/index.php"
SRC_URI="ftp://ftp.afterstep.org/stable/${MY_PN}/${MY_PN}-${PV}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="gif jpeg mmx nls png tiff"

RDEPEND="media-libs/freetype
	|| ( (	x11-libs/libXpm
			x11-libs/libICE
			x11-libs/libSM
			x11-libs/libXext
			x11-libs/libXrender
			x11-libs/libX11
		  )
		virtual/x11
		)
	png?  ( >=media-libs/libpng-1.2.5 )
	jpeg? ( >=media-libs/jpeg-6b )
	gif?  ( >=media-libs/giflib-4.1.0 )
	tiff? ( >=media-libs/tiff-3.5.7 )"

DEPEND="${RDEPEND}
	!x11-wm/afterstep"

S="${WORKDIR}/${MY_PN}-${PV}"


src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-makefiles.patch
	eautoreconf
}

src_compile() {

	econf \
		$(use_enable nls i18n) \
		$(use_enable mmx mmx-optimization) \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with gif) \
		$(use_with tiff) \
		--without-builtin-ungif \
		--enable-sharedlibs \
		--disable-staticlibs \
		--without-afterbase \
		--enable-glx \
		--with-x \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	dodir /usr/include
	dodir /usr/bin
	dodir /usr/$(get_libdir)
	make DESTDIR=${D} install || die "make install failed"
	dodoc ChangeLog README
}
