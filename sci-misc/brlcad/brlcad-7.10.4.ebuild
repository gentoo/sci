# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

DESCRIPTION="Constructive Solid Geometry (CSG) solid modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug examples"

DEPEND="media-libs/libpng
	media-libs/urt
	>=sci-libs/tnt-3
	sci-libs/jama"
#	>=dev-lang/tcl-8.5
#	>=dev-lang/tk-8.5
#	dev-tcltk/blt
#	dev-tcltk/tkimg"

BRLCAD_DIR=/usr/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/brlcad-tcltk-man_install.patch
}

src_compile() {
	# add these two when tcl/tk >=8.5 and others are workable alternative
	# together with adding them in DEPEND
	#	--disable-itcl-build \
	#	--disable-iwidgets-install \
	#	--disable-tcl-build \
	#	--disable-tk-build \
	#	--disable-tkimg-build \
	#	--disable-blt-build \

	# use configure and not econf to put all stuff in $INSTALLDIR
	./configure \
		--prefix=${BRLCAD_DIR} \
		--disable-regex-build \
		--disable-termlib-build \
		--disable-png-build \
		--disable-zlib-build \
		--disable-urt-build \
		--disable-jove-build \
		--disable-adrt-build \
		--disable-tnt-build \
		$(use_enable examples models) \
		$(use_enable debug) \
		$(use_enable debug runtime-debug) \
		$(use_enable debug verbose) \
		$(use_enable debug warnings) \
		$(use_enable debug progress) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die	"emake install failed"
	cat <<-EOF > 99brlcad
		PATH=${BRLCAD_DIR}/bin
		LDPATH=${BRLCAD_DIR}/lib
		MANPATH=${BRLCAD_DIR}/man
		INFOPATH=${BRLCAD_DIR}/info
	EOF
	doenvd 99brlcad || die "doenvd failed"
	dodoc README NEWS TODO AUTHORS HACKING ChangeLog || die "dodoc failed"
}

pkg_postinst() {
	einfo "The standard starting point for BRL-CAD is the mged"
	einfo "command.  Examples are available in ${BRLCAD_DIR}/db."
	einfo "To run an example, try:"
	einfo "${BRLCAD_DIR}/bin/mged ${BRLCAD_DIR}/db/havoc.g"
	einfo "In the mged terminal window, type 'draw havoc' to see"
	einfo "the wireframe in the visualization window."
}
