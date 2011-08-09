# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/brlcad/brlcad-7.18.4.ebuild,v 1.1 2011/04/18 22:47:37 dilfridge Exp $

EAPI=4
inherit cmake-utils eutils

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
# CMAKE_MIN_VERSION="2.8"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="benchmarks debug doc examples opengl smp"

RDEPEND="media-libs/libpng
	sys-libs/zlib
	>=sci-libs/tnt-3
	sci-libs/jama
	=dev-tcltk/itcl-3.4*
	=dev-tcltk/itk-3.4*
	dev-tcltk/iwidgets
	dev-tcltk/tkimg
	dev-tcltk/tkpng
	sys-libs/libtermcap-compat
	media-libs/urt
	x11-libs/libXt
	x11-libs/libXi
	"
	#java? ( >=virtual/jre-1.5 )"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-tcltk/tktable
	>=virtual/jre-1.5
	doc? (
		dev-libs/libxslt
		app-doc/doxygen
	)"

BRLCAD_DIR="${EPREFIX}/usr/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-cmake.patch"
}

src_configure() {
		#waiting for upstream to fix itck/itk issues for cmake
		#have to enable tcl/tk local build, otherwise cmake won't be able to link for
		# -litcl -litk
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${BRLCAD_DIR}"
		-DBRLCAD-ENABLE_STRICT=OFF
		-DBRLCAD_BUILD_LOCAL_OPENNURBS=ON
		-DBUILD_STATIC_LIBS=OFF
		-DBRLCAD-ENABLE_X11=ON
		-DBRLCAD_BUILD_LOCAL_INCRTCL=OFF
		-DBRLCAD_BUILD_LOCAL_TKHTML=OFF
		-DBRLCAD_BUILD_LOCAL_TKPNG=OFF
		-DBRLCAD_BUILD_LOCAL_TKTABLE=OFF
		-DBRLCAD_BUILD_LOCAL_PNG=OFF
		-DBRLCAD_BUILD_LOCAL_REGEX=OFF
		-DBRLCAD_BUILD_LOCAL_ZLIB=OFF
		-DBRLCAD_BUILD_LOCAL_TERMLIB=OFF
		-DBRLCAD_BUILD_LOCAL_UTAHRLE=OFF
		-DBRLCAD_BUILD_LOCAL_SCL=OFF
		-DBRLCAD-ENABLE_RTSERVER=OFF
		-DBRLCAD-ENABLE_JOVE=OFF

		-DBRLCAD_BUILD_LOCAL_IWIDGETS_FORCE_ON=ON
		-DBRLCAD_BUILD_LOCAL_TCL_FORCE_ON=ON
		-DBRLCAD_BUILD_LOCAL_TK_FORCE_ON=ON
		-DBRLCAD_BUILD_LOCAL_ITCL_FORCE_ON=ON
		-DBRLCAD_BUILD_LOCAL_ITK_FORCE_ON=ON

		)

			# use flag triggered options
	if use debug; then
		mycmakeargs += "-DCMAKE_BUILD_TYPE=Debug"
	else
		mycmakeargs += "-DCMAKE_BUILD_TYPE=Release"
	fi
	mycmakeargs+=(
		$(cmake-utils_use amd64 BRLCAD-ENABLE_64BIT)
		$(cmake-utils_use aqua BRLCAD-ENABLE_AQUA)
		$(cmake-utils_use examples BRLCAD-INSTALL_EXAMPLE_GEOMETRY)
		$(cmake-utils_use doc BRLCAD-BUILD_EXTRADOCS)
		$(cmake-utils_use doc BRLCAD-BUILD_EXTRADOCS_PDF)
		$(cmake-utils_use doc BRLCAD-BUILD_EXTRADOCS_MAN)
		$(cmake-utils_use opengl BRLCAD-ENABLE_OPENGL)
		$(cmake-utils_use smp BRLCAD-ENABLE_SMP)
		$(cmake-utils_use debug BRLCAD-ENABLE_VERBOSE_PROGRESS)
#			$(cmake-utils_use !debug BRLCAD-ENABLE_OPTIMIZED_BUILD)
#			$(cmake-utils_use !debug )
#			$(cmake-utils_use debug BRLCAD-ENABLE_DEBUG_BUILD)
#			$(cmake-utils_use debug BRLCAD-ENABLE_RUNTIME_DEBUG)
#			$(cmake-utils_use debug BRLCAD-ENABLE_COMPILER_WARNINGS_LABEL)
			)
	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
	#emake check || die "emake check failed"
	if use benchmarks; then
		emake benchmark || die "emake benchmark failed"
	fi
}

src_install() {
	cmake-utils_src_install
	rm -f "${D}"usr/share/brlcad/{README,NEWS,AUTHORS,HACKING,INSTALL,COPYING}
	dodoc AUTHORS NEWS README HACKING TODO BUGS ChangeLog
	echo "PATH=\"${BRLCAD_DIR}/bin\"" >  99brlcad
	echo "MANPATH=\"${BRLCAD_DIR}/man\"" >> 99brlcad
	doenvd 99brlcad || die
	newicon misc/macosx/Resources/ReadMe.rtfd/brlcad_logo_tiny.png brlcad.png
	make_desktop_entry mged "BRL-CAD" brlcad "Graphics;Engineering"
}
