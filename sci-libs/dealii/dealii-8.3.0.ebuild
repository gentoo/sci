# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils eutils multilib

# deal.II uses its own FindLAPACK.cmake file that calls into the system
# FindLAPACK.cmake module and does additional internal setup. Do not remove
# any of these modules:
CMAKE_REMOVE_MODULES_LIST=""

DESCRIPTION="Solving partial differential equations with the finite element method"
HOMEPAGE="http://www.dealii.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/dealii/dealii.git"
	SRC_URI=""
	KEYWORDS=""
else
	MY_PV="${PV//0_rc/rc}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/dealii/dealii/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		doc? (
			https://github.com/${PN}/${PN}/releases/download/v${MY_PV}/${MY_P}-offline_documentation.tar.gz
			-> ${P}-offline_documentation.tar.gz
			http://ganymed.iwr.uni-heidelberg.de/~maier/dealii/releases/${MY_P}-offline_documentation.tar.gz
			-> ${P}-offline_documentation.tar.gz
			)"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="
	arpack cpu_flags_x86_avx cpu_flags_x86_sse2 c++11 +debug doc +examples
	hdf5 +lapack mesh_converter metis mpi muparser opencascade
	netcdf p4est parameter_gui petsc +sparse static-libs +tbb trilinos
"

# TODO: add slepc use flag once slepc is packaged for gentoo-science
REQUIRED_USE="
	p4est? ( mpi )
	trilinos? ( mpi )"

RDEPEND="dev-libs/boost
	app-arch/bzip2
	sys-libs/zlib
	arpack? ( sci-libs/arpack[mpi=] )
	hdf5? ( sci-libs/hdf5[mpi=] )
	lapack? ( virtual/lapack )
	metis? ( >=sci-libs/parmetis-4 )
	mpi? ( virtual/mpi )
	muparser? ( dev-cpp/muParser )
	netcdf? ( sci-libs/netcdf-cxx:0 )
	opencascade? ( sci-libs/opencascade:* )
	p4est? ( sci-libs/p4est[mpi] )
	parameter_gui? ( dev-qt/qtgui:4 )
	petsc? ( sci-mathematics/petsc[mpi=] )
	sparse? ( sci-libs/umfpack )
	tbb? ( dev-cpp/tbb )
	trilinos? ( sci-libs/trilinos )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] dev-lang/perl )"

src_configure() {
	# deal.II needs a custom build type:
	local CMAKE_BUILD_TYPE=$(usex debug DebugRelease Release)

	local mycmakeargs=(
		-DDEAL_II_ALLOW_AUTODETECTION=OFF
		-DDEAL_II_ALLOW_BUNDLED=OFF
		-DDEAL_II_ALLOW_PLATFORM_INTROSPECTION=OFF
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF
		-DDEAL_II_LIBRARY_RELDIR="$(get_libdir)"
		-DDEAL_II_SHARE_RELDIR="share/${PN}"
		-DDEAL_II_DOCREADME_RELDIR="share/doc/${P}"
		-DDEAL_II_EXAMPLES_RELDIR="share/doc/${P}/examples"
		-DDEAL_II_WITH_BZIP2=ON
		-DDEAL_II_WITH_ZLIB=ON
		$(cmake-utils_use arpack DEAL_II_WITH_ARPACK)
		$(cmake-utils_use c++11 DEAL_II_WITH_CXX11)
		$(cmake-utils_use cpu_flags_x86_avx DEAL_II_HAVE_AVX)
		$(cmake-utils_use cpu_flags_x86_sse2 DEAL_II_HAVE_SSE2)
		$(cmake-utils_use doc DEAL_II_COMPONENT_DOCUMENTATION)
		$(cmake-utils_use examples DEAL_II_COMPONENT_EXAMPLES)
		$(cmake-utils_use hdf5 DEAL_II_WITH_HDF5)
		$(cmake-utils_use lapack DEAL_II_WITH_LAPACK)
		$(cmake-utils_use mesh_converter DEAL_II_COMPONENT_MESH_CONVERTER)
		$(cmake-utils_use metis DEAL_II_WITH_METIS)
		$(cmake-utils_use mpi DEAL_II_WITH_MPI)
		$(cmake-utils_use muparser DEAL_II_WITH_MUPARSER)
		$(cmake-utils_use netcdf DEAL_II_WITH_NETCDF)
		-DOPENCASCADE_DIR="${CASROOT}"
		$(cmake-utils_use opencascade DEAL_II_WITH_OPENCASCADE)
		$(cmake-utils_use p4est DEAL_II_WITH_P4EST)
		$(cmake-utils_use parameter_gui DEAL_II_COMPONENT_PARAMETER_GUI)
		$(cmake-utils_use petsc DEAL_II_WITH_PETSC)
		$(cmake-utils_use sparse DEAL_II_WITH_UMFPACK)
		$(cmake-utils_use !static-libs BUILD_SHARED_LIBS)
		$(cmake-utils_use static-libs DEAL_II_PREFER_STATIC_LIBS)
		$(cmake-utils_use tbb DEAL_II_WITH_THREADS)
		$(cmake-utils_use trilinos DEAL_II_WITH_TRILINOS)
		)
	cmake-utils_src_configure
}

src_install() {
	if use doc && [[ ${PV} != *9999* ]]; then
		# copy missing images to the build directory:
		cp -r "${WORKDIR}"/doc/doxygen/deal.II/images \
			"${BUILD_DIR}"/doc/doxygen/deal.II || die
		# replace links:
		sed -i \
			's#"http://www.dealii.org/images/steps/developer/\(step-.*\)"#"images/\1"#g' \
			"${BUILD_DIR}"/doc/doxygen/deal.II/step_*.html || die "sed failed"
	fi
	cmake-utils_src_install

	# decompress the installed example sources:
	use examples && docompress -x /usr/share/doc/${PF}/examples
}
