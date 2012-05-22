# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils eutils flag-o-matic fortran-2 toolchain-funcs

REAL_P="${P/_pre/-tuto.}"
REAL_P="${REAL_P/-tuto.0/-tuto}"

DESCRIPTION="A DFT electronic structure code using a wavelet basis set"
HOMEPAGE="http://inac.cea.fr/L_Sim/BigDFT/"
SRC_URI="http://inac.cea.fr/L_Sim/BigDFT/${REAL_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda doc etsf_io mpi netcdf opencl test"

RDEPEND="
	=sci-libs/libxc-1*[fortran]
	virtual/blas
	virtual/fortran
	virtual/lapack
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )
	opencl? (
		|| (
			dev-util/nvidia-cuda-sdk
			dev-util/amdstream
			)
		)
	etsf_io? ( sci-libs/etsf_io )
	netcdf? ( sci-libs/netcdf[fortran] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.59
	doc? ( virtual/latex-base )"

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
}

src_prepare() {
	epatch \
		"${FILESDIR}"/"${REAL_P}"-libxc_dir_include.patch \
		"${FILESDIR}"/"${REAL_P}"-bigdft.pc.patch
	sed -i -e's/capitalize_module_ext/ax_fc_mod_ext/g' "${S}"/configure || die
	sed -i -e's/capitalize_module_ext/ax_fc_mod_ext/g' "${S}"/configure.ac || die
	eautoreconf
}

src_configure() {
	local modules="/usr/$(get_libdir)/finclude"
	local netcdff_libs="-lnetcdff"
	filter-flags '-m*' '-O*' "-pipe"
	local nvcflags="${CFLAGS}"
#	_filter-var nvcflags '-m*' '-O*' "-pipe"
	local myeconfargs=(
		$(use_enable mpi)
		--enable-optimised-convolution
		--enable-pseudo
		--enable-libbigdft
		--enable-binaries
		--disable-minima-hopping
		--with-moduledir="${modules}"
		--with-ext-linalg="$(pkg-config --libs-only-l lapack) \
			$(pkg-config --libs-only-l blas)"
		--with-ext-linalg-path="$(pkg-config --libs-only-L lapack) \
			$(pkg-config --libs-only-L blas)"
		--enable-libxc
		--disable-internal-libxc
		--with-libxc-path="/usr"
		--with-libxc-include="${modules}"
		$(use_enable cuda cuda-gpu)
		$(use_with cuda cuda-path /opt/cuda)
		$(use_with cuda nvcc-flags "${nvcflags}")
		$(use_enable opencl)
		$(use_with opencl ocl-path /usr)
		$(use_with etsf_io etsf-io)
		$(use_with etsf_io etsf-io-path "/usr")
		$(use_with etsf_io netcdf-path "$(pkg-config --libs-only-L netcdf)")
		"$(use etsf_io && echo "--with-netcdf-libs=$(pkg-config --libs netcdf) ${netcdff_libs}")"
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}} -I${modules}"
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

	use doc && autotools-utils_src_compile doc
}

src_test() {
	use test && autotools-utils_src_test
}

src_install() {
	autotools-utils_src_install HAVE_LIBXC=1
}
