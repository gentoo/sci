# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="Find total energy, charge density and electronic structure using density functional theory"
HOMEPAGE="http://www.abinit.org/"
SRC_URI="http://ftp.abinit.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cuda -debug +fftw +fox gsl +hdf5 mpi +netcdf python -smp +threads -test -vdwxc"

RDEPEND="=sci-libs/bigdft-1.2.0.2
	sci-libs/etsf_io
	=sci-libs/libxc-1.0[fortran]
	fox? ( sci-libs/fox[dom,sax,wcml,wxml] )
	netcdf? (
		sci-libs/netcdf[fortran]
		hdf5? (
		      sci-libs/netcdf[fortran,hdf5]
		      )
		)
	hdf5? ( sci-libs/hdf5[fortran] )
	sci-libs/wannier90
	virtual/blas
	virtual/lapack
	gsl? ( sci-libs/gsl )
	fftw? (
		sci-libs/fftw:2.1
		threads? ( sci-libs/fftw:2.1[threads] )
		)
	mpi? ( virtual/mpi )
	python? ( dev-python/numpy )
	cuda? ( dev-util/nvidia-cuda-sdk )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-perl/Text-Markdown"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

S=${WORKDIR}/${P%[a-z]}

pkg_setup() {
	# Doesn't compile with gcc-4.0, only >=4.1
	if [[ $(tc-getFC) == *gfortran ]]; then
		if [[ $(gcc-major-version) -eq 4 ]] \
			&& [[ $(gcc-minor-version) -lt 1  ]]; then
				die "Requires gcc-4.1 or newer"
		fi
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/6.2.2-change-default-directories.patch
	epatch "${FILESDIR}"/6.2.2-configure-fortran-calls.patch
	epatch "${FILESDIR}"/6.0.3-fftw.patch
	epatch "${FILESDIR}"/6.2.2-non-plugin-libs.patch
	epatch "${FILESDIR}"/6.4.2-openmp.patch
# To compile against libxc-1.0 or the current SVN HEAD:
	epatch "${FILESDIR}"/6.0.3-libxc-flags.patch
	eautoreconf
	find "${S}" -type f -exec grep -q -- '-llibxc' {} \; \
		-exec sed -i -e's/-llibxc/-lxc/g' {} \;
}

src_configure() {
	local libs="-L/usr/$(get_libdir)"
	local modules="-I/usr/$(get_libdir)/finclude"
	local FoX_libs="${libs} -lFoX_dom -lFoX_sax -lFoX_wcml -lFoX_wxml -lFoX_common -lFoX_utils -lFoX_fsys"
	local trio_flavor="etsf"
	use fox && trio_flavor="${trio_flavor}+fox"
	use hdf5 && trio_flavor="${trio_flavor}+hdf"
	use netcdf && trio_flavor="${trio_flavor}+netcdf"
	local netcdff_libs="-lnetcdff"
	use hdf5 && netcdff_libs="${netcdff_libs} -lhdf5_fortran"
	local trio_libs="-letsf_io -letsf_io_low_level -letsf_io_utils"
	use fox && trio_libs="${trio_libs} ${FoX_libs}"
	use netcdf && trio_libs="${trio_libs} $(pkg-config --libs netcdf) -lnetcdff"
	use hdf5 && trio_libs="${trio_libs} -lhdf5_fortran"
	local fft_flavor="fftw2"
	local fft_libs="-L/usr/lib"
	if use threads; then
		fft_libs="${fft_libs} -lfftw_threads"
		fft_flavor="fftw2-threads"
	fi
	fft_libs="${fft_libs} -lfftw -lrt -lm"
	if use mpi; then
		MY_FC="mpif90"
		MY_CC="mpicc"
		MY_CXX="mpic++"
	else
		MY_FC="$(tc-getFC)"
		MY_CC="$(tc-getCC)"
		MY_CXX="$(tc-getCXX)"
	fi
	if use smp; then
		MY_FC="${MY_FC} -fopenmp"
		MY_CC="${MY_CC} -fopenmp"
		MY_CXX="${MY_CXX} -fopenmp"
	fi
	MARKDOWN=Markdown.pl econf \
		$(use_enable debug debug enhanced) \
		$(use_enable mpi) \
		$(use_enable mpi mpi-io) \
		$(use_enable smp) \
		$(use_enable fox) \
		$(use_enable gsl math) \
		$(use_enable fftw fft) \
		$(use_enable vdwxc) \
		$(use_enable cuda gpu) \
		"$(use cuda && echo "--with-gpu-flavor=cuda-single")" \
		"$(use cuda && echo "--with-gpu-prefix=/opt/cuda/")" \
		"$(use gsl && echo "--with-math-flavor=gsl")" \
		"$(use gsl && echo "--with-math-includes=$(pkg-config --cflags gsl)")" \
		"$(use gsl && echo "--with-math-libs=$(pkg-config --libs gsl)")" \
		--enable-linalg \
		--enable-trio \
		--enable-etsf-io \
		--enable-dft \
		--with-linalg-flavor="atlas" \
		--with-linalg-libs="$(pkg-config --libs lapack)" \
		--with-trio-flavor="${trio_flavor}" \
		"$(use netcdf && echo "--with-netcdf-includes=-I/usr/include")" \
		"$(use netcdf && echo "--with-netcdf-libs=$(pkg-config --libs netcdf) ${netcdff_libs}")" \
		"$(use fox && echo "--with-fox-includes=${modules}")" \
		"$(use fox && echo "--with-fox-libs=${FoX_libs}")" \
		--with-etsf-io-includes="${modules}" \
		--with-etsf-io-libs="${libs} -letsf_io -letsf_io_low_level -letsf_io_utils" \
		--with-trio-includes="-I/usr/include ${modules}" \
		--with-trio-libs="${trio_libs}" \
		--with-dft-flavor="libxc+bigdft+wannier90" \
		--with-libxc-includes="${modules}" \
		--with-libxc-libs="${libs} -lxc" \
		--with-bigdft-includes="${modules}" \
		--with-bigdft-libs="${libs} -lpoissonsolver -lbigdft" \
		--with-wannier90="/usr/bin/wannier90.x" \
		--with-wannier90-includes="${modules}" \
		--with-wannier90-libs="${libs} -lwannier $(pkg-config --libs lapack)" \
		--with-dft-includes="${modules}" \
		--with-dft-libs="${libs} -lwannier -lpoissonsolver -lbigdft -lxc $(pkg-config --libs lapack)" \
		"$(use fftw && echo "--with-fft-flavor=${fft_flavor}")" \
		"$(use fftw && echo "--with-fft-includes=-I/usr/include")" \
		"$(use fftw && echo "--with-fft-libs=${fft_libs}")" \
		--with-timer-flavor="abinit" \
		FC="${MY_FC}" \
		CC="${MY_CC}" \
		CXX="${MY_CXX}" \
		LD="$(tc-getLD)" \
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}} ${modules} -I/usr/include"
}

src_compile() {
#	if use mpi; then
#		emake multi || die
#	else
		emake || die
#	fi
}

src_test() {
	einfo "The tests take quite a while, on the order of 1-2 hours"
	einfo "on an Intel Penryn (2.5 GHz)."
	cd "${S}"/tests
	emake tests_min || ewarn "Minimal tests failed"
	emake tests_paw || ewarn "PAW tests failed"
	emake tests_gw || ewarn "GW tests failed"
	emake tests_gw_paw || ewarn "GW-PAW tests failed"
	emake tests tdft || ewarn "TDFT tests failed"
	emake tests_bench || ewarn "Benchmarks failed"

	local REPORT
	for REPORT in $(find . -name report); do
		REPORT=${REPORT#*/}
		elog "Parameters and unusual results for ${REPORT%%/*} tests"
		echo "Parameters and unusual results for ${REPORT%%/*} tests" >>tests_summary.txt
		while read line; do
			elog "${line}"
			echo "${line}" >>tests_summary.txt
		done \
			< <(grep -v -e succeeded -e passed ${REPORT})
	done

	local testdir
	find . -name "tmp-test*" -print | \
		while read testdir; do
			if [ -e summary_of_tests.tar ]; then
				tar rvf summary_of_tests.tar ${testdir}
			else tar cvf summary_of_tests.tar ${testdir}
			fi
		done

	elog "The full test results will be installed as summary_of_tests.tar.bz2."
	elog "Also a concise report tests_summary.txt is installed."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if use test; then
		dodoc tests/tests_summary.txt || ewarn "Copying tests summary failed"
		dodoc tests/summary_tests.tar || ewarn "Copying tests results failed"
		dodoc tests/summary_of_tests.tar || ewarn "Copying tests results failed"
	fi

	dodoc KNOWN_PROBLEMS README || die "Copying doc files failed"
}

pkg_postinst() {
	if use test; then
		elog "The full test results will be installed as summary_tests.tar.bz2."
		elog "Also a concise report tests_summary.txt is installed."
	fi
}
