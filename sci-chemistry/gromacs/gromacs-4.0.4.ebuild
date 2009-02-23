# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-4.0.2.ebuild,v 1.1 2009/01/04 01:04:00 je_fro Exp $

EAPI="2"

LIBTOOLIZE="true"

inherit autotools eutils flag-o-matic fortran multilib

DESCRIPTION="The ultimate molecular dynamics simulation package"
HOMEPAGE="http://www.gromacs.org/"
SRC_URI="ftp://ftp.gromacs.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86"
IUSE="3dnow X altivec blas double-precision gsl lapack gmxmopac7 mpi +single-precision sse sse2 static xml"

# mopac7 qm/mm is broken until we can get files from
# http://md.chem.rug.nl/~groenhof/qmmm.html
# or somewhere else...

DEPEND=">=sci-libs/fftw-3.0.1
	app-shells/tcsh
	X? ( x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXp
		x11-libs/libXext
		x11-proto/xproto
		x11-libs/openmotif )
	blas? ( virtual/blas )
	gsl? ( sci-libs/gsl )
	lapack? ( virtual/lapack )
	gmxmopac7? ( sci-chemistry/mopac7[gmxmopac7=] )
	mpi? ( virtual/mpi )
	xml? ( dev-libs/libxml2 )"

RDEPEND="${DEPEND}"

FORTRAN="g77 gfortran ifc"

src_unpack() {

	unpack ${A}
	cd "${S}"
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

	append-ldflags -Wl,--no-as-needed

	eautoreconf

	cd "${WORKDIR}"
	mv "${P}" "${P}-single"
	if ( use double-precision ) ; then
		einfo "Moving sources for Multiprecision Build"
		cp -prP "${P}-single" "${P}-double"
	fi
}

src_configure() {

	# static should work but something's broken.
	# gcc spec file may be screwed up.
	# Static linking should try -lgcc instead of -lgcc_s.
	# For more info:
	# http://lists.debian.org/debian-gcc/2002/debian-gcc-200201/msg00150.html

	# We will compile single precision by default, and suffix double-precision with _d.
	# Sparc is the only arch I can test on that needs to use fortran.
	local myconf ;
	local myconf_s ;
	local myconf_d ;

	case "${ARCH}" in

		x86)
			if ( use sse || use sse2 ) ; then
				myconf="${myconf} --enable-ia32-sse"
			fi
			myconf="$myconf $(use_enable 3dnow ia32-3dnow)"

			if ( ! use sse && ! use sse2 && ! use 3dnow ) ; then
				if ! has_version "=sys-devel/gcc-3*" ; then
					die "If you must run gromacs without sse (not recommended) gfortran will not work."
				else
					myconf="${myconf} --enable-fortran" && fortran_pkg_setup
				fi
			else
				myconf="${myconf} --disable-fortran"
			fi
			;;

		amd64)
			myconf="$myconf --enable-x86-64-sse --disable-fortran"
			;;

		ppc*)
			if use altivec ; then
				myconf="${myconf} --enable-ppc-altivec --disable-fortran"
			else
				if ! has_version "=sys-devel/gcc-3*" ; then
					die "If you must run gromacs without sse (not recommended) gfortran will not work."
				else
					myconf="${myconf} --enable-fortran" && fortran_pkg_setup
				fi
			fi
			;;

		ia64)
			myconf="$myconf --enable-ia64-asm --disable-fortran"
			;;

		alpha)
			if ! has_version "=sys-devel/gcc-3*" ; then
				die "If you must run gromacs without sse (not recommended) gfortran will not work."
			else
				myconf="$myconf --enable-fortran" && fortran_pkg_setup
			fi
			;;

		sparc)
			if ! has_version "=sys-devel/gcc-3*" ; then
				die "If you must run gromacs without sse (not recommended) gfortran will not work."
			else
				myconf="${myconf} --enable-fortran" && fortran_pkg_setup
			fi
			;;
	esac

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
	if use gmxmopac7; then
		export LIBS="${LIBS} -lgmxmopac7"
		myconf="${myconf} $(use_with gmxmopac7 qmmm-mopac)"
	fi
	# by default gromacs builds as static since 4.0.3
	if use static; then
		myconf="${myconf} --enable-all-static"
	else
		myconf="${myconf} --enable-shared"
	fi

	myconf="--datadir=/usr/share \
			--bindir=/usr/bin \
			--libdir=/usr/$(get_libdir) \
			--with-fft=fftw3 \
			$(use_with gsl) \
			$(use_enable mpi) \
			$(use_with X x) \
			$(use_with xml) \
			${myconf}"

	if ( use double-precision && use single-precision ); then
		einfo "Configuring Single Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-single
		myconf_s="${myconf}  --enable-float --disable-double --program-suffix=''"
		econf ${myconf_s} || die "Single Precision econf failed"

		einfo "Configuring Double Precision Gromacs"
		cd "${WORKDIR}"/"${P}"-double
		myconf_d="${myconf} --enable-double --disable-float --program-suffix=_d"
		econf ${myconf_d} || die "Double Precision econf failed"

	elif use double-precision ; then
		einfo "Configuring Double Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-double
		myconf_d="${myconf} --enable-double --disable-float --program-suffix=''"
		econf ${myconf_d} || die "Double Precision econf failed"

	elif use single-precision ; then
		einfo "Configuring Single Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-single
		myconf_s="${myconf} --enable-float --disable-double --program-suffix=''"
		econf ${myconf_s} || die "configure failed"
	fi
}

src_compile() {
	if ( use double-precision && use single-precision ); then
		einfo "Building Single Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-single
		emake || die "Single Precision emake failed"

		einfo "Building Double Precision Gromacs"
		cd "${WORKDIR}"/"${P}"-double
		emake || die "Double Precision emake failed"

	elif use double-precision ; then
		einfo "Building Double Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-double
		emake || die "Double Precision emake failed"

	elif use single-precision ; then
		einfo "Building Single Precison Gromacs"
		cd "${WORKDIR}"/"${P}"-single
		emake || die "Single Precision emake failed"
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

	dodoc AUTHORS INSTALL README
	# Move html and leave examples and templates under /usr/share/gromacs.
	mv "${D}"/usr/share/"${PN}"/html "${D}"/usr/share/doc/"${PF}"/
}
