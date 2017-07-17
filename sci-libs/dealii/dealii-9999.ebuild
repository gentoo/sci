# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
			)"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="
	arpack cpu_flags_x86_avx cpu_flags_x86_sse2 +debug doc +examples
	+gsl hdf5 +lapack metis mpi muparser opencascade netcdf p4est petsc
	slepc +sparse static-libs +tbb trilinos
"

# TODO: add slepc use flag once slepc is packaged for gentoo-science
REQUIRED_USE="
	p4est? ( mpi )
	slepc? ( petsc )
	trilinos? ( mpi )"

RDEPEND="dev-libs/boost
	app-arch/bzip2
	sys-libs/zlib
	arpack? ( sci-libs/arpack[mpi=] )
	gsl? ( sci-libs/gsl )
	hdf5? ( sci-libs/hdf5[mpi=] )
	lapack? ( virtual/lapack )
	metis? ( >=sci-libs/parmetis-4 )
	mpi? ( virtual/mpi )
	muparser? ( dev-cpp/muParser )
	netcdf? ( sci-libs/netcdf-cxx:0 )
	opencascade? ( sci-libs/opencascade:* )
	p4est? ( sci-libs/p4est[mpi] )
	petsc? ( sci-mathematics/petsc[mpi=] )
	slepc? ( sci-mathematics/slepc[mpi=] )
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
		-DDEAL_II_PACKAGE_VERSION=9999
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF
		-DDEAL_II_ALLOW_AUTODETECTION=OFF
		-DDEAL_II_ALLOW_BUNDLED=OFF
		-DDEAL_II_ALLOW_PLATFORM_INTROSPECTION=OFF
		-DDEAL_II_COMPILE_EXAMPLES=OFF
		-DDEAL_II_DOCHTML_RELDIR="share/doc/${P}/html"
		-DDEAL_II_DOCREADME_RELDIR="share/doc/${P}"
		-DDEAL_II_COMPILE_EXAMPLES=OFF
		-DDEAL_II_EXAMPLES_RELDIR="share/doc/${P}/examples"
		-DDEAL_II_LIBRARY_RELDIR="$(get_libdir)"
		-DDEAL_II_SHARE_RELDIR="share/${PN}"
		-DDEAL_II_WITH_BZIP2=ON
		-DDEAL_II_WITH_ZLIB=ON
		-DDEAL_II_WITH_ARPACK="$(usex arpack)"
		-DDEAL_II_HAVE_AVX="$(usex cpu_flags_x86_avx)"
		-DDEAL_II_HAVE_SSE2="$(usex cpu_flags_x86_sse2)"
		-DDEAL_II_COMPONENT_DOCUMENTATION="$(usex doc)"
		-DDEAL_II_COMPONENT_EXAMPLES="$(usex examples)"
		-DDEAL_II_WITH_GSL="$(usex gsl)"
		-DDEAL_II_WITH_HDF5="$(usex hdf5)"
		-DDEAL_II_WITH_LAPACK="$(usex lapack)"
		-DDEAL_II_WITH_METIS="$(usex metis)"
		-DDEAL_II_WITH_MPI="$(usex mpi)"
		-DDEAL_II_WITH_MUPARSER="$(usex muparser)"
		-DDEAL_II_WITH_NETCDF="$(usex netcdf)"
		-DOPENCASCADE_DIR="${CASROOT}"
		-DDEAL_II_WITH_OPENCASCADE="$(usex opencascade)"
		-DDEAL_II_WITH_P4EST="$(usex p4est)"
		-DDEAL_II_WITH_PETSC="$(usex petsc)"
		-DDEAL_II_WITH_SLEPC="$(usex slepc)"
		-DDEAL_II_WITH_UMFPACK="$(usex sparse)"
		-DBUILD_SHARED_LIBS="$(usex !static-libs)"
		-DDEAL_II_PREFER_STATIC_LIBS="$(usex static-libs)"
		-DDEAL_II_WITH_THREADS="$(usex tbb)"
		-DDEAL_II_WITH_TRILINOS="$(usex trilinos)"
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
