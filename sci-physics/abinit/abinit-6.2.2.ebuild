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
IUSE="cuda fftw fox gsl mpi smp test vdwxc"

RDEPEND="=sci-libs/bigdft-1.2.0.2
	sci-libs/etsf_io
	=sci-libs/libxc-1.0_p6071
	fox? ( sci-libs/fox[dom,sax,wcml,wxml] )
	sci-libs/netcdf[fortran,hdf5]
	sci-libs/hdf5[fortran]
	sci-libs/wannier90
	virtual/blas
	virtual/lapack
	gsl? ( sci-libs/gsl )
	fftw? ( sci-libs/fftw:3 )
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

# F90 code, g77 won't work
FORTRAN="gfortran ifc mpif90"

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
	epatch "${FILESDIR}"/6.2.2-long-message.patch
	epatch "${FILESDIR}"/6.2.2-non-plugin-libs.patch
# To compile against the current SVN HEAD of libxc:
#	epatch "${FILESDIR}"/6.0.3-libxc-flags.patch
	eautoreconf
#	find "${S}" -type f -exec grep -q -- '-llibxc' {} \; \
#		-exec sed -i -e's/-llibxc/-lxc/g' {} \;
}

src_configure() {
	local libs="-L/usr/$(get_libdir)"
	local modules="-I/usr/$(get_libdir)/finclude"
	local FoX_libs="-lFoX_dom -lFoX_sax -lFoX_wcml -lFoX_wxml -lFoX_common -lFoX_utils -lFoX_fsys"
	if use mpi; then
		MY_FC="mpif90"
		MY_CC="mpicc"
		MY_CXX="mpic++"
	else
		MY_FC="${tc-getFC}"
		MY_CC="$(tc-getCC)"
		MY_CXX="$(tc-getCXX)"
	fi
	econf \
		$(use_enable mpi) \
		$(use_enable mpi mpi-io) \
		$(use_enable smp) \
		$(use_enable fox) \
		$(use_enable gsl math) \
		$(use_enable fftw fft) \
		$(use_enable cuda gpu) \
		$(use_with cuda gpu-flavor cuda) \
		$(use_with cuda gpu-prefix /opt/cuda/) \
		$(use_enable vdwxc) \
		--enable-linalg \
		--enable-trio \
		--enable-etsf-io \
		--enable-dft \
		--with-linalg-flavor="atlas" \
		--with-linalg-libs="$(pkg-config --libs lapack)" \
		--with-trio-flavor="etsf+hdf+netcdf" \
		--with-netcdf-includes="-I/usr/include" \
		--with-netcdf-libs="$(pkg-config --libs netcdf) -lnetcdff -lhdf5_fortran" \
		$(use-with fox fox-includes "${modules}") \
		$(use-with fox fox-libs "${libs} ${FoX_libs}") \
		--with-etsf-io-includes="${modules}" \
		--with-etsf-io-libs="${libs} -letsf_io -letsf_io_low_level -letsf_io_utils" \
		--with-trio-includes="-I/usr/include ${modules}" \
		--with-trio-libs="$(pkg-config --libs netcdf) -lnetcdff -lhdf5_fortran -letsf_io -letsf_io_low_level -letsf_io_utils" \
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
		$(use-with fftw fft-flavor "fftw3+fftw3-threads") \
		$(use-with fftw fft-includes "-I/usr/include $(pkg-config --cflags fftw3)") \
		$(use-with fftw fft-libs "$(pkg-config --libs fftw3) -lfftw3_threads") \
		$(use-with gsl math-flavor "gsl") \
		$(use-with gsl math-includes "$(pkg-config --cflags gsl)") \
		$(use-with gsl math-libs "$(pkg-config --libs gsl)") \
		--with-timer-flavor="abinit" \
		FC="${MY_FC}" \
		CC="${MY_CC}" \
		CXX="${MY_CXX}" \
		LD="$(tc-getLD)" \
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}} ${modules}"
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
	emake tests_min
	emake tests_paw
	emake tests_gw
	emake tests_gw_paw
	emake tests tdft
	emake tests_bench

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
	find . -name ",,test*" -print | \
		while read testdir; do
			if [ -e summary_tests.tar ]; then
				tar rvf summary_tests.tar ${testdir}
			else tar cvf summary_tests.tar ${testdir}
			fi
		done

	elog "The full test results will be installed as summary_tests.tar.bz2."
	elog "Also a concise report tests_summary.txt is installed."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if use test; then
		dodoc tests/tests_summary.txt || ewarn "Copying tests summary failed"
		dodoc tests/summary_tests.tar || ewarn "Copying tests results failed"
	fi

	dodoc KNOWN_PROBLEMS README || die "Copying doc files failed"
}

pkg_postinst() {
	if use test; then
		elog "The full test results will be installed as summary_tests.tar.bz2."
		elog "Also a concise report tests_summary.txt is installed."
	fi
}
