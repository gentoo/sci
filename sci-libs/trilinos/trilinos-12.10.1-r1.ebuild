# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils toolchain-funcs multilib toolchain-funcs

DESCRIPTION="Scientific library collection for large scale problems"
HOMEPAGE="http://trilinos.sandia.gov/"
SRC_URI="http://trilinos.org/oldsite/download/files/${P}-Source.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD LGPL-2.1"
SLOT="0"

IUSE="
	adolc arprec boost clp cppunit cuda eigen glpk gtest hdf5 hwloc hypre
	matio metis mkl mumps netcdf petsc qd qt4 scalapack scotch sparse
	superlu taucs tbb test threads tvmet yaml zlib X
"

# TODO: fix export cmake function for tests
RESTRICT="test"

RDEPEND="
	sys-libs/binutils-libs
	virtual/blas
	virtual/lapack
	virtual/mpi
	adolc? ( sci-libs/adolc )
	arprec? ( sci-libs/arprec )
	boost? ( dev-libs/boost )
	clp? ( sci-libs/coinor-clp )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-3.2 )
	eigen? ( dev-cpp/eigen:3 )
	gtest? ( dev-cpp/gtest )
	hdf5? ( sci-libs/hdf5[mpi] )
	hypre? ( sci-libs/hypre )
	hwloc? ( sys-apps/hwloc )
	matio? ( sci-libs/matio )
	mkl? ( sci-libs/mkl )
	metis? ( || ( sci-libs/parmetis sci-libs/metis ) )
	mumps? ( sci-libs/mumps )
	netcdf? ( sci-libs/netcdf )
	petsc? ( sci-mathematics/petsc )
	qd? ( sci-libs/qd )
	qt4? ( dev-qt/qtgui:4 )
	scalapack? ( virtual/scalapack )
	scotch? ( sci-libs/scotch )
	sparse? ( sci-libs/cxsparse sci-libs/umfpack )
	superlu? ( sci-libs/superlu )
	taucs? ( sci-libs/taucs )
	tbb? ( dev-cpp/tbb )
	tvmet? ( dev-libs/tvmet )
	yaml? ( dev-cpp/yaml-cpp )
	zlib? ( sys-libs/zlib )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${P}-Source"

trilinos_conf() {
	local dirs libs d
	for d in $($(tc-getPKG_CONFIG) --libs-only-L $1); do
		dirs="${dirs};${d:2}"
	done
	[[ -n ${dirs} ]] && mycmakeargs+=( "-D${2}_LIBRARY_DIRS=${dirs:1}" )
	for d in $($(tc-getPKG_CONFIG) --libs-only-l $1); do
		libs="${libs};${d:2}"
	done
	[[ -n ${libs} ]] && mycmakeargs+=( "-D${2}_LIBRARY_NAMES=${libs:1}" )
	dirs=""
	for d in $($(tc-getPKG_CONFIG) --cflags-only-I $1); do
		dirs="${dirs};${d:2}"
	done
	[[ -n ${dirs} ]] && mycmakeargs+=( "-D${2}_INCLUDE_DIRS=${dirs:1}" )
}

trilinos_enable() {
	cmake-utils_use $1 TPL_ENABLE_${2:-${1^^}}
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-11.14.1-fix-install-paths.patch \
		"${FILESDIR}"/${P}-fix_install_paths_for_destdir.patch \
		"${FILESDIR}"/${P}-fix_install_paths_for_destdir-2.patch \
		"${FILESDIR}"/${P}-fix_gcc_7.patch

	epatch_user
}

src_configure() {

	# temporarily disable pyTrilinos compilation
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"
		-DTrilinos_ENABLE_ALL_PACKAGES=ON
		-DZoltan2_ENABLE_Experimental=ON
		-DTrilinos_ENABLE_SEACASExodus=$(usex netcdf)
	    -DTrilinos_ENABLE_SEACASExodiff=$(usex netcdf)
		-DTrilinos_ENABLE_PyTrilinos=OFF
		-DTrilinos_INSTALL_INCLUDE_DIR="${EPREFIX}/usr/include/trilinos"
		-DTrilinos_INSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)/trilinos"
		-DTrilinos_INSTALL_CONFIG_DIR="${EPREFIX}/usr/$(get_libdir)/cmake"
		-DTPL_ENABLE_BinUtils=ON
		-DTPL_ENABLE_MPI=ON
		-DTPL_ENABLE_BLAS=ON
		-DTPL_ENABLE_LAPACK=ON
		$(cmake-utils_use test Trilinos_ENABLE_TESTS)
		$(trilinos_enable adolc)
		$(trilinos_enable arprec)
		$(trilinos_enable boost Boost)
		$(trilinos_enable boost BoostLib)
		$(trilinos_enable cppunit Cppunit)
		$(trilinos_enable clp Clp)
		$(trilinos_enable cuda)
		$(trilinos_enable cuda CUSPARSE)
		$(trilinos_enable cuda Thrust)
		$(trilinos_enable eigen Eigen)
		$(trilinos_enable gtest gtest)
		$(trilinos_enable glpk)
		$(trilinos_enable hdf5)
		$(trilinos_enable hwloc)
		$(trilinos_enable hypre)
		$(trilinos_enable matio Matio)
		$(trilinos_enable metis)
		$(trilinos_enable mkl)
		$(trilinos_enable mkl PARDISO_MKL)
		$(trilinos_enable mumps)
		$(trilinos_enable netcdf Netcdf)
		$(trilinos_enable petsc)
		$(trilinos_enable qd)
		$(trilinos_enable qt4 QT)
		$(trilinos_enable scalapack)
		$(trilinos_enable scalapack BLACS)
		$(trilinos_enable scotch Scotch)
		$(trilinos_enable sparse AMD)
		$(trilinos_enable sparse CSparse)
		$(trilinos_enable sparse UMFPACK)
		$(trilinos_enable superlu SuperLU)
		$(trilinos_enable taucs)
		$(trilinos_enable tbb)
		$(trilinos_enable threads Pthread)
		$(trilinos_enable tvmet)
		$(trilinos_enable yaml yaml-cpp)
		$(trilinos_enable zlib Zlib)
		$(trilinos_enable X X11)
	)

	use eigen && \
		mycmakeargs+=(
		-DEigen_INCLUDE_DIRS="${EPREFIX}/usr/include/eigen3"
	)
	use hypre && \
		mycmakeargs+=(
		-DHYPRE_INCLUDE_DIRS="${EPREFIX}/usr/include/hypre"
	)
	use scotch && \
		mycmakeargs+=(
		-DScotch_INCLUDE_DIRS="${EPREFIX}/usr/include/scotch"
	)

	# cxsparse is a rewrite of csparse + extras
	use sparse && \
		mycmakeargs+=(
		-DCSparse_LIBRARY_NAMES="cxsparse"
	)

	# mandatory blas and lapack
	trilinos_conf blas BLAS
	trilinos_conf lapack LAPACK
	use superlu && trilinos_conf superlu SuperLU
	use metis && trilinos_conf metis METIS

	# blacs library is included in scalapack these days
	if use scalapack; then
		trilinos_conf scalapack SCALAPACK
		mycmakeargs+=(
			-DBLACS_LIBRARY_NAMES="scalapack"
			-DBLACS_INCLUDE_DIRS="${EPREFIX}/usr/include/blacs"
		)
	fi

	# TODO: do we need that line?
	export CC=mpicc CXX=mpicxx && tc-export CC CXX

	# cmake-utils eclass patches the base directory CMakeLists.txt
	# which does not work for complex Trilinos CMake modules
	CMAKE_BUILD_TYPE=RELEASE cmake-utils_src_configure

	# TODO:
	# python bindings with python-r1
	# fix hypre bindings
	# fix hdf5
	# cuda/thrust is untested
	# do we always need mpi? and for all packages: blah[mpi] ?
	# install docs, examples
	# see what packages are related, do we need REQUIRED_USE
	# proper use flags description
	# add more use flags/packages ?
}

src_install() {
	cmake-utils_src_install

	# Clean up the mess:
	rm -r "${ED}"/TrilinosRepoVersion.txt "${ED}"/lib || die "rm failed"
	mv "${ED}"/bin "${ED}/usr/$(get_libdir)"/trilinos || die "mv failed"

	# register $(get_libdir)/trilinos in LDPATH so that the dynamic linker
	# has a chance to pick up the libraries...
	cat >> "${T}"/99trilinos <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/trilinos"
	PATH="${EPREFIX}/usr/$(get_libdir)/trilinos/bin"
	EOF
	doenvd "${T}"/99trilinos
}
