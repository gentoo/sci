# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils java-pkg-opt-2

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples java opengl smp X"

RDEPEND="media-libs/libpng
	sys-libs/zlib
	>=sci-libs/tnt-3
	sci-libs/jama
	dev-tcltk/itcl
	dev-tcltk/itk
	dev-tcltk/iwidgets
	dev-tcltk/tkimg
	sys-libs/libtermcap-compat
	media-libs/urt
	java? ( >=virtual/jre-1.5 )
	X? ( x11-libs/libXt x11-libs/libXi )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	java? ( >=virtual/jdk-1.5 )
	doc? ( dev-libs/libxslt )"

BRLCAD_DIR="/usr/${PN}"

src_prepare() {
	#patch a simple Makefile.in since the Makefile.am would need
	#a full and slow autoreconf of many directories
	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_configure() {
	local myitcl="/usr/$(get_libdir)/itcl3.4"
	local myitk="/usr/$(get_libdir)/itk3.4"
	econf \
		--prefix="${BRLCAD_DIR}" \
		--datadir="/usr/share/${PN}" \
		--mandir="/usr/share/man" \
		--disable-almost-everything \
		--disable-regex-build \
		--disable-png-build \
		--disable-zlib-build \
		--disable-urt-build \
		--disable-tcl-build \
		--disable-tk-build \
		--disable-itcl-build \
		--disable-tkimg-build \
		--disable-jove-build \
		--disable-tnt-install \
		--disable-iwidgets-install \
		--enable-opennurbs-build \
		--with-ldflags="-L${myitcl} -L${myitk}" \
		$(use_enable debug) \
		$(use_enable debug optimization) \
		$(use_enable debug runtime-debug) \
		$(use_enable debug strict-build) \
		$(use_enable debug verbose) \
		$(use_enable debug warnings) \
		$(use_enable debug progress) \
		$(use_enable doc documentation) \
		$(use_enable examples models-install) \
		$(use_enable smp parallel) \
		$(use_with java jdk $(java-config -O)) \
		$(use_with opengl ogl) \
		$(use_with X x) \
		$(use_with X x11) \
		LD_LIBRARY_PATH="${myitcl}:${myitk}:${LD_LIBRARY_PATH}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	echo "PATH=${BRLCAD_DIR}/bin" >  99brlcad
	echo "MANPATH=${BRLCAD_DIR}/man" >> 99brlcad
	doenvd 99brlcad || die
}
