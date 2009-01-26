# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A suite of programmes to process and view NMR data"
HOMEPAGE="http://www.bio.cam.ac.uk/azara/"
SRC_URI="http://www.bio.cam.ac.uk/ccpn/download/${PN}/${P}-src.tar.gz"

LICENSE="AZARA"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="opengl X xpm"
RDEPEND=""
DEPEND="${RDEPEND}
	xpm? ( x11-libs/libXpm )
	X? ( x11-libs/libX11 )"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	echo "" > ENVIRONMENT

	epatch "${FILESDIR}"/help-makefile.patch
}


src_compile() {

	local mymake
	local XPMUSE

	mymake="${mymake} help nongui"
	use X && mymake="${mymake} gui"
	use opengl && mymake="${mymake} gl"
	use xpm && XPMUSE="XPM_FLAG=-DUSE_XPM XPM_LIB=-lXpm"

	emake -j1 CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		MATH_LIB="-lm" \
		X11_INCLUDE_DIR="-I/usr/X11R6/include" \
		MOTIF_INCLUDE_DIR="-I/usr/include" \
		X11_LIB_DIR="-L/usr/$(get_libdir)" \
		MOTIF_LIB_DIR="-L/usr/$(get_libdir)" \
		${XPMUSE} \
		X11_LIB="-lX11" \
		MOTIF_LIB="-lXm -lXt" \
		GL_INCLUDE_DIR="-I/usr/X11R6/include -I/usr/include" \
		GL_LIB_DIR="-I/usr/lib" \
		GL_LIB="-lglut -lGLU -lGL -lXmu -lX11 -lXext" \
		ENDIAN_FLAG="-DLITTLE_ENDIAN_DATA" \
		${mymake} || \
	die "make failed"

}

src_install() {

	for bin in bin/*; do
		dobin "${bin}" || die "failed to install ${bin}"
	done

	mv "${D}"/usr/bin/{,azara-}extract || die "failed to fix extract collision"

	dodoc CHANGES* README*
	dohtml html/*
}

pkg_postinst() {
	einfo "Due to collision we moved the extract binary to azara-extract"
}
