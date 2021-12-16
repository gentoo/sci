# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop subversion java-pkg-2 flag-o-matic

DESCRIPTION="Constructive solid geometry modeling system"
HOMEPAGE="https://brlcad.org/"
ESVN_REPO_URI="https://brlcad.svn.sourceforge.net/svnroot/${PN}/${PN}/trunk"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS=""
IUSE="benchmarks debug doc examples java opengl smp"

RDEPEND="
	java? (
		>=virtual/jre-1.7:*
	)
	"

DEPEND="${RDEPEND}
	>=sci-libs/tnt-3
	sys-devel/bison
	sys-devel/flex
	media-libs/libpng:0
	<dev-lang/tcl-8.6:0/8.5
	<dev-lang/tk-8.6:0/8.5
	dev-tcltk/tktable
	sys-libs/zlib
	sys-libs/libtermcap-compat
	media-libs/urt
	x11-libs/libXt
	x11-libs/libXi
	java? (
		sci-libs/jama
		>=virtual/jre-1.7:*
	)
	doc? (
		dev-libs/libxslt
		app-doc/doxygen
	)"

BRLCAD_DIR="${EPREFIX}/usr/${PN}"

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
	)

	# use flag triggered options
	if use debug; then
		mycmakeargs+="-DCMAKE_BUILD_TYPE=Debug"
	else
		mycmakeargs+="-DCMAKE_BUILD_TYPE=Release"
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
	for size in 16,24,36,48,64,96,128,256; do
		doicon misc/debian/${size}x${Size}/*
	done
	domenu misc/debian/*.desktop
}
