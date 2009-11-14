# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-4.0.5.ebuild,v 1.3 2009/10/31 19:20:05 armin76 Exp $

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
IUSE="X blas dmalloc doc -double-precision +fftw fkernels gsl lapack mpi +single-precision static test +xml zsh-completion"

DEPEND="app-shells/tcsh
	X? ( x11-libs/libX11 )
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

	cd "${WORKDIR}"

	use test && mv gmxtest "${P}"
	mv "${P}" "${P}-single"
	if ( use double-precision ) ; then
		einfo "Moving sources for Multiprecision Build"
		cp -prP "${P}-single" "${P}-double"
	fi
}

src_configure() {
	local myconf ;
	local myconf_s ;
	local myconf_d ;
	local suffix_d ;

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
			$(use_enable mpi) \
			$(use_with X x) \
			$(use_with xml) \
			$(use_enable static all-static) \
			${myconf}"

	#if we build both double is suffixed
	if ( use double-precision && use single-precision ); then
		suffix_d="_d"
	else
		suffix_d=""
	fi

	if use double-precision ; then
		#from gromacs manual
		elog
		elog "For most simulations single precision is accurate enough. In some"
		elog "cases double precision is required	to get reasonable results:"
		elog
		elog "-normal mode analysis, for the conjugate gradient or l-bfgs minimization"
		elog " and the calculation and diagonalization of the Hessian "
		elog "-calculation of the constraint force between two large groups of	atoms"
		elog "-energy conservation: this can only be done without temperature coupling and"
		elog " without cutoffs"
		elog
		einfo "Configuring Double Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-double
		myconf_d="${myconf} --enable-double --program-suffix='${suffix_d}'"
		econf ${myconf_d} || die "Double Precision econf failed"
	fi

	if use single-precision ; then
		einfo "Configuring Single Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-single
		myconf_s="${myconf} --enable-float --program-suffix=''"
		econf ${myconf_s} || die "configure failed"
	fi
}

src_compile() {
	if use double-precision ; then
		einfo "Building Double Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-double
		emake || die "Double Precision emake failed"
	fi

	if use single-precision ; then
		einfo "Building Single Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-single
		emake || die "Single Precision emake failed"
	fi
}

src_test() {
	if use single-precision ; then
		export PATH="${WORKDIR}/${P}-single/src/kernel:${WORKDIR}/${P}-single/src/tools:$PATH"
		cd "${WORKDIR}"/"${P}"-single
		emake -j1 tests || die "Single Precision test failed"
	fi

	if use double-precision ; then
		export PATH="${WORKDIR}/${P}-double/src/kernel:${WORKDIR}/${P}-double/src/tools:$PATH"
		cd "${WORKDIR}"/"${P}"-double
		emake -j1 tests || die "Double Precision test failed"
	fi
}

src_install() {
	if use single-precision ; then
		einfo "Installing Single Precision"
		cd "${WORKDIR}"/"${P}"-single
		emake DESTDIR="${D}" install || die "Installing Single Precision failed"
	fi

	if use double-precision ; then
		einfo "Installing Double Precision"
		cd "${WORKDIR}"/"${P}"-double
		emake DESTDIR="${D}" install || die "Installing Double Precision failed"
	fi

	sed -n -e '/^GMXBIN/,/^GMXDATA/p' "${D}"/usr/bin/GMXRC.bash > "${T}/80gromacs"
	doenvd "${T}/80gromacs"
	rm -f "${D}"/usr/bin/GMXRC*

	dobashcompletion "${D}"/usr/bin/completion.bash ${PN}
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins "${D}"/usr/bin/completion.zsh _${PN}
	fi
	rm -r "${D}"/usr/bin/completion.*

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
	elog "For more Gromacs cool quotes (gcq)  add luck to your .bashrc"
	elog
}
