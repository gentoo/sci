# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=5

inherit cmake-utils fortran-2 toolchain-funcs

DESCRIPTION="3D finite element mesh generator with built-in pre- and post-processing facilities"
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

## gmsh comes with its own copies of (at least) metis, netgen and tetgen, therefore inform the user of their special licenses
LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
## cgns is not compiling ATM, maybe fix cgns lib first
IUSE="blas cgns chaco doc examples jpeg lua med metis mpi netgen opencascade petsc taucs tetgen X"

RDEPEND="
	media-libs/libpng
	sys-libs/zlib
	virtual/fortran
	virtual/glu
	virtual/opengl
	X? ( x11-libs/fltk:1[opengl] )
	blas? ( virtual/blas virtual/lapack sci-libs/fftw:3.0 )
	cgns? ( sci-libs/cgnslib )
	jpeg? ( virtual/jpeg )
	lua? ( dev-lang/lua )
	med? ( >=sci-libs/med-2.3.4 )
	opencascade? ( sci-libs/opencascade )
	petsc? ( sci-mathematics/petsc )
	mpi? ( virtual/mpi[cxx] )
	taucs? ( sci-libs/taucs )
	"

DEPEND="${RDEPEND}
	doc? ( virtual/latex-base >=sys-apps/texinfo-5.1 )"

S=${WORKDIR}/${P}-source

REQUIRED_USE="taucs? ( metis )"

src_configure() {
	use blas && \
		myargs="-DCMAKE_Fortran_COMPILER=$(tc-getF77)"

	mycmakeargs=(
		$(cmake-utils_use_enable blas BLAS_LAPACK)
		$(cmake-utils_use_enable cgns CGNS)
		$(cmake-utils_use_enable chaco CHACO)
		$(cmake-utils_use_enable X FLTK)
		$(cmake-utils_use_enable X FL_TREE)
		$(cmake-utils_use_enable X GRAPHICS)
		$(cmake-utils_use_enable med MED)
		$(cmake-utils_use_enable metis METIS)
		$(cmake-utils_use_enable netgen NETGEN)
		$(cmake-utils_use_enable taucs TAUCS)
		$(cmake-utils_use_enable tetgen TETGEN)
		$(cmake-utils_use_enable opencascade OCC)
		$(cmake-utils_use_enable petsc PETSC)
		${myargs}
	)
# 		$(cmake-utils_use_enable tetgen TETGEN_NEW)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		emake pdf -C "${CMAKE_BUILD_DIR}"
	fi
}

src_install() {
	cmake-utils_src_install

	# TODO: tutorials get installed twice ATM
	use doc && dodoc doc/texinfo/gmsh.pdf

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r demos tutorial
	fi
}
