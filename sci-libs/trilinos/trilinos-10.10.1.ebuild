# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit cmake-utils

DESCRIPTION="Scientific library collection for large scale problems"
HOMEPAGE="http://trilinos.sandia.gov/"
SRC_URI="${P}-Source.tar.gz"
SRC_PAGE="10.10"

KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"

LICENSE="BSD LGPL-2.1"
SLOT="0"

IUSE="arprec boost cuda hdf5 netcdf qd qt taucs tbb umfpack zlib"

RDEPEND="virtual/blas
	virtual/lapack
	virtual/mpi
	>=sci-libs/scalapack-2
	arprec? ( sci-libs/arprec )
	boost? ( dev-libs/boost )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-3.2 )
	hdf5? ( sci-libs/hdf5[mpi] )
	netcdf? ( sci-libs/netcdf )
	qd? ( sci-libs/qd )
	qt? ( >=x11-libs/qt-gui-4.5 )
	taucs? ( sci-libs/taucs )
	tbb? ( dev-cpp/tbb )
	umfpack? ( sci-libs/umfpack )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-Source"

pkg_nofetch() {
	einfo "Sandia requires that you register to the site in order to download Trilinos."
	einfo "Please download ${SRC_URI} from:"
	einfo "http://trilinos.sandia.gov/download/trilinos-${SRC_PAGE}.html"
	einfo "and move it to ${DISTDIR}"
}

function trilinos_alternatives {
    alt_dirs=""
    for d in $(pkg-config --libs-only-L $1); do
        alt_dirs="${alt_dirs};${d:2}"
    done
    arg="-D${2}_LIBRARY_DIRS=${alt_dirs:1}"
    mycmakeargs+=(
		$arg
	)
	
	alt_libs=""
    for d in $(pkg-config --libs-only-l $1); do
        alt_libs="${alt_libs};${d:2}"
    done
    arg="-D${2}_LIBRARY_NAMES=${alt_libs:1}"
    mycmakeargs+=(
		$arg
	)
}

src_configure() {
	CMAKE_BUILD_TYPE="release"
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DTrilinos_ENABLE_ALL_PACKAGES=ON

		# Tests
		$(cmake-utils_use test Trilinos_ENABLE_TESTS)

		# Mandatory dependencies
		-DTPL_ENABLE_MPI=ON
		-DTPL_ENABLE_BLAS=ON
		-DTPL_ENABLE_LAPACK=ON
		-DTPL_ENABLE_BLACS=ON
		-DTPL_ENABLE_SCALAPACK=ON
		-DTrilinos_EXTRA_LINK_FLAGS="-lmpi -lmpi_cxx"

		# Optional dependencies
		$(cmake-utils_use arprec TPL_ENABLE_ARPREC)
		$(cmake-utils_use boost TPL_ENABLE_Boost)
		$(cmake-utils_use cuda TPL_ENABLE_CUDA)
		$(cmake-utils_use hdf5 TPL_ENABLE_HDF5)
		$(cmake-utils_use netcdf TPL_ENABLE_Netcdf)
		$(cmake-utils_use qd TPL_ENABLE_QD)
		$(cmake-utils_use qt TPL_ENABLE_QT)
		$(cmake-utils_use taucs TPL_ENABLE_TAUCS)
		$(cmake-utils_use tbb TPL_ENABLE_TBB)
		$(cmake-utils_use umfpack TPL_ENABLE_UMFPACK)
		$(cmake-utils_use zlib TPL_ENABLE_Zlib)
	)

    # Add BLAS libraries
    trilinos_alternatives blas BLAS
    trilinos_alternatives lapack LAPACK
    trilinos_alternatives scalapack SCALAPACK
    trilinos_alternatives scalapack BLACS
    
    mycmakeargs+=( -DBLACS_INCLUDE_DIRS="/usr/include/blacs" )

	cmake-utils_src_configure
}

src_compile() {
    cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	local k
	local fname
	local libpath
	local tpkg

	# Edit cmake files
	libpath="/usr/$(get_libdir)/Trilinos"
	pushd "${D}/usr/lib/cmake"
	for i in *; do
	fname="${i}/${i}Config.cmake"

	k=$(grep -n "${i}_INCLUDE_DIRS" "${fname}" | sed 's/\([0-9]*\):.*/\1/')
	sed "${k}s|/usr/include|/usr/include/Trilinos|" < "${fname}" > "${fname}.temp"

	k=$(grep -n "${i}_LIBRARY_DIRS" "${fname}" | sed 's/\([0-9]*\):.*/\1/')
	sed "${k}s|/usr/lib|${libpath}|" < "${fname}.temp" > "${fname}"

	rm "${fname}.temp"
	done
	popd

	# Edit Makefiles
	pushd "${D}/usr/include"
	for i in Makefile.export.*; do
	tpkg="$(echo ${i} | sed 's/Makefile.export.//')"

	sed "s|${tpkg}_INCLUDE_DIRS= -I/usr/include|${tpkg}_INCLUDE_DIRS= -I/usr/include/Trilinos|" < "Makefile.export.${tpkg}" > "Makefile.export.${tpkg}.temp"
	sed "s|${tpkg}_LIBRARY_DIRS= -L/usr/lib|${tpkg}_LIBRARY_DIRS= -L${libpath}|" < "Makefile.export.${tpkg}.temp" > "Makefile.export.${tpkg}"
	rm "Makefile.export.${tpkg}.temp"
	done
	popd


	# Move libraries
	mkdir -p "${D}/${libpath}"
	mv ${D}usr/lib/*.so "${D}/${libpath}"

	# Move headers
	mkdir "${T}/headers"
	mv ${D}usr/include/* "${T}/headers"
	mv "${T}/headers" "${D}/usr/include/Trilinos"
}
