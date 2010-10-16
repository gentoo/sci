# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

LIBTOOLIZE="true"
TEST_PV="4.0.4"

EGIT_REPO_URI="git://git.gromacs.org/gromacs"
EGIT_BRANCH="master"

inherit autotools bash-completion eutils fortran git multilib toolchain-funcs

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI="test? ( ftp://ftp.gromacs.org/pub/tests/gmxtest-${TEST_PV}.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="X blas dmalloc doc -double-precision +fftw fkernels +gsl lapack
mpi +single-precision static static-libs test +threads +xml zsh-completion"

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

QA_EXECSTACK="usr/lib/libgmx.so.*
	usr/lib/libgmx_d.so.*"

use static && QA_EXECSTACK="$QA_EXECSTACK usr/bin/*"

pkg_setup() {
	if use fkernels; then
		FORTRAN="g77 gfortran ifc"
		fortran_pkg_setup
	else
		FORTRANC=""
	fi
}

src_prepare() {

	( use single-precision || use double-precision ) || \
		die "Nothing to compile, enable single-precision and/or double-precision"

	if use mpi && use threads; then
		elog "mdrun uses only threads OR mpi, and gromacs favours the"
		elog "use of mpi over threads, so a mpi-version of mdrun will"
		elog "be compiled. If you want to run mdrun on shared memory"
		elog "machines only, you can safely disable mpi"
	fi

	if use static; then
		use X && die "You cannot compile a static version with X support, disable X or static"
		use xml && die "You cannot compile a static version with xml support
		(see bug #306479), disable xml or static"
	fi
	epatch_user
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

	#we have pkg-config files
	myconf="${myconf} --disable-la-files"

	#from gromacs configure
	if ! use fftw; then
		ewarn "WARNING: The built-in FFTPACK routines are slow."
		ewarn "Are you sure you don\'t want to use FFTW?"
		ewarn "It is free and much faster..."
	fi

	if [[ $(gcc-version) == "4.1" ]]; then
		eerror "gcc 4.1 is not supported by gromacs"
		eerror "please run test suite"
		die
	fi

	#note for gentoo-PREFIX on apple: use --enable-apple-64bit

	#fortran will gone in gromacs 4.1 anyway
	#note for gentoo-PREFIX on aix, fortran (xlf) is still much faster
	if use fkernels; then
		use threads && die "You cannot compile fortran kernel with threads"
		ewarn "Fortran kernels are usually not faster than C kernels and assembly"
		ewarn "I hope, you know what are you doing..."
		myconf="${myconf} --enable-fortran"
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

	# by default its better to have dynamicaly linked binaries
	if use static; then
		#gmx build static libs by default
		myconf="${myconf} --disable-shared $(use_enable static all-static)"
	else
		myconf="${myconf} --disable-all-static --enable-shared $(use_enable static-libs static)"
	fi

	myconf="--datadir="${EPREFIX}"/usr/share \
			--bindir="${EPREFIX}"/usr/bin \
			--libdir="${EPREFIX}"/usr/$(get_libdir) \
			--docdir="${EPREFIX}"/usr/share/doc/"${PF}" \
			$(use_with dmalloc) \
			$(use_with fftw fft fftw3) \
			$(use_with gsl) \
			$(use_with X x) \
			$(use_with xml) \
			$(use_enable threads) \
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
		elog "install mdrun with mpi support. In addtion you will get libgmx and"
		elog "libmd with and without mpi support."
	fi

	myconfdouble="${myconf} --enable-double --program-suffix='${suffixdouble}'"
	myconfsingle="${myconf} --enable-float --program-suffix=''"
	for x in ${GMX_DIRS}; do
		einfo "Configuring for ${x} precision"
		cd "${S}-${x}"
		local p=myconf${x}
		ECONF_SOURCE="${S}" econf ${!p} --disable-mpi CC="$(tc-getCC)" F77="${FORTRANC}"
		use mpi || continue
		cd "${S}-${x}_mpi"
		ECONF_SOURCE="${S}" econf ${!p} --enable-mpi CC="$(tc-getCC)" F77="${FORTRANC}"
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		cd "${S}-${x}"
		einfo "Compiling for ${x} precision"
		emake || die "emake for ${x} precision failed"
		if use doc && [ -z "$OPTDIR" ]; then
			cd src/contrib
			emake options || die "emake options failed"
			OPTDIR="${PWD}"
		fi
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

	sed -n -e '/^GMXBIN/,/^GMXDATA/p' "${ED}"/usr/bin/GMXRC.bash > "${T}/80gromacs"
	doenvd "${T}/80gromacs"
	rm -f "${ED}"/usr/bin/GMXRC*

	dobashcompletion "${ED}"/usr/bin/completion.bash ${PN}
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins "${ED}"/usr/bin/completion.zsh _${PN}
	fi
	rm -f "${ED}"/usr/bin/completion.*

	# Fix typos in a couple of files.
	sed -e "s:+0f:-f:" -i "${ED}"usr/share/gromacs/tutor/gmxdemo/demo \
		|| die "Failed to fixup demo script."

	cd "${S}"
	dodoc AUTHORS INSTALL* README*
	if use doc; then
		dohtml -r "${ED}usr/share/gromacs/html/"
		insinto /usr/share/gromacs
		doins "admin/programs.txt"
		ls -1 "${ED}"/usr/bin | sed -e '/_d$/d' > "${T}"/programs.list
		doins "${T}"/programs.list
		cd "${OPTDIR}" || die "cd "${OPTDIR}" failed"
		../../libtool --mode=install cp options "${ED}"/usr/bin/g_options \
			|| die "install of g_options failed"
	fi
	rm -rf "${ED}usr/share/gromacs/html/"
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
	elog $(g_luck)
	elog "For more Gromacs cool quotes (gcq) add luck to your .bashrc"
	elog
	if use doc; then
		elog "Live Gromacs manual is available from app-doc/gromacs-manual"
	fi
}
