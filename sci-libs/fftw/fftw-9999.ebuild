# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/fftw/fftw-3.3.3-r2.ebuild,v 1.3 2013/06/27 14:30:29 aballier Exp $

EAPI=5

#AUTOTOOLS_AUTORECONF=1
FORTRAN_NEEDED=fortran

inherit autotools-multilib eutils flag-o-matic fortran-2 multibuild toolchain-funcs versionator

DESCRIPTION="Fast C library for the Discrete Fourier Transform"
HOMEPAGE="http://www.fftw.org/"

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/FFTW/fftw3.git"
	KEYWORDS=""
	AUTOTOOLS_AUTORECONF=1
else
	SRC_URI="http://www.fftw.org/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
fi

LICENSE="GPL-2"
SLOT="3.0"
IUSE="altivec avx doc fma fortran mpi neon openmp quad sse sse2 static-libs test threads zbus"

RDEPEND="
	mpi? ( virtual/mpi )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r2
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

#can go once mpi is multlib
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/fftw3-mpi.h
	/usr/include/fftw3l-mpi.f03
	/usr/include/fftw3-mpi.f03
	/usr/include/fftw3q.f03
)

pkg_setup() {
	# XXX: this looks like it should be used with BUILD_TYPE!=binary

	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
		FORTRAN_NEED_OPENMP=1
	fi

	fortran-2_pkg_setup

	MULTIBUILD_VARIANTS=( single double longdouble )
	if use quad; then
		if [[ $(tc-getCC) == *gcc ]] && ! version_is_at_least 4.6 $(gcc-version); then
			ewarn "quad precision only available for gcc >= 4.6"
			die "need quad precision capable gcc"
		fi
		MULTIBUILD_VARIANTS+=( quad )
	fi
}

src_prepare() {
	# fix info file for category directory
	[[ ${PV} = *9999 ]] || sed -i \
		-e 's/Texinfo documentation system/Libraries/' \
		doc/fftw3."info" || die "failed to fix info file"

	autotools-utils_src_prepare
}

src_configure() {
	local x

	# filter -Os according to docs
	replace-flags -Os -O2

	my_configure() {
		#a bit hacky improve after #483758 is solved
		local x=${BUILD_DIR%-${ABI}}
		x=${x##*-}
		# there is no abi_x86_32 port of virtual/mpi right now
		local enable_mpi=$(use_enable mpi)
		multilib_is_native_abi || enable_mpi="--disable-mpi"

		#jlec reported USE=quad on abi_x86_32 has too less registers
		#stub Makefiles
		if use amd64 && ! multilib_is_native_abi && [[ $x = quad ]]; then
			mkdir -p "${BUILD_DIR}/tests" || die
			echo "all: ;" > "${BUILD_DIR}/Makefile" || die
			echo "install: ;" >> "${BUILD_DIR}/Makefile" || die
			echo "smallcheck: ;" > "${BUILD_DIR}/tests/Makefile" || die
			return 0
		fi

		myeconfargs=(
			$(use_enable fma)
			$(use_enable fortran)
			$(use_enable zbus mips-zbus-timer)
			$(use_enable threads)
			$(use_enable openmp)
		)
		if [[ $x == single ]]; then
			#altivec, sse, single-paired only work for single
			myeconfargs+=(
				--enable-single
				$(use_enable altivec)
				$(use_enable avx)
				$(use_enable sse)
				${enable_mpi}
				$(use_enable neon)
			)
		elif [[ $x == double ]]; then
			myeconfargs+=(
				$(use_enable avx)
				$(use_enable sse2)
				${enable_mpi}
			)
		elif [[ $x == longdouble ]]; then
			myeconfargs+=(
				--enable-long-double
				${enable_mpi}
				)
		elif [[ $x == quad ]]; then
			#quad does not support mpi
			myeconfargs+=( --enable-quad-precision )
		else
			die "${x} precision not implemented in this ebuild"
		fi

		autotools-utils_src_configure
	}

	multibuild_foreach_variant multilib_parallel_foreach_abi my_configure
}

src_compile() {
	multibuild_foreach_variant autotools-multilib_src_compile
}

src_test () {
	# We want this to be a reasonably quick test, but that is still hard...
	ewarn "This test series will take 30 minutes on a modern 2.5Ghz machine"
	# Do not increase the number of threads, it will not help your performance
	#local testbase="perl check.pl --nthreads=1 --estimate"
	#		${testbase} -${p}d || die "Failure: $n"
	multibuild_foreach_variant autotools-multilib_src_compile -C tests smallcheck
}

src_install () {
	local u x
	DOCS=( AUTHORS ChangeLog NEWS README TODO COPYRIGHT CONVENTIONS )
	HTML_DOCS=( doc/html/ )

	#copied from autotools-multilib_secure_install
	my_abi_src_install() {
		autotools-utils_src_install
		#https://github.com/FFTW/fftw3/pull/6
		# f03 are installed unconditionally, not a big problem as the quad
		# header is the only one to be wrapped.
		[[ ${BUILD_DIR} = *-quad* ]] || rm -f "${ED}/usr/include/fftw3q.f03"
		if [[ ${#MULTIBUILD_VARIANTS[@]} -gt 1 ]]; then
			multilib_prepare_wrappers
			multilib_check_headers
		fi
	}
	multibuild_foreach_variant multilib_foreach_abi my_abi_src_install
	multilib_install_wrappers

	if use doc; then
		dodoc doc/*.pdf
		insinto /usr/share/doc/${PF}/faq
		doins -r doc/FAQ/fftw-faq.html/*
	else
		rm -r "${ED}"/usr/share/doc/${PF}/html
	fi

	for x in "${ED}"/usr/lib*/pkgconfig/*.pc; do
		for u in $(usev mpi) $(usev threads) $(usex openmp omp ""); do
			sed -e "s|-lfftw3[flq]\?|&_$u &|" "$x" > "${x%.pc}_$u.pc" || die
		done
	done
}
