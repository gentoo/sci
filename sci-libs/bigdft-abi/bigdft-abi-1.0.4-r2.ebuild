# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_5 python2_6 python2_7 )

inherit autotools-utils eutils flag-o-matic fortran-2 python-any-r1 toolchain-funcs


DESCRIPTION="A DFT electronic structure code using a wavelet basis set"
HOMEPAGE="http://www.abinit.org/downloads/plug-in-sources"
SRC_URI="http://forge.abinit.org/fallbacks/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="cuda doc etsf_io mpi netcdf openmp opencl test"

RDEPEND="
	>=sci-libs/libxc-1.2.0-r1[fortran]
	virtual/blas
	virtual/fortran
	virtual/lapack
	dev-libs/libyaml
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )
	opencl? ( virtual/opencl )
	etsf_io? ( >=sci-libs/etsf_io-1.0.3-r2 )
	netcdf? ( || (
				sci-libs/netcdf[fortran]
				sci-libs/netcdf-fortran
				)
			)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/autoconf-2.59
	doc? ( virtual/latex-base )
	${PYTHON_DEPS}
	dev-python/pyyaml[libyaml]
	dev-util/gdbus-codegen
	app-arch/tar
	app-arch/gzip"

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

	# This should be correct.
	#   It is gcc-centric because toolchain-funcs.eclass is gcc-centric.
	#   Should a bug be filed against toolchain-funcs.eclass?
	# if use openmp; then
		#         tc-has-openmp || \
		#                 die "Please select an openmp capable compiler like gcc[openmp]"
		# fi
	#
	# Luckily Abinit is a fortran package.
	#   fortran-2.eclass has its own test for OpenMP support,
	#   more general than toolchain-funcs.eclass
	#   The test itself proceeds inside fortran-2_pkg_setup
	if use openmp; then FORTRAN_NEED_OPENMP=1; fi

	fortran-2_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/"${P}"-CUDA_gethostname.patch

	tar -xjf "${FILESDIR}"/"${P}"-tests.tar.bz2 -C "${S}"/tests/DFT/
	eautoreconf
}

src_configure() {
	local openmp=""
	if use openmp; then
		# based on _fortran-has-openmp() of fortran-2.eclass
		local fcode=ebuild-openmp-flags.f
		local _fc=$(tc-getFC)

		cat <<- EOF > "${fcode}"
		1     call omp_get_num_threads
		2     end
		EOF

		for openmp in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
			${_fc} ${openmp} "${fcode}" -o "${fcode}.x" && break
		done

		rm -f "${fcode}.*"
	fi
	local modules="${EPREFIX}/usr/include"
#	local Imodules="-I${modules}"
	local Imodules=""
	local netcdff_libs="-lnetcdff"
	filter-flags '-m*' '-O*' "-pipe"
	local nvcflags="${CFLAGS}"
	_filter-var nvcflags '-m*' '-O*' "-pipe" "-W*"
	use cuda && filter-ldflags '-m*' '-O*' "-pipe" "-W*"
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
		--with-libxc="yes"
		--disable-internal-libxc
		$(use_enable cuda cuda-gpu)
		$(use_with cuda cuda-path /opt/cuda)
		$(use_with cuda nvcc-flags "${nvcflags}")
		$(use_enable opencl)
		$(use_with etsf_io etsf-io)
		"$(use etsf_io && echo "--with-netcdf-libs=$($(tc-getPKG_CONFIG) --libs netcdf) ${netcdff_libs}")"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		FCFLAGS="${FCFLAGS} ${openmp} ${Imodules}"
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
	if use doc; then
		VARTEXFONTS="${T}/fonts"
		autotools-utils_src_compile doc
	fi
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
	autotools-utils_src_install
}
