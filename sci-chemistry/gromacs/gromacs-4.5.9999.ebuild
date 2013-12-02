# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-4.5.7.ebuild,v 1.2 2013/05/05 17:31:09 ottxor Exp $

EAPI="4"

TEST_PV="4.0.4"
MANUAL_PV="4.5.6"

FORTRAN_NEEDED=fkernels

inherit bash-completion-r1 cmake-utils eutils fortran-2 multilib toolchain-funcs

SRC_URI="test? ( ftp://ftp.gromacs.org/pub/tests/gmxtest-${TEST_PV}.tgz )
		doc? ( ftp://ftp.gromacs.org/pub/manual/manual-${MANUAL_PV}.pdf -> gromacs-manual-${MANUAL_PV}.pdf )"

if [ "${PV%9999}" != "${PV}" ]; then
	EGIT_REPO_URI="git://git.gromacs.org/gromacs http://repo.or.cz/r/gromacs.git"
	EGIT_BRANCH="release-4-5-patches"
	inherit git-2
else
	SRC_URI="${SRC_URI} ftp://ftp.gromacs.org/pub/${PN}/${P}.tar.gz
		sse2? ( http://dev.gentoo.org/~alexxy/gromacs/0001-Make-stack-non-executable-for-GAS-assembly.patch.gz )
		sse2? ( http://dev.gentoo.org/~alexxy/gromacs/0002-Make-stack-non-executable-for-ATT-assembly.patch.gz )"
fi

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="X altivec blas doc -double-precision +fftw fkernels gsl lapack
mpi +single-precision sse2 test +threads xml zsh-completion"
REQUIRED_USE="fkernels? ( !threads )"

CDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libSM
		x11-libs/libICE
		)
	blas? ( virtual/blas )
	fftw? ( sci-libs/fftw:3.0 )
	gsl? ( sci-libs/gsl )
	lapack? ( virtual/lapack )
	mpi? ( virtual/mpi )
	xml? ( dev-libs/libxml2:2 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	app-shells/tcsh"

RESTRICT="test"

src_prepare() {
	#add user patches from /etc/portage/patches/sci-chemistry/gromacs
	epatch_user

	if use mpi && use threads; then
		elog "mdrun uses only threads OR mpi, and gromacs favours the"
		elog "use of mpi over threads, so a mpi-version of mdrun will"
		elog "be compiled. If you want to run mdrun on shared memory"
		elog "machines only, you can safely disable mpi"
	fi

	if [[ ${PV} != *9999 ]] && use sse2; then
		# Add patches for non-exec stack - qa issue
		epatch "${WORKDIR}/0001-Make-stack-non-executable-for-GAS-assembly.patch"
		epatch "${WORKDIR}/0002-Make-stack-non-executable-for-ATT-assembly.patch"
		#alexxy patches, renamve kernel from .s to .S
		epatch "${FILESDIR}/${P}-cmake-cpp-asm.patch"
	fi

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
	local mycmakeargs_pre=( )
	#from gromacs configure
	if use fftw; then
		mycmakeargs_pre+=("-DGMX_FFT_LIBRARY=fftw3")
	else
		mycmakeargs_pre+=("-DGMX_FFT_LIBRARY=fftpack")
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

	#note for gentoo-PREFIX on aix, fortran (xlf) is still much faster
	if use fkernels; then
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

	#go from slowest to fasterest acceleration
	local acce="none"
	use fkernels && acce="fortran"
	use altivec && acce="altivec"
	use ia64 && acce="ia64"
	use sse2 && acce="sse"

	mycmakeargs_pre+=(
		$(cmake-utils_use X GMX_X11)
		$(cmake-utils_use blas GMX_EXTERNAL_BLAS)
		$(cmake-utils_use gsl GMX_GSL)
		$(cmake-utils_use lapack GMX_EXTERNAL_LAPACK)
		$(cmake-utils_use threads GMX_THREADS)
		$(cmake-utils_use xml GMX_XML)
		-DGMX_DEFAULT_SUFFIX=off
		-DGMX_ACCELERATION="$acce"
		-DGMXLIB="$(get_libdir)"
	)

	for x in ${GMX_DIRS}; do
		einfo "Configuring for ${x} precision"
		local suffix=""
		#if we build single and double - double is suffixed
		use double-precision && use single-precision && \
			[ "${x}" = "double" ] && suffix="_d"
		local p
		[ "${x}" = "double" ] && p="-DGMX_DOUBLE=ON" || p="-DGMX_DOUBLE=OFF"
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_MPI=OFF
			-DGMX_BINARY_SUFFIX="${suffix}" -DGMX_LIBS_SUFFIX="${suffix}" )
		BUILD_DIR="${WORKDIR}/${P}_${x}" cmake-utils_src_configure
		use mpi || continue
		einfo "Configuring for ${x} precision with mpi"
		mycmakeargs=( ${mycmakeargs_pre[@]} ${p} -DGMX_MPI=ON
			-DGMX_BINARY_SUFFIX="_mpi${suffix}" -DGMX_LIBS_SUFFIX="_mpi${suffix}" )
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" cmake-utils_src_configure
	done
}

src_compile() {
	for x in ${GMX_DIRS}; do
		einfo "Compiling for ${x} precision"
		BUILD_DIR="${WORKDIR}/${P}_${x}"\
			cmake-utils_src_compile
		use mpi || continue
		einfo "Compiling for ${x} precision with mpi"
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi"\
			cmake-utils_src_compile mdrun
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
		BUILD_DIR="${WORKDIR}/${P}_${x}" \
			cmake-utils_src_install
		use mpi || continue
		#cmake-utils_src_install does not support args
		#using cmake-utils_src_compile instead
		BUILD_DIR="${WORKDIR}/${P}_${x}_mpi" \
			cmake-utils_src_make install-mdrun DESTDIR="${D}"
	done

	sed -n -e '/^GMXBIN/,/^GMXDATA/p' "${ED}"/usr/bin/GMXRC.bash > "${T}/80gromacs"
	echo "VMD_PLUGIN_PATH=${EPREFIX}/usr/$(get_libdir)/vmd/plugins/*/molfile/" >> "${T}/80gromacs"

	doenvd "${T}/80gromacs"
	rm -f "${ED}"/usr/bin/GMXRC*

	newbashcomp "${ED}"/usr/bin/completion.bash ${PN}
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
	einfo
	einfo  "Please read and cite:"
	einfo  "Gromacs 4, J. Chem. Theory Comput. 4, 435 (2008). "
	einfo  "http://dx.doi.org/10.1021/ct700301q"
	einfo
	einfo  $(g_luck)
	einfo  "For more Gromacs cool quotes (gcq) add g_luck to your .bashrc"
	einfo
	elog  "Gromacs can use sci-chemistry/vmd to read additional file formats"
}
