# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Fast C library for the Discrete Fourier Transform"
HOMEPAGE="http://www.fftw.org/"
SRC_URI="http://www.fftw.org/${P//_}.tar.gz"

LICENSE="GPL-2"
SLOT="3.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="altivec doc fortran mpi openmp sse sse2 static-libs threads"

DEPEND="
	fortran? ( virtual/fortran )
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P//_}"

pkg_setup() {
	use openmp && FORTRAN_NEED_OPENMP="1"
	use fortran && fortran-2_pkg_setup
	FFTW_THREADS="--disable-threads --disable-openmp"
	if use openmp; then
		FFTW_THREADS="--disable-threads --enable-openmp"
	elif use threads; then
		FFTW_THREADS="--enable-threads --disable-openmp"
	fi
	if use openmp && ! tc-has-openmp; then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 "
		ewarn "If you want to build fftw with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
		ewarn "Otherwise, we will build using POSIX threads."
		epause 5
		FFTW_THREADS="--enable-threads --disable-openmp"
	fi
	FFTW_DIRS="single double longdouble"
	use openmp && [[ $(tc-getCC)$ == icc* ]] && append-ldflags $(no-as-needed)
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.2.1-as-needed.patch

	# fix info file for category directory
	sed -i \
		-e 's/Texinfo documentation system/Libraries/' \
		doc/fftw3.info || die "failed to fix info file"

	rm m4/lt* m4/libtool.m4

	AT_M4DIR=m4 eautoreconf
	for x in ${FFTW_DIRS}; do
		mkdir "${S}-${x}" || die
	done
}

src_configure() {
	# filter -Os according to docs
	replace-flags -Os -O2

	local myconfcommon="--enable-shared
		$(use_enable static-libs static)
		$(use_enable fortran)
		$(use_enable mpi)
		${FFTW_THREADS}"

	local myconfsingle="${myconfcommon} --enable-single"
	local myconfdouble="${myconfcommon}"
	local myconflongdouble="${myconfcommon} --enable-long-double"
	if use sse2; then
		myconfsingle="${myconfsingle} --enable-sse"
		myconfdouble="${myconfdouble} --enable-sse2"
	elif use sse; then
		myconfsingle="${myconfsingle} --enable-sse"
	fi
	# altivec only helps singles, not doubles
	if use altivec; then
		myconfsingle="${myconfsingle} --enable-altivec"
	fi

	for x in ${FFTW_DIRS}; do
		cd "${S}-${x}"
		einfo "Configuring for ${x} precision"
		local p=myconf${x}
		ECONF_SOURCE="${S}" econf ${!p}
	done
}

src_compile() {
	for x in ${FFTW_DIRS}; do
		cd "${S}-${x}"
		einfo "Compiling for ${x} precision"
		emake || die "emake for ${x} precision failed"
	done
}

src_test () {
	# We want this to be a reasonably quick test, but that is still hard...
	ewarn "This test series will take 30 minutes on a modern 2.5Ghz machine"
	# Do not increase the number of threads, it will not help your performance
	#local testbase="perl check.pl --nthreads=1 --estimate"
	#		${testbase} -${p}d || die "Failure: $n"
	for x in ${FFTW_DIRS}; do
		cd "${S}-${x}/tests"
		einfo "Testing ${x} precision"
		emake -j1 check || die "emake test ${x} failed"
	done
}

src_install () {
	# all builds are installed in the same place
	# libs have distinuguished names; include files, docs etc. identical.
	for x in ${FFTW_DIRS}; do
		cd "${S}-${x}"
		emake DESTDIR="${D}" install || die "emake install for ${x} failed"
	done

	cd "${S}"
	dodoc AUTHORS ChangeLog NEWS README TODO COPYRIGHT CONVENTIONS
	if use doc; then
		cd doc
		insinto /usr/share/doc/${PF}
		doins -r html fftw3.pdf || die "doc install failed"
		insinto /usr/share/doc/${PF}/faq
		doins FAQ/fftw-faq.html/*
	fi
}
