# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gromacs/gromacs-3.3.1-r1.ebuild,v 1.4 2007/02/24 19:06:05 armin76 Exp $

inherit eutils fortran multilib

IUSE="3dnow X altivec double-precision mpi sse sse2"

# mopac7 qm/mm is broken until we can get files from
# http://md.chem.rug.nl/~groenhof/qmmm.html
# or somewhere else...

DESCRIPTION="The ultimate molecular dynamics simulation package"
SRC_URI="ftp://ftp.gromacs.org/pub/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gromacs.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc64 ~sparc x86"

DEPEND=">=sci-libs/fftw-3.0.1
	mpi? ( virtual/mpi )
	>=sys-devel/binutils-2.12
	app-shells/tcsh
	X? ( x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXp
		x11-libs/libXext
		x11-proto/xproto
		virtual/motif )"

src_unpack() {

	unpack ${A}
	if use ppc64 && use altivec ; then
		epatch "${FILESDIR}"/${PN}-ppc64-altivec.patch
	fi

	if use alpha ; then
		epatch ${FILESDIR}/${PN}-alpha-axp_asm.patch
	fi

	cd "${S}"

# Fix a typo in a couple of files.
	sed -e "s:_nb_kerne010_x86_64_sse2:_nb_kernel010_x86_64_sse2:" \
		-i src/gmxlib/nonbonded/nb_kernel_x86_64_sse2/nb_kernel010_x86_64_sse2.intel_syntax.s \
		-i src/gmxlib/nonbonded/nb_kernel_x86_64_sse2/nb_kernel010_x86_64_sse2.s \
		|| die "Failed to fix sse2 typo."

	sed -e "s:+0f:-f:" -i share/tutor/gmxdemo/demo \
		|| die "Failed to fixup demo script."

# Fix a sandbox violation that occurs when re-emerging with mpi.
	sed "/libdir=\"\$(libdir)\"/ a\	temp_libdir=\"${D}usr/$( get_libdir )\" ; \\\\" \
	-i src/tools/Makefile.am \
	|| die "sed tools/Makefile.am failed"

	sed -e "s:\$\$libdir:\$temp_libdir:" \
	-i src/tools/Makefile.am \
	|| die "sed tools/Makefile.am failed"

	cd "${WORKDIR}" && mv ${P} ${P}-single ;

	use double-precision && cp -prP ${P}-single ${P}-double ;

	if use mpi ; then
		cp -prP ${P}-single ${P}-single-mpi
		use double-precision && cp -prP ${P}-double ${P}-double-mpi
	fi
}

src_compile() {
	# static should work but something's broken.
	# gcc spec file may be screwed up.
	# Static linking should try -lgcc instead of -lgcc_s.
	# For more info:
	# http://lists.debian.org/debian-gcc/2002/debian-gcc-200201/msg00150.html

# We will compile single precision by default, and suffix double-precision with _d.
# Sparc is the only arch I can test on that needs to use fortran.
local myconf ;

case "${ARCH}" in

	x86)
			myconf="$myconf $(use_enable sse ia32-sse)"
			myconf="$myconf $(use_enable sse2 ia32-sse)"
			myconf="$myconf $(use_enable 3dnow ia32-3dnow)"

# If you don't enable at least one of the above, you must use g77, not gfortran.
			if ! use sse && ! use sse2 && ! use 3dnow ; then

				if ! has_version "=sys-devel/gcc-3*" ; then
					die "If you must run gromacs without sse (not recommended) gfortran will not work."
				else myconf="$myconf --enable-fortran" && fortran_pkg_setup

				fi
			fi
		;;

	amd64)
			myconf="$myconf --enable-x86-64-sse"
		;;

	ppc)
			if use altivec ; then
				myconf="$myconf --enable-ppc-altivec --disable-fortran"
			else
				if ! has_version "=sys-devel/gcc-3*" ; then

					die "If you must run gromacs without sse (not recommended) gfortran will not work."
				fi
				myconf="$myconf --enable-fortran" && fortran_pkg_setup
			fi
		;;

	ppc64)
			if use altivec ; then
				myconf="$myconf --enable-ppc-altivec --disable-fortran"
			else
				if ! has_version "=sys-devel/gcc-3*" ; then
					die "If you must run gromacs without sse (not recommended) gfortran will not work."
				fi
				myconf="$myconf --enable-fortran" && fortran_pkg_setup
			fi
		;;

	sparc)
			if ! has_version "=sys-devel/gcc-3*" ; then

				die "If you must run gromacs without sse (not recommended) gfortran will not work."
			else
				myconf="$myconf --enable-fortran" && fortran_pkg_setup
			fi
		;;

	ia64)
			myconf="$myconf --enable-ia64-asm"
		;;

	alpha)
			myconf="$myconf --enable-axp-asm"
		;;

esac

myconf="--enable-shared \
		--datadir=/usr/share \
		--bindir=/usr/bin \
		--libdir=/usr/$(get_libdir) \
		--with-fft=fftw3 \
		$(use_with X x) \
		${myconf}"

#		$(use_with mopac7 qmmm-mopac) \

cd "${WORKDIR}"/${P}-single
	econf ${myconf} --enable-float || die "configure single-precision failed"

	emake || die "emake single failed"

	if use mpi ; then
		cd "${WORKDIR}"/${P}-single-mpi
		econf ${myconf} --enable-float --enable-mpi --program-suffix=_mpi \
			|| die "failed to configure single-mpi mdrun"
		emake mdrun || die "failed to make single-precision mpi mdrun" ;
	fi

	if use double-precision ; then
		cd "${WORKDIR}"/${P}-double

		econf ${myconf} --enable-double --program-suffix=_d \
			|| die "configure double-precision failed"

		emake || die "emake double failed"

		if use mpi ; then
			cd "${WORKDIR}"/${P}-double-mpi
			econf ${myconf} --enable-double --enable-mpi --program-suffix=_mpi_d \
				|| die "failed to configure double-mpi mdrun" ;

			emake mdrun \
				|| die "failed to make double-precision mpi mdrun" ;
		fi
	fi

}

src_install () {
	cd ${WORKDIR}/${P}-single ;
	emake DESTDIR=${D} install || die "installing single failed"

	if use mpi ; then
		cd "${WORKDIR}"/${P}-single-mpi
		emake DESTDIR=${D} install-mdrun \
		|| die "installing mdrun_mpi failed"
	fi

	if use double-precision ; then
		cd ${WORKDIR}/${P}-double && emake DESTDIR=${D} install \
		|| die "installing double failed"

		if use mpi ; then
			cd "${WORKDIR}"/${P}-double-mpi
			emake DESTDIR=${D} install-mdrun \
		|| die "installing mdrun_mpi_d failed"
		fi

	fi

	dodoc AUTHORS INSTALL README

	# Move html and leave examples and templates under /usr/share/gromacs.
	mv "${D}"/usr/share/"${PN}"/html "${D}"/usr/share/doc/"${PF}"/
}
