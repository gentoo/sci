# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils toolchain-funcs

DESCRIPTION="Scientific library collection for large scale problems"
HOMEPAGE="http://trilinos.sandia.gov/"
SRC_URI="${P}-Source.tar.gz"
SRC_PAGE="11.0"

SLOT="0"
LICENSE="BSD LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="arprec boost cuda hdf5 hwloc netcdf qd qt4 scotch taucs tbb test umfpack zlib"

RESTRICT="fetch"

RDEPEND="
	virtual/blas
	virtual/lapack
	virtual/mpi
	>=sci-libs/scalapack-2
	arprec? ( sci-libs/arprec )
	boost? ( dev-libs/boost )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-3.2 )
	hdf5? ( sci-libs/hdf5[mpi] )
	hwloc? ( sys-apps/hwloc )
	netcdf? ( sci-libs/netcdf )
	qd? ( sci-libs/qd )
	qt4? ( dev-qt/qtgui:4 )
	scotch? ( sci-libs/scotch[mpi] )
	taucs? ( sci-libs/taucs )
	tbb? ( dev-cpp/tbb )
	umfpack? ( sci-libs/umfpack )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P}-Source"

pkg_nofetch() {
	einfo "Sandia requires that you register to the site in order to download Trilinos."
	einfo "Please download ${SRC_URI} from:"
	einfo "http://trilinos.sandia.gov/download/trilinos-${SRC_PAGE}.html"
	einfo "and move it to ${DISTDIR}"
}

function trilinos_alternatives {
	alt_dirs=""
	for d in $($(tc-getPKG_CONFIG) --libs-only-L $1); do
		alt_dirs="${alt_dirs};${d:2}"
	done
	arg="-D${2}_LIBRARY_DIRS=${alt_dirs:1}"
	mycmakeargs+=(
		$arg
	)

	alt_libs=""
	for d in $($(tc-getPKG_CONFIG) --libs-only-l $1); do
		alt_libs="${alt_libs};${d:2}"
	done
	arg="-D${2}_LIBRARY_NAMES=${alt_libs:1}"
	mycmakeargs+=(
		$arg
	)
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-install-paths.patch
}

src_configure() {
	CMAKE_BUILD_TYPE="release"

	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DTrilinos_ENABLE_ALL_PACKAGES=ON

		-DTrilinos_INSTALL_BIN_DIR="bin"
		-DTrilinos_INSTALL_CONFIG_DIR="$(get_libdir)/cmake"
		-DTrilinos_INSTALL_INCLUDE_DIR="include/trilinos"
		-DTrilinos_INSTALL_LIB_DIR="$(get_libdir)"
		-DTrilinos_INSTALL_EXAMPLE_DIR="share/trilinos/example"

		# Tests
		$(cmake-utils_use test Trilinos_ENABLE_TESTS)

		# Mandatory dependencies
		-DTPL_ENABLE_BinUtils=ON
		-DTPL_ENABLE_MPI=ON
		-DTPL_ENABLE_BLAS=ON
		-DTPL_ENABLE_LAPACK=ON
		-DTPL_ENABLE_BLACS=ON
		-DTPL_ENABLE_SCALAPACK=ON
		-DTrilinos_EXTRA_LINK_FLAGS="-lmpi -lmpi_cxx"

		# Optional dependencies
		$(cmake-utils_use arprec TPL_ENABLE_ARPREC)
		$(cmake-utils_use boost TPL_ENABLE_Boost)
		$(cmake-utils_use boost TPL_ENABLE_BoostLib)
		$(cmake-utils_use cuda TPL_ENABLE_CUDA)
		$(cmake-utils_use hdf5 TPL_ENABLE_HDF5)
		$(cmake-utils_use hwloc TPL_ENABLE_HWLOC)
		$(cmake-utils_use netcdf TPL_ENABLE_Netcdf)
		$(cmake-utils_use qd TPL_ENABLE_QD)
		$(cmake-utils_use qt4 TPL_ENABLE_QT)
		$(cmake-utils_use scotch TPL_ENABLE_Scotch)
		$(cmake-utils_use taucs TPL_ENABLE_TAUCS)
		$(cmake-utils_use tbb TPL_ENABLE_TBB)
		$(cmake-utils_use umfpack TPL_ENABLE_UMFPACK)
		$(cmake-utils_use zlib TPL_ENABLE_Zlib)
	)

	# Scotch libraries
	if use scotch; then
		mycmakeargs+=( -DScotch_INCLUDE_DIRS="${EPREFIX}/usr/include/scotch" )
	fi

	# Add BLAS libraries
	trilinos_alternatives blas BLAS
	trilinos_alternatives lapack LAPACK
	trilinos_alternatives scalapack SCALAPACK
	trilinos_alternatives scalapack BLACS

	mycmakeargs+=( -DBLACS_INCLUDE_DIRS="${EPREFIX}/usr/include/blacs" )

	cmake-utils_src_configure
}
