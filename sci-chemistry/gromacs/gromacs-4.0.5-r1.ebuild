# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LIBTOOLIZE="true"
TEST_PV="4.0.4"

inherit autotools bash-completion eutils fortran multilib

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI="ftp://ftp.gromacs.org/pub/${PN}/${P}.tar.gz
		test? ( ftp://ftp.gromacs.org/pub/tests/gmxtest-${TEST_PV}.tgz )
		doc? ( ftp://ftp.gromacs.org/pub/manual/manual-4.0.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86"
IUSE="X blas dmalloc doc -double-precision +fftw fkernels +gsl lapack mpi +single-precision static test +xml zsh-completion"

DEPEND="app-shells/tcsh
	X? ( x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE )
	dmalloc? ( dev-libs/dmalloc )
	blas? ( virtual/blas )
	fftw? ( sci-libs/fftw:3.0 )
	gsl? ( sci-libs/gsl )
	lapack? ( virtual/lapack )
	mpi? ( virtual/mpi )
	xml? ( dev-libs/libxml2 )"

RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {

	epatch "${FILESDIR}/${PN}-4.0.4-sparc-cyclecounter.patch"
	epatch "${FILESDIR}/${P}-path-overflow.patch"
	# Fix typos in a couple of files.
	sed -e "s:+0f:-f:" -i share/tutor/gmxdemo/demo \
		|| die "Failed to fixup demo script."

	# Fix a sandbox violation that occurs when re-emerging with mpi.
	sed "/libdir=\"\$(libdir)\"/ a\	temp_libdir=\"${D}usr/$( get_libdir )\" ; \\\\" \
	-i src/tools/Makefile.am \
	|| die "sed tools/Makefile.am failed"

	sed -e "s:\$\$libdir:\$temp_libdir:" \
	-i src/tools/Makefile.am \
	|| die "sed tools/Makefile.am failed"

	sed "/libdir=\"\$(libdir)\"/ a\ temp_libdir=\"${D}usr/$( get_libdir )\" ; \\\\" \
	-i src/tools/Makefile.am \
	|| die "sed tools/Makefile.am failed"

	sed -e "s:\$\$libdir:\$\$temp_libdir:" \
	-i src/tools/Makefile.am \
	|| die "sed tools/Makefile.am failed"

	use fkernels && epatch "${FILESDIR}/${PN}-4.0.4-configure-gfortran.patch"

	eautoreconf
	GMX_DIRS=""
	use single-precision && GMX_DIRS+=" single"
	use double-precision && GMX_DIRS+=" double"
	for x in ${GMX_DIRS}; do
		mkdir "${S}-${x}" || die
		use test && cp -r "${WORKDIR}"/gmxtest "${S}-${x}"
		use mpi || continue
		mkdir "${S}-${x}_mpi" || die
	done
}

src_configure() {
	local myconf
	local myconfsingle
	local myconfdouble
	local suffixdouble

	#leave all assembly options enabled mdrun is smart enough to deside itself
	#there so no gentoo on bluegene!
	myconf="${myconf} --disable-bluegene"

	#from gromacs configure
	if ! use fftw; then
		ewarn "WARNING: The built-in FFTPACK routines are slow."
		ewarn "Are you sure you don\'t want to use FFTW?"
		ewarn "It is free and much faster..."
	fi

	if [[ $(gcc-version) == "4.1" ]]; then
		ewarn "gcc 4.1 is not supported by gromacs"
		ewarn "please run test suite"
	fi

	#note for gentoo-PREFIX on apple: use --enable-apple-64bit

	#fortran will gone in gromacs 4.1 anyway
	#note for gentoo-PREFIX on aix, fortran (xlf) is still much faster
	if use fkernels; then
		ewarn "Fortran kernels are usually not faster than C kernels and assembly"
		ewarn "I hope, you know what are you doing..."
		FORTRAN="g77 gfortran ifc"
		myconf="${myconf} --enable-fortran" && fortran_pkg_setup
	else
		myconf="${myconf} --disable-fortran"
	fi

	# if we need external blas
	if use blas; then
		export LIBS="${LIBS} -lblas"
		myconf="${myconf} $(use_with blas external-blas)"
	fi

	# if we need external lapack
	if use lapack; then
		export LIBS="${LIBS} -llapack"
		myconf="${myconf} $(use_with lapack external-lapack)"
	fi

	myconf="--datadir=/usr/share \
			--bindir=/usr/bin \
			--libdir=/usr/$(get_libdir) \
			--docdir=/usr/share/doc/"${PF}" \
			$(use_with dmalloc) \
			$(use_with fftw fft fftw3) \
			$(use_with gsl) \
			$(use_with X x) \
			$(use_with xml) \
			$(use_enable static all-static) \
			${myconf}"

	#if we build single and double - double is suffixed
	if ( use double-precision && use single-precision ); then
		suffixdouble="_d"
	else
		suffixdouble=""
	fi

	if use double-precision ; then
		#from gromacs manual
		elog
		elog "For most simulations single precision is accurate enough. In some"
		elog "cases double precision is required to get reasonable results:"
		elog
		elog "-normal mode analysis, for the conjugate gradient or l-bfgs minimization"
		elog " and the calculation and diagonalization of the Hessian "
		elog "-calculation of the constraint force between two large groups of	atoms"
		elog "-energy conservation: this can only be done without temperature coupling and"
		elog " without cutoffs"
		elog
	fi

	if use mpi ; then
		elog "You have enabled mpi, only mdrun will make use of mpi, that is why"
		elog "we configure/compile gromacs twice (with and without mpi) and only"
		elog "install mdrun with mpi support. In addtion you will get libgmx,"
		elog "libgmxana and libmd with and without mpi support."
	fi

	myconfdouble="${myconf} --enable-double --program-suffix='${suffixdouble}'"
	myconfsingle="${myconf} --enable-float --program-suffix=''"
	for x in ${GMX_DIRS}; do
		einfo "Configuring for ${x} precision"
		cd "${S}-${x}"
		local p=myconf${x}
		ECONF_SOURCE="${S}" econf ${!p} --disable-mpi
		use mpi || continue
		cd "${S}-${x}_mpi"
		ECONF_SOURCE="${S}" econf ${!p} --enable-mpi
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		cd "${S}-${x}"
		einfo "Compiling for ${x} precision"
		emake || die "emake for ${x} precision failed"
		use mpi || continue
		cd "${S}-${x}_mpi"
		emake mdrun || die "emake mdrun for ${x} precision failed"
	done
}

src_test() {
	for x in ${GMX_DIRS}; do
		local oldpath="${PATH}"
		export PATH="${S}-${x}/src/kernel:${S}-{x}/src/tools:${PATH}"
		cd "${S}-${x}"
		emake -j1 tests || die "${x} Precision test failed"
		export PATH="${oldpath}"
	done
}

src_install() {
	for x in ${GMX_DIRS}; do
		cd "${S}-${x}"
		emake DESTDIR="${D}" install || die "emake install for ${x} failed"
		use mpi || continue
		cd "${S}-${x}_mpi"
		emake DESTDIR="${D}" install-mdrun || die "emake install-mdrun for ${x} failed"
	done

	sed -n -e '/^GMXBIN/,/^GMXDATA/p' "${D}"/usr/bin/GMXRC.bash > "${T}/80gromacs"
	doenvd "${T}/80gromacs"
	rm -f "${D}"/usr/bin/GMXRC*

	dobashcompletion "${D}"/usr/bin/completion.bash ${PN}
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins "${D}"/usr/bin/completion.zsh _${PN}
	fi
	rm -r "${D}"/usr/bin/completion.*

	cd "${S}"
	dodoc AUTHORS INSTALL README
	use doc && dodoc "${DISTDIR}"/manual-4.0.pdf
}

pkg_postinst() {
	env-update && source /etc/profile
	elog
	elog "Please read and cite:"
	elog "Gromacs 4, J. Chem. Theory Comput. 4, 435 (2008). "
	elog "http://dx.doi.org/10.1021/ct700301q"
	elog
	bash-completion_pkg_postinst
	elog
	elog $(luck)
	elog "For more Gromacs cool quotes (gcq) add luck to your .bashrc"
	elog
}
