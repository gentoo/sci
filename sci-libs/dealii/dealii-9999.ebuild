# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils multilib subversion

DESCRIPTION="Solving partial differential equations with the finite element method"
HOMEPAGE="http://www.dealii.org/"

ESVN_REPO_URI="https://svn.dealii.org/trunk/deal.II"
ESVN_OPTIONS="--trust-server-cert --non-interactive"
KEYWORDS=""

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="
	arpack avx +debug doc +examples hdf5 +lapack mesh_converter metis mpi
	mumps netcdf p4est parameter_gui petsc +sparse sse2 static-libs +tbb
	trilinos +zlib
"

# TODO: add slepc use flag once slepc is packaged for gentoo-science
REQUIRED_USE="
	mumps? ( mpi lapack )
	p4est? ( mpi )
	trilinos? ( mpi )
"

RDEPEND="
	dev-libs/boost
	arpack? ( sci-libs/arpack[mpi=] )
	hdf5? ( sci-libs/hdf5[mpi=] )
	lapack? ( virtual/lapack )
	metis? ( >=sci-libs/parmetis-4 )
	mpi? ( virtual/mpi )
	mumps? ( sci-libs/mumps[mpi] )
	netcdf? ( || ( <sci-libs/netcdf-4.2[cxx] sci-libs/netcdf-cxx ) )
	p4est? ( sci-libs/p4est[mpi] )
	parameter_gui? ( dev-qt/qtgui )
	petsc? ( sci-mathematics/petsc[mpi=] )
	sparse? ( sci-libs/umfpack )
	tbb? ( dev-cpp/tbb )
	trilinos? ( sci-libs/trilinos )
	zlib? ( sys-libs/zlib )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] dev-lang/perl )
"

src_configure() {

	subversion_wc_info
	local live_version="-DDEAL_II_PACKAGE_VERSION=99.99.svn${ESVN_WC_REVISION}"

	if use debug; then
		CMAKE_BUILD_TYPE="DebugRelease"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local mycmakeargs=(
		${live_version}
		-DDEAL_II_ALLOW_AUTODETECTION=OFF
		-DDEAL_II_ALLOW_BUNDLED=OFF
		-DDEAL_II_ALLOW_PLATFORM_INTROSPECTION=OFF
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF
		-DDEAL_II_COMPONENT_COMPAT_FILES=OFF
		-DDEAL_II_CMAKE_MACROS_RELDIR=share/${PN}/cmake/macros
		-DDEAL_II_DOCHTML_RELDIR=share/doc/${PF}/html
		-DDEAL_II_DOCREADME_RELDIR=share/doc/${PF}/
		-DDEAL_II_EXAMPLES_RELDIR=share/doc/${PF}/examples
		-DDEAL_II_LIBRARY_RELDIR=$(get_libdir)
		$(cmake-utils_use arpack DEAL_II_WITH_ARPACK)
		$(cmake-utils_use avx DEAL_II_HAVE_AVX)
		$(cmake-utils_use doc DEAL_II_COMPONENT_DOCUMENTATION)
		$(cmake-utils_use examples DEAL_II_COMPONENT_EXAMPLES)
		$(cmake-utils_use hdf5 DEAL_II_WITH_HDF5)
		$(cmake-utils_use lapack DEAL_II_WITH_LAPACK)
		$(cmake-utils_use mesh_converter DEAL_II_COMPONENT_MESH_CONVERTER)
		$(cmake-utils_use metis DEAL_II_WITH_METIS)
		$(cmake-utils_use mpi DEAL_II_WITH_MPI)
		$(cmake-utils_use mumps DEAL_II_WITH_MUMPS)
		$(cmake-utils_use netcdf DEAL_II_WITH_NETCDF)
		$(cmake-utils_use p4est DEAL_II_WITH_P4EST)
		$(cmake-utils_use parameter_gui DEAL_II_COMPONENT_PARAMETER_GUI)
		$(cmake-utils_use petsc DEAL_II_WITH_PETSC)
		$(cmake-utils_use sparse DEAL_II_WITH_UMFPACK)
		$(cmake-utils_use sse2 DEAL_II_HAVE_SSE2)
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
		$(cmake-utils_use static-libs DEAL_II_PREFER_STATIC_LIBS)
		$(cmake-utils_use tbb DEAL_II_WITH_THREADS)
		$(cmake-utils_use trilinos DEAL_II_WITH_TRILINOS)
		$(cmake-utils_use zlib DEAL_II_WITH_ZLIB)
		)
	cmake-utils_src_configure
}

src_install() {
	DOCS=( README )

	cmake-utils_src_install

	# unpack the installed example sources:
	use examples && docompress -x /usr/share/doc/${PF}/examples
}
