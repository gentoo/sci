# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_STANDARD=90

inherit fortran-2 flag-o-matic cmake

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools"
HOMEPAGE="https://www.csc.fi/web/elmer https://www.elmerfem.org/blog/"
SRC_URI="https://github.com/ElmerCSC/elmerfem/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ice gui matc mumps mpi post test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/blas
	virtual/lapack
	sci-libs/arpack
	mumps? ( sci-libs/mumps )
	mpi? ( sys-cluster/openmpi )
	post? (
		dev-lang/tcl:0=
		dev-lang/tk:0=
	)
	gui? ( x11-libs/qwt:6 )
"
DEPEND="${RDEPEND}"
# Note this seems to only configure correctly with the elmer version of umfpack
# But this doesn't stop it from compiling / working without it

PATCHES=(
	"${FILESDIR}/${PN}-DCRComplexSolve-compile-error.patch"
	"${FILESDIR}/${PN}-ElmerIce-compile.patch"
	"${FILESDIR}/${PN}-rpath.patch"
)

S="${WORKDIR}/elmerfem-release-${PV}"

src_prepare() {
	cmake_src_prepare
	sed -i '/#include <QPainter>/a #include <QPainterPath>' ElmerGUI/Application/twod/renderarea.cpp || die
	test-flag-FC -fallow-argument-mismatch && append-fflags -fallow-argument-mismatch
	test-flag-FC -fallow-invalid-boz && append-fflags -fallow-invalid-boz
	# TODO: fix the tests, fails in compile phase: multiple rules to make target
	rm -r fem/tests/* || die
	touch fem/tests/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DMPI_Fortran_COMPILE_FLAGS="$FCFLAGS"
		-DCMAKE_Fortran_FLAGS="$FCFLAGS"
		-DELMER_INSTALL_LIB_DIR="/usr/$(get_libdir)/elmersolver"
		-DWITH_MPI="$(usex mpi)"
		-DWITH_OpenMP="$(usex mpi)"
		-DWITH_MATC="$(usex matc)"
		-DWITH_Mumps="$(usex mumps)"
		-DWITH_ElmerIce="$(usex ice)"
		-DWITH_ELMERPOST="$(usex post)"
		-DWITH_ELMERGUI="$(usex gui)"
		-DWITH_QT5="$(usex gui)"
		-DWITH_QWT="$(usex gui)"
		-DQWT_INCLUDE_DIR="/usr/include/qwt6"
		-DQWT_LIBRARY="/usr/$(get_libdir)/libqwt6-qt5.so"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}
