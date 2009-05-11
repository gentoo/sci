# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils flag-o-matic autotools multilib

DESCRIPTION="A 3D data visualization tool"
HOMEPAGE="http://www.opendx.org/"
SRC_URI="http://opendx.sdsc.edu/source/${P/open}.tar.gz"

LICENSE="IPL-1"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

IUSE="hdf cdf netcdf tiff imagemagick szip smp"

DEPEND="x11-libs/libXmu
	x11-libs/libXi
	x11-libs/libXp
	x11-libs/libXpm
	x11-libs/openmotif
	szip? ( sci-libs/szip )
	hdf? ( sci-libs/hdf )
	cdf? ( sci-libs/cdf )
	netcdf? ( sci-libs/netcdf )
	tiff? ( media-libs/tiff )
	imagemagick? ( >=media-gfx/imagemagick-5.3.4[-hdri] )"

RDEPEND="${DEPEND}"
# waiting on bug #36349 for media-libs/jasper in imagemagick

S="${WORKDIR}/${P/open}"

src_prepare() {

	epatch "${FILESDIR}/${PN}-4.3.2-sys.h.patch"
	epatch "${FILESDIR}/${P}-install.patch"
	epatch "${FILESDIR}/${P}-xdg.patch"
	epatch "${FILESDIR}/${P}-gcc43-fedora.patch"
	epatch "${FILESDIR}/${P}-dx-errno.patch"
	epatch "${FILESDIR}/${P}-libtool.patch"
	epatch "${FILESDIR}/${P}-concurrent-make-fix.patch"
	epatch "${FILESDIR}/${P}-open.patch"

	eautoreconf
}

src_configure() {
	# check flag filtering
	# with gcc 3.3.2 I had an infinite loop on src/exec/libdx/zclipQ.c
	append-flags -fno-strength-reduce

	# (#82672)
	filter-flags -finline-functions
	replace-flags -O3 -O2

	# opendx uses this variable
	local GENTOOARCH="${ARCH}"
	unset ARCH

	local morelibs=""
	use szip && morelibs="-lsz"
	econf LIBS="${morelibs}" \
		"--libdir=/usr/$(get_libdir)" \
		"--with-x" \
		"--without-javadx" \
		$(use_with cdf) \
		$(use_with netcdf) \
		$(use_with hdf) \
		$(use_with tiff) \
		$(use_with imagemagick magick) \
		$(use_enable smp smp-linux)

	ARCH="${GENTOOARCH}"
#	javadx is currently broken. we may try to fix it someday.
}

src_compile() {
	local GENTOOARCH="${ARCH}"
	unset ARCH

	emake || die
	ARCH="${GENTOOARCH}"
}

src_install() {
	emake DESTDIR="${D}" install || die

	newicon "src/uipp/ui/icon50.xpm" "${PN}.xpm"
	make_desktop_entry dx "openDX" "${PN}.xpm" "DataVisualization;Education;Science;"
}

pkg_postinst() {
	elog "This version of the opendx ebuild is still under development."
	elog "suggestions, comments and offer of help welcome"
	elog "post a message in gentoo-science or pop up on irc on #gentoo-science"
}
