# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils java-pkg-2 flag-o-matic

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="http://brlcad.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="benchmarks debug doc examples java opengl smp"

RDEPEND="media-libs/libpng:0
	sys-libs/zlib
	>=sci-libs/tnt-3
	sci-libs/jama
	<dev-lang/tcl-8.6:0
	<dev-lang/tk-8.6:0
	<dev-tcltk/itcl-4.0
	<dev-tcltk/itk-4.0
	dev-tcltk/iwidgets
	dev-tcltk/tkimg
	dev-tcltk/tkpng
	sys-libs/libtermcap-compat
	media-libs/urt
	x11-libs/libXt
	x11-libs/libXi
	java? ( >=virtual/jre-1.5:* )
	"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-tcltk/tktable
	>=virtual/jre-1.5:*
	doc? (
		dev-libs/libxslt
		app-doc/doxygen
	)"

BRLCAD_DIR="${EPREFIX}/usr/${PN}"

#src_prepare() {
#	epatch "${FILESDIR}/${P}-cmake.patch"
#}

src_configure() {
filter-flags -std=c++0x
	if use Debug; then
		CMAKE_BUILD_TYPE=Debug
		else
		CMAKE_BUILD_TYPE=Release
		fi
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${BRLCAD_DIR}"
		-DBRLCAD_ENABLE_STRICT=OFF
		-DBRLCAD-ENABLE_STRICT=OFF
		-DBRLCAD-ENABLE_COMPILER_WARNINGS=OFF
		-DBRLCAD_FLAGS_OPTIMIZATION=ON
		-DBRLCAD_ENABLE_X11=ON
		-DBRLCAD_BUNDLED_LIBS=AUTO
		)

			# use flag triggered options
	if use debug; then
		mycmakeargs += "-DCMAKE_BUILD_TYPE=Debug"
	else
		mycmakeargs += "-DCMAKE_BUILD_TYPE=Release"
	fi
	mycmakeargs+=(
		$(cmake-utils_use opengl BRLCAD_ENABLE_OPENGL)
#experimental RTGL support
	#	$(cmake-utils_use opengl BRLCAD_ENABLE_RTGL)
		$(cmake-utils_use amd64 BRLCAD_ENABLE_64BIT)
		$(cmake-utils_use smp BRLCAD_ENABLE_SMP)
	#	$(cmake-utils_use java BRLCAD_ENABLE_RTSERVER)
		$(cmake-utils_use examples BRLCAD_INSTALL_EXAMPLE_GEOMETRY)
		$(cmake-utils_use doc BRLCAD_EXTRADOCS)
		$(cmake-utils_use doc BRLCAD_EXTRADOCS_PDF)
		$(cmake-utils_use doc BRLCAD_EXTRADOCS_MAN)
		$(cmake-utils_use debug BRLCAD_ENABLE_VERBOSE_PROGRESS)
			)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
	#emake check || die "emake check failed"
	if use benchmarks; then
		emake benchmark
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
