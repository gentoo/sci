# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop java-pkg-2 flag-o-matic

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="https://brlcad.org/ https://github.com/BRL-CAD/brlcad"
SRC_URI="https://github.com/BRL-CAD/${PN}/archive/refs/tags/rel-${PV//./-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rel-${PV//./-}"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="benchmarks debug doc examples java opengl smp"

RDEPEND="
	java? (
		>=virtual/jre-1.8:*
	)
	"

DEPEND="${RDEPEND}
	dev-util/astyle
	dev-util/re2c
	>=sci-libs/tnt-3
	sci-libs/proj
	sci-libs/lemon
	sys-devel/bison
	sys-devel/flex
	media-libs/libpng:0
	>=dev-lang/tcl-8.6:0/8.6
	>=dev-lang/tk-8.6:0/8.6
	sys-libs/zlib
	sys-libs/libtermcap-compat
	media-libs/urt
	x11-libs/libXt
	x11-libs/libXi
	java? (
		sci-libs/jama
		>=virtual/jre-1.8:*
	)
	doc? (
		dev-libs/libxslt
		app-text/doxygen
	)"

# Install into /usr/ not recommended by upstream due to possible file conflicts
# with bundled libraries!
BRLCAD_DIR="${EPREFIX}/usr/${PN}"

PATCHES=( "${FILESDIR}/${P}-skip-gstep.patch" )

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	append-cflags "-w"
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${BRLCAD_DIR}"
		-DBRLCAD_ENABLE_STRICT=NO
		-DBRLCAD-ENABLE_COMPILER_WARNINGS=NO
		-DBRLCAD_BUNDLED_LIBS=AUTO
		-DBRLCAD_FLAGS_OPTIMIZATION=ON
		-DBRLCAD_ENABLE_X11=ON
		-DBRLCAD_ENABLE_VERBOSE_PROGRESS=ON
		-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H=ON
# requires itk/itcl version 3, not packaged, use bundled instead
# 		-DBRLCAD_TKTABLE=OFF
# 		-DBRLCAD_IWIDGETS=OFF
# 		-DBRLCAD_ITCL=OFF
# 		-DBRLCAD_ITK=OFF
#		-DBRLCAD_TKPNG=OFF
# Not packaged, use bundled
# 		-DBRLCAD_GDIAM
# 		-DBRLCAD_VDS
# 		-DBRLCAD_SC
# 		-DBRLCAD_OPENNURBS
# 		-DBRLCAD_TKHTML
# 		-DBRLCAD_UTAHRLE
# 		-DBRLCAD_TERMLIB
# 		-DBRLCAD_XMLLINT
# 		-DBRLCAD_XSLTPROC
# 		-DBRLCAD_PERPLEX
	)

	# use flag triggered options
	if use debug; then
		mycmakeargs+=( -DCMAKE_BUILD_TYPE="Debug" )
	else
		mycmakeargs+=( -DCMAKE_BUILD_TYPE="Release" )
	fi
	mycmakeargs+=(
		$(usex opengl BRLCAD_ENABLE_OPENGL)
		$(usex opengl BRLCAD_ENABLE_RTGL)
		$(usex amd64 BRLCAD_ENABLE_64BIT)
		$(usex smp BRLCAD_ENABLE_SMP)
		$(usex java BRLCAD_ENABLE_RTSERVER)
		$(usex examples BRLCAD_INSTALL_EXAMPLE_GEOMETRY)
		$(usex doc BRLCAD_EXTRADOCS)
		$(usex doc BRLCAD_EXTRADOCS_PDF)
		$(usex doc BRLCAD_EXTRADOCS_MAN)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	cmake_src_test
	emake check
	if use benchmarks; then
		emake benchmark
	fi
}

src_install() {
	cmake_src_install
	rm -f "${D}"/usr/share/brlcad/{README,NEWS,AUTHORS,HACKING,INSTALL,COPYING}
	dodoc AUTHORS NEWS README HACKING TODO BUGS ChangeLog
	echo "PATH=\"${BRLCAD_DIR}/bin\"" >  99brlcad
	echo "MANPATH=\"${BRLCAD_DIR}/man\"" >> 99brlcad
	doenvd 99brlcad
	for size in {16,24,36,48,64,96,128,256}; do
		doicon misc/debian/icons/${size}x${size}/*
	done
	domenu misc/debian/*.desktop
}
