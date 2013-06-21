# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils eutils flag-o-matic fortran-2 multilib toolchain-funcs

DESCRIPTION="Find total energy, charge density and electronic structure using density functional theory"
HOMEPAGE="http://www.abinit.org/"
SRC_URI="http://ftp.abinit.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cuda cuda-double -debug +etsf_io +fftw +fftw-threads +fox gsl gui +hdf5 libabinit mpi +netcdf openmp python -test +threads -vdwxc"

RDEPEND="~sci-libs/bigdft-abi-1.0.4
	>=sci-libs/libxc-1.2.0-r1[fortran]
	>=sci-physics/atompaw-3.0.1.9-r1[libxc]
	etsf_io? ( >=sci-libs/etsf_io-1.0.3-r2 )
	fox? ( >=sci-libs/fox-4.1.2-r2[sax] )
	netcdf? (
		|| (
			sci-libs/netcdf[fortran]
			sci-libs/netcdf-fortran
			)
		hdf5? (
			  sci-libs/netcdf[hdf5]
			  )
		)
	hdf5? ( sci-libs/hdf5[fortran] )
	>=sci-libs/wannier90-1.2-r1
	virtual/blas
	virtual/lapack
	gsl? ( sci-libs/gsl )
	fftw? (
		sci-libs/fftw:3.0
		fftw-threads? ( sci-libs/fftw:3.0[threads] )
		)
	mpi? ( virtual/mpi )
	python? ( dev-python/numpy )
	cuda? ( dev-util/nvidia-cuda-sdk )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gui? ( >=virtual/jdk-1.6.0
		app-arch/sharutils
		sys-apps/gawk )
	dev-perl/Text-Markdown"

S=${WORKDIR}/${P%[a-z]}

lat1loc=""

DOCS=( AUTHORS ChangeLog COPYING INSTALL KNOWN_PROBLEMS NEWS PACKAGING
	README README.ChangeLog README.GPU README.xlf RELNOTES THANKS )

FORTRAN_STANDARD=90

pkg_setup() {
	# Doesn't compile with gcc-4.0, only >=4.1
	if [[ $(tc-getFC) == *gfortran ]]; then
		if [[ $(gcc-major-version) -eq 4 ]] \
			&& [[ $(gcc-minor-version) -lt 1  ]]; then
				die "Requires gcc-4.1 or newer"
		fi
	fi

	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export F77="mpif77"
		export CC="mpicc"
		export CXX="mpic++"
	else
		tc-export FC F77 CC CXX
	fi

	# Preprocesor macross can make some lines really long
	append-fflags -ffree-line-length-none

	# This should be correct.
	#   It is gcc-centric because toolchain-funcs.eclass is gcc-centric.
	#   Should a bug be filed against toolchain-funcs.eclass?
	# if use openmp; then
	#         tc-has-openmp || \
	#                 die "Please select an openmp capable compiler like gcc[openmp]"
	# fi
	#
	# This is completely wrong.
	#   If other compilers than Gnu Compiler Collection can be used by portage,
	#   their support of OpenMP should be properly tested. This code limits the test
	#   to gcc, and blindly supposes that other compilers do support OpenMP.
	# if use openmp && [[ $(tc-getCC)$ == *gcc* ]] &&	! tc-has-openmp; then
	# 	die "Please select an openmp capable compiler like gcc[openmp]"
	# fi
	#
	# Luckily Abinit is a fortran package.
	#   fortran-2.eclass has its own test for OpenMP support,
	#   more general than toolchain-funcs.eclass
	#   The test itself proceeds inside fortran-2_pkg_setup
	if use openmp; then FORTRAN_NEED_OPENMP=1; fi

	fortran-2_pkg_setup

	# Sort out some USE options
	if use fftw-threads && ! use fftw; then
		ewarn "fftw-threads set but fftw not used, ignored"
	fi
	if use cuda-double && ! use cuda; then
		ewarn "cuda-double set but cuda not used, ignored"
	fi
	if use gui; then
		lat1loc="$(locale |awk '/LC_CTYPE="(.*)"/{sub("LC_CTYPE=\"",""); sub("\" *$", ""); print}')"
		if locale charmap |grep -i "\<iso885915\?\>"; then
			einfo "Good, locale compatible with the GUI build"
		else
			ewarn "The locale ${lat1loc} incompatible with the GUI build"
			if latloc=`locale -a| grep -i "\<iso885915\?\>"`; then
				if echo "${latloc}" |grep -q "^fr"; then
					lat1loc="$(echo "${latloc}" | grep -im1 "^fr")"
				else
					lat1loc="$(echo "${latloc}" | grep -im1 "iso88591")"
				fi
				einfo "Will use ${lat1loc} to build the GUI"
			else
				ewarn "No ISO-8859-1 nor ISO-8859-15 locale available, the GUI build may crash"
			fi
		fi
	fi
}

src_unpack() {
	default_src_unpack
	if use gui; then
		pushd "${S}" > /dev/null
		tar -xjf "${FILESDIR}"/6.12.3-gui-makefiles.tbz
		popd > /dev/null
	fi

}

src_prepare() {
	epatch \
		"${FILESDIR}"/6.2.2-change-default-directories.patch \
		"${FILESDIR}"/6.12.1-autoconf.patch \
		"${FILESDIR}"/6.12.1-xmalloc.patch \
		"${FILESDIR}"/7.0.4-test_dirs.patch
	eautoreconf
	sed -e"s/\(grep '\^-\)\(\[LloW\]\)'/\1\\\(\2\\\|pthread\\\)'/g" -i configure

	if use gui; then
		pushd gui > /dev/null
		eautoreconf
		popd > /dev/null
	fi
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
	local libs=""
	local modules="$(FoX-config --sax --fcflags)"
	local FoX_libs="${libs} $(FoX-config --sax --libs)"
	local trio_flavor=""
	use etsf_io && trio_flavor="${trio_flavor}+etsf_io"
	use fox && trio_flavor="${trio_flavor}+fox"
	use netcdf && trio_flavor="${trio_flavor}+netcdf"
	test "no${trio_flavor}" = "no" && trio_flavor="none"
	local netcdff_libs="-lnetcdff"
	use hdf5 && netcdff_libs="${netcdff_libs} -lhdf5_fortran"
	local fft_flavor="fftw3"
	local fft_libs=""
	# The fftw threads support is protected by black magick.
	# Anybody removes it, dies.
	# New USE flag "fftw-threads" was added to control usage
	# of the threaded fftw variant. Since fftw-3.3 has expanded
	# the paralel options by MPI and OpenMP support, analogical
	# USE flags should be added to select them in future;
	# unusable with previous FFTW versions, they are postponed
	# for now.
	if use fftw-threads; then
		fft_flavor="fftw3-threads"
		fft_libs="${fft_libs} $($(tc-getPKG_CONFIG) --libs fftw3_threads)"
		fft_libs="${fft_libs} $($(tc-getPKG_CONFIG) --libs fftw3f_threads)"
	else
		fft_libs="${fft_libs} $($(tc-getPKG_CONFIG) --libs fftw3)"
		fft_libs="${fft_libs} $($(tc-getPKG_CONFIG) --libs fftw3f)"
	fi
	local gpu_flavor="none"
	if use cuda; then
		gpu_flavor="cuda-single"
		if use cuda-double; then
			gpu_flavor="cuda-double"
		fi
	fi

	local myeconfargs=(
		--enable-clib
		--enable-exports
		$(use_enable gui)
		$(use_enable debug debug enhanced)
		$(use_enable mpi)
		$(use_enable mpi mpi-io)
		$(use_enable openmp)
		$(use_enable vdwxc)
		$(use_enable cuda gpu)
		"$(use cuda && echo "--with-gpu-flavor=${gpu_flavor}")"
		"$(use cuda && echo "--with-gpu-prefix=/opt/cuda/")"
		"$(use gsl && echo "--with-math-flavor=gsl")"
		"$(use gsl && echo "--with-math-incs=$($(tc-getPKG_CONFIG) --cflags gsl)")"
		"$(use gsl && echo "--with-math-libs=$($(tc-getPKG_CONFIG) --libs gsl)")"
		--with-linalg-flavor="atlas"
		--with-linalg-libs="$($(tc-getPKG_CONFIG) --libs lapack)"
		--with-trio-flavor="${trio_flavor}"
		"$(use netcdf && echo "--with-netcdf-incs=-I/usr/include")"
		"$(use netcdf && echo "--with-netcdf-libs=$($(tc-getPKG_CONFIG) --libs netcdf) ${netcdff_libs}")"
		"$(use fox && echo "--with-fox-incs=${modules}")"
		"$(use fox && echo "--with-fox-libs=${FoX_libs}")"
		"$(use etsf_io && echo "--with-etsf-io-incs=${modules}")"
		"$(use etsf_io && echo "--with-etsf-io-libs=${libs} -letsf_io -letsf_io_utils -letsf_io_low_level")"
		--with-dft-flavor="libxc+bigdft+atompaw+wannier90"
		--with-libxc-incs="${modules}"
		--with-libxc-libs="${libs} -lxc"
		--with-bigdft-incs="${modules}"
		--with-bigdft-libs="$($(tc-getPKG_CONFIG) --libs bigdft)"
		--with-atompaw-incs="${modules}"
		--with-atompaw-libs="${libs} -latompaw"
		--with-wannier90-bins="/usr/bin"
		--with-wannier90-incs="${modules}"
		--with-wannier90-libs="${libs} -lwannier $($(tc-getPKG_CONFIG) --libs lapack)"
		"$(use fftw && echo "--with-fft-flavor=${fft_flavor}")"
		"$(use fftw && echo "--with-fft-incs=-I/usr/include")"
		"$(use fftw && echo "--with-fft-libs=${fft_libs}")"
		--with-timer-flavor="abinit"
		LD="$(tc-getLD)"
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}} ${openmp} ${modules} -I/usr/include"
		)

	MARKDOWN=Markdown.pl autotools-utils_src_configure

	if use gui; then
		# autotools-utils_src_configure() part expanded
		_check_build_dir
		pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
		mkdir -p gui
		cd gui
		ECONF_SOURCE="${S}"/gui econf UUDECODE="uudecode"
		popd > /dev/null
	fi
}

src_compile() {
	autotools-utils_src_compile

	# Apparently libabinit.a is not built by default
	# Used by BigDFT. Should probably be built separately,
	# as a package of its own: BigDFT used by Abinit.
	# Does libabinit.a depend on BigDFT, if used?
	# Can Abinit use external libabinit.a?
	use libabinit && autotools-utils_src_compile libabinit.a

	if use gui; then
		#autotools-utils_src_compile() expanded
		# _check_build_dir has already been called
		pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
		# now what the function cannot be called to do
		cd gui
		LC_CTYPE="${lat1loc}" emake || die "Making GUI failed"
		popd > /dev/null
	fi

	sed -i -e's/libatlas/lapack/' "${AUTOTOOLS_BUILD_DIR}"/config.pc
}

src_test() {
	einfo "The tests take quite a while, easily several hours"
	# autotools-utils_src_test() expanded
	_check_build_dir
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	# again something the autotools-utils function cannot be called to do
	# now quite a lot of work actually
	cd tests
	emake tests_acc || ewarn "Accuracy tests failed"
	emake tests_paw || ewarn "PAW tests failed"
	emake tests_gw || ewarn "GW tests failed"
	emake tests_gw_paw || ewarn "GW-PAW tests failed"
	emake tests_bs || ewarn "BSE tests failed"
	emake tests_tddft || ewarn "TDDFT tests failed"
	emake tests_eph || ewarn "Elphon tests failed"

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
	popd > /dev/null

	elog "The full test results will be installed as summary_of_tests.tar.bz2."
	elog "Also a concise report tests_summary.txt is installed."
}

src_install() {
	#autotools-utils_src_install() expanded
	_check_build_dir
	pushd "${AUTOTOOLS_BUILD_DIR}" > /dev/null
	emake DESTDIR="${D}" install || die "make install failed"

	use libabinit && dolib libabinit.a

	if use gui; then
		pushd gui > /dev/null
		emake DESTDIR="${D}" install || die "The GUI install failed"
		popd > /dev/null
	fi

	if use test; then
		for dc in tests_summary.txt summary_of_tests.tar; do
			test -e tests/"${dc}" && dodoc tests/"${dc}" || ewarn "Copying tests results failed"
		done
	fi

	popd > /dev/null

	# XXX: support installing them from builddir as well!!!
	if [[ ${DOCS} ]]; then
		dodoc "${DOCS[@]}" || die "dodoc failed"
	else
		local f
		# same list as in PMS
		for f in README* ChangeLog AUTHORS NEWS TODO CHANGES \
				THANKS BUGS FAQ CREDITS CHANGELOG; do
			if [[ -s ${f} ]]; then
				dodoc "${f}" || die "(default) dodoc ${f} failed"
			fi
		done
	fi
	if [[ ${HTML_DOCS} ]]; then
		dohtml -r "${HTML_DOCS[@]}" || die "dohtml failed"
	fi

	# Remove libtool files and unnecessary static libs
	prune_libtool_files
}

pkg_postinst() {
	if use test; then
		elog "The full test results will be installed as summary_tests.tar.bz2."
		elog "Also a concise report tests_summary.txt is installed."
	fi
}
