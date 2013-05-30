# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_5 python2_6 python2_7 )

inherit autotools-utils eutils flag-o-matic fortran-2 python-any-r1 toolchain-funcs

REAL_P="${P/_pre/-dev.}"

DESCRIPTION="A DFT electronic structure code using a wavelet basis set"
HOMEPAGE="http://inac.cea.fr/L_Sim/BigDFT/"
SRC_URI="http://forge.abinit.org/fallbacks/${REAL_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="cuda doc etsf_io mpi netcdf openmp opencl test"

RDEPEND="
	=sci-libs/libxc-1*[fortran]
	virtual/blas
	virtual/fortran
	virtual/lapack
	dev-libs/libyaml
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )
	opencl? (
		|| (
			dev-util/nvidia-cuda-sdk
			dev-util/amdstream
			)
		)
	etsf_io? ( sci-libs/etsf_io )
	netcdf? ( || (
				sci-libs/netcdf[fortran]
				sci-libs/netcdf-fortran
				)
			)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/autoconf-2.59
	doc? ( virtual/latex-base )
	cuda? ( ${PYTHON_DEPS} )
	opencl? ( ${PYTHON_DEPS} )
	app-arch/tar
	app-arch/gzip"

S="${WORKDIR}/${REAL_P}"

DOCS=( README INSTALL ChangeLog AUTHORS NEWS )

FORTRAN_STANDARD=90

pkg_setup() {
	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export F77="mpif77"
		export CC="mpicc"
	else
		tc-export FC F77 CC
	fi

	fortran-2_pkg_setup
	if use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
		die "Please select an openmp capable compiler like gcc[openmp]"
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/"${REAL_P}"-libxc_dir_include.patch \
		"${FILESDIR}"/"${REAL_P}"-GPUlink.patch \
		"${FILESDIR}"/"${REAL_P}"-nolib_mods.patch
	tar -xjf "${FILESDIR}"/"${REAL_P}"-tests.tar.bz2 -C "${S}"/tests/DFT/postSCF/
	eautoreconf
}

src_configure() {
	local openmp=""
	use openmp && openmp="-fopenmp"
	local modules="${EPREFIX}/usr/$(get_libdir)/finclude"
	local netcdff_libs="-lnetcdff"
	filter-flags '-m*' '-O*' "-pipe"
	local nvcflags="${CFLAGS}"
	_filter-var nvcflags '-m*' '-O*' "-pipe"
	local myeconfargs=(
		$(use_enable mpi)
		--enable-optimised-convolution
		--enable-pseudo
		--enable-libbigdft
		--enable-binaries
		--disable-minima-hopping
		--disable-internal-libyaml
		--enable-internal-libabinit
		--with-moduledir="${modules}"
		--with-ext-linalg="$($(tc-getPKG_CONFIG) --libs-only-l lapack) \
			$($(tc-getPKG_CONFIG) --libs-only-l blas)"
		--with-ext-linalg-path="$($(tc-getPKG_CONFIG) --libs-only-L lapack) \
			$($(tc-getPKG_CONFIG) --libs-only-L blas)"
		--enable-libxc
		--disable-internal-libxc
		--with-libxc-include="${modules}"
		$(use_enable cuda cuda-gpu)
		$(use_with cuda cuda-path /opt/cuda)
		$(use_with cuda nvcc-flags "${nvcflags}")
		$(use_enable opencl)
		$(use_with etsf_io etsf-io)
		"$(use etsf_io && echo "--with-netcdf-libs=$($(tc-getPKG_CONFIG) --libs netcdf) ${netcdff_libs}")"
		FCFLAGS="${FCFLAGS} ${openmp} -I${modules}"
		LD="$(tc-getLD)"
		CPP="$(tc-getCPP)"
		)
	autotools-utils_src_configure
}

src_compile() {
	#autotools-utils_src_compile() expanded
	_check_build_dir
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	emake -j1
	sed -i -e's%\$(top_builddir)/[^ ]*/lib\([^ /$-]*\)\.a%-l\1%g' bigdft.pc
	popd > /dev/null

	#autotools-utils_src_compile
	use doc && autotools-utils_src_compile doc
}

src_test() {
	if use test; then
		#autotools-utils_src_test() expanded
		_check_build_dir
		pushd "${BUILD_DIR}" > /dev/null || die
		# Run default src_test as defined in ebuild.sh
		cd tests
		emake -j1 check
		popd > /dev/null
	fi
}

src_install() {
	autotools-utils_src_install HAVE_LIBXC=1
}
