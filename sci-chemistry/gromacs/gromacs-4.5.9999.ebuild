# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

LIBTOOLIZE="true"
TEST_PV="4.0.4"
MANUAL_PV="4.5.3"

EGIT_REPO_URI="git://git.gromacs.org/gromacs"
EGIT_BRANCH="release-4-5-patches"

inherit autotools-utils bash-completion git multilib toolchain-funcs

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI="test? ( ftp://ftp.gromacs.org/pub/tests/gmxtest-${TEST_PV}.tgz )
		doc? (
		http://www.gromacs.org/@api/deki/files/133/=manual-${MANUAL_PV}.pdf -> gromacs-manual-${MANUAL_PV}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="X altivec blas dmalloc doc -double-precision +fftw fkernels +gsl lapack
mpi +single-precision static-libs test +threads +xml zsh-completion"

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

#gromacs has gnu exec stacks for speedup
QA_EXECSTACK="usr/lib/libgmx.so.*
	usr/lib/libgmx_d.so.*"

src_prepare() {
	if use mpi && use threads; then
		elog "mdrun uses only threads OR mpi, and gromacs favours the"
		elog "use of mpi over threads, so a mpi-version of mdrun will"
		elog "be compiled. If you want to run mdrun on shared memory"
		elog "machines only, you can safely disable mpi"
	fi

	eautoreconf

	GMX_DIRS=""
	use single-precision && GMX_DIRS+=" float"
	use double-precision && GMX_DIRS+=" double"
	#if neither single-precision nor double-precision is enabled
	#build at least default (single)
	[ -z "$GMX_DIRS" ] && GMX_DIRS+=" float"

	for x in ${GMX_DIRS}; do
		mkdir -p "${WORKDIR}/${P}_${x}" || die
		use test && cp -r "${WORKDIR}"/gmxtest "${WORKDIR}/${P}_${x}"
	done
}

src_configure() {
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

	#fortran will gone in gromacs 5.0 anyway
	#note for gentoo-PREFIX on aix, fortran (xlf) is still much faster
	if use fkernels; then
		use threads && eerror "You cannot compile fortran kernel with threads"
		ewarn "Fortran kernels are usually not faster than C kernels and assembly"
		ewarn "I hope, you know what are you doing..."
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

	# if we need external blas or lapack
	use blas && export LIBS+=" -lblas"
	use lapack && export LIBS+=" -llapack"

	for x in ${GMX_DIRS}; do
		local suffix=""
		#if we build single and double - double is suffixed
		use double-precision && use single-precision && \
			[ "${x}" = "double" ] && suffix="_d"
		myeconfargs=(
			--bindir="${EPREFIX}"/usr/bin
			--docdir="${EPREFIX}"/usr/share/doc/"${PF}"
			--enable-"${x}"
			$(use_with dmalloc)
			$(use_with fftw fft fftw3)
			$(use_with gsl)
			$(use_with X x)
			$(use_with xml)
			$(use_enable threads)
			$(use_enable altivec ppc-altivec)
			$(use_enable ia64 ia64-asm)
			$(use_with lapack external-lapack)
			$(use_with blas external-blas)
			$(use_enable fkernels fortran)
			--disable-bluegene
			--disable-la-files
			--disable-power6
		)

		einfo "Configuring for ${x} precision"
		AUTOTOOLS_BUILD_DIR="${WORKDIR}/${P}_${x}"\
			autotools-utils_src_configure --disable-mpi	--program-suffix="${suffix}" \
			CC="$(tc-getCC)" F77="$(tc-getFC)"
		use mpi || continue
		einfo "Configuring for ${x} precision with mpi"
		AUTOTOOLS_BUILD_DIR="${WORKDIR}/${P}_${x}_mpi"\
			autotools-utils_src_configure --enable-mpi --program-suffix="_mpi${suffix}" \
			CC="$(tc-getCC)" F77="$(tc-getFC)"
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		einfo "Compiling for ${x} precision"
		AUTOTOOLS_BUILD_DIR="${WORKDIR}/${P}_${x}"\
			autotools-utils_src_compile
		use mpi || continue
		einfo "Compiling for ${x} precision with mpi"
		AUTOTOOLS_BUILD_DIR="${WORKDIR}/${P}_${x}"\
			autotools-utils_src_compile mdrun
	done
}

src_test() {
	for x in ${GMX_DIRS}; do
		local oldpath="${PATH}"
		export PATH="${WORKDIR}/${P}_${x}/src/kernel:${S}-{x}/src/tools:${PATH}"
		cd "${WORKDIR}/${P}_${x}"
		emake -j1 tests || die "${x} Precision test failed"
		export PATH="${oldpath}"
	done
}

src_install() {
	for x in ${GMX_DIRS}; do
		AUTOTOOLS_BUILD_DIR="${WORKDIR}/${P}_${x}" \
			autotools-utils_src_install
		use mpi || continue
		#autotools-utils_src_install does not support args
		#using autotools-utils_src_compile instead
		AUTOTOOLS_BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" \
			autotools-utils_src_compile install-mdrun DESTDIR="${D}"

		#stolen from autotools-utils_src_install see comment above
		local args
		has static-libs ${IUSE//+} && ! use	static-libs || args='none'
		remove_libtool_files ${args}
	done

	sed -n -e '/^GMXBIN/,/^GMXDATA/p' "${ED}"/usr/bin/GMXRC.bash > "${T}/80gromacs"
	echo "VMD_PLUGIN_PATH=${EPREFIX}/usr/$(get_libdir)/vmd/plugins/*/molfile/" >> "${T}/80gromacs"

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
		newdoc "${DISTDIR}/gromacs-manual-${MANUAL_PV}.pdf" "manual-${MANUAL_PV}.pdf"
		dohtml -r "${ED}usr/share/gromacs/html/"
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
	elog "Gromacs can use sci-chemistry/vmd to read additional file formats"
	elog
}
