# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The BRL-CAD package is a powerful Constructive Solid Geometry (CSG) solid modeling system."
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL LGPL GFDL BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="java pic debug proengineer optimize" 

DEPEND=">=media-libs/libsdl-1.2.0
	>=dev-lang/tcl-8.4
	>=dev-lang/tk-8.4
	media-libs/libpng
	sys-libs/zlib
	>=dev-tcltk/itcl-3.3
	>=dev-tcltk/iwidgets-4.0.0
	java? ( virtual/jdk )"
#	>=dev-tcltk/itk-3.3
#	>=media-gfx/urt-3.1b
pkg_setup() {
	if [[ "x$TCL_LIBRARY" = "x" ]]; then
		ewarn "TCL_LIBRARY environment variable not set."
		ewarn "This will probably cause the build to fail."
		einfo "To fix manualy log as root and do:"
		einfo "echo >/etc/env.d/50tcl TCL_LIBRARY=\"/usr/lib/tcl8.4\""
		einfo "env-update"
		einfo "source /etc/profile"
		einfo "See bug #104769 on http://bugs.gentoo.org"
	fi
}
#src_unpack() {
#	unpack ${A}
#	cd ${S}
#	epatch ${FILESDIR}/${PF}-gentoo.diff
	# We must rebuild ./configure, becouse the patch modifies configure.ac.
#	rm configure
#	autoconf
#	cd ${S}
#}

src_compile() {
	local myconf
	cd ${S}
	myconf="${myconf} --enable-regexp-build=no --enable-png-build=no \
	--enable-zlib-build=no --enable-urt-build=no --enable-termlib-build=no \
	--enable-tcl-build=no --enable-tk-build=no --enable-itcl-build=no \
	--enable-iwidgets-build=no --enable-urt-build=no"

	use proengineer && einfo "Enabling pro-engineer plugin support." && 
		myconf="${myconf} --enable-pro-engineer-plugin"
	use java && einfo "Configuring with jdk support." && 
		myconf="${myconf} --with-jdk=`java-config -O`"
	use pic && einfo "Configuring for pic code." && 
		myconf="${myconf} --with-pic"
	use debug && einfo "Debuging support enabled" && 
		myconf="${myconf} --enable-debug" ||
		myconf="${myconf} --disable-debug"
	use optimize && einfo "Enabling optimizations." && 
		myconf="${myconf} --enable-optimized"

	BC_RETRY=no econf $myconf || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	einfo install
	DESTDIR="${D}" emake install || die	"emake install failed"
}

