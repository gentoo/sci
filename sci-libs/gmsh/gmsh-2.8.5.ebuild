# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="A three-dimensional finite element mesh generator"
HOMEPAGE="http://www.geuz.org/gmsh/"
SRC_URI="http://www.geuz.org/gmsh/src/${P}-source.tgz"

## gmsh comes with its own copies of (at least) metis, netgen and tetgen, therefore inform the user of their special licenses
LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
## cgns is not compiling ATM, maybe fix cgns lib first
IUSE="blas cgns chaco doc examples jpeg lua med metis mpi netgen opencascade petsc png taucs tetgen X zlib"

RDEPEND="
	virtual/fortran
	X? ( x11-libs/fltk:1 )
	blas? ( virtual/blas virtual/lapack sci-libs/fftw:3.0 )
	cgns? ( sci-libs/cgnslib )
	jpeg? ( virtual/jpeg:0= )
	lua? ( dev-lang/lua:0 )
	med? ( >=sci-libs/med-2.3.4 )
	opencascade? ( sci-libs/opencascade:* )
	png? ( media-libs/libpng:0= )
	petsc? ( <=sci-mathematics/petsc-3.4.2 )
	zlib? ( sys-libs/zlib )
	mpi? ( virtual/mpi[cxx] )
	taucs? ( sci-libs/taucs )"

REQUIRED_USE="
	taucs? ( || ( metis ) )
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

S=${WORKDIR}/${P}-source

pkg_setup() {
	fortran-2_pkg_setup
}

src_configure() {
	local mycmakeargs=""

	use blas && \
		mycmakeargs="${mycmakeargs}
			-DCMAKE_Fortran_COMPILER=$(tc-getF77)"

	mycmakeargs="${mycmakeargs}
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
		$(cmake-utils_use_enable petsc PETSC)"
#		$(cmake-utils_use_enable tetgen TETGEN_NEW)

	cmake-utils_src_configure ${mycmakeargs}
}

src_install() {
	cmake-utils_src_install

	# TODO: tutorials get installed twice ATM
	if use doc ; then
		cd "${BUILD_DIR}" || die
		emake pdf
		cd "${S}" || die
		dodoc doc/texinfo/gmsh.pdf
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r demos tutorial
	fi
}
