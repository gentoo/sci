# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-2.1.71-r1.ebuild,v 1.2 2006/01/29 19:41:01 cryos Exp $

inherit flag-o-matic fortran

DESCRIPTION="GNU Octave is a high-level language (MatLab compatible) intended for numerical computations"
LICENSE="GPL-2"
HOMEPAGE="http://www.octave.org/"
SRC_URI="ftp://ftp.octave.org/pub/octave/bleeding-edge/${P}.tar.bz2
		ftp://ftp.math.uni-hamburg.de/pub/soft/math/octave/${P}.tar.bz2"

SLOT="0"
IUSE="emacs static readline zlib tetex hdf5 mpi ifc blas"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

DEPEND="virtual/libc
	>=sys-libs/ncurses-5.2-r3
	>=sci-visualization/gnuplot-3.7.1-r3
	>=sci-libs/fftw-2.1.3
	>=dev-util/gperf-2.7.2
	zlib? ( sys-libs/zlib )
	hdf5? ( sci-libs/hdf5 )
	tetex? ( virtual/tetex )
	x86? ( ifc? ( dev-lang/ifc ) )
	blas? ( virtual/blas )
	!=app-text/texi2html-1.70"

# NOTE: octave supports blas/lapack from intel but this is not open
# source nor is it free (as in beer OR speech) Check out...
# http://developer.intel.com/software/products/mkl/mkl52/index.htm for
# more information

src_compile() {
	filter-flags -ffast-math

	local myconf="--localstatedir=/var/state/octave --enable-rpath"
	myconf="${myconf} --enable-lite-kernel"
	use static || myconf="${myconf} --disable-static --enable-shared --enable-dl"
	# Only add -lz to LDFLAGS if we have zlib in USE !
	# BUG #52604
	# Danny van Dyk 2004/08/26
	use zlib && LDFLAGS="${LDFLAGS} -lz"

	econf \
		$(use_with hdf5) \
		$(use_with mpi) \
		$(use_enable readline) \
		${myconf} \
		LDFLAGS="${LDFLAGS}" || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	if use tetex; then
		octave-install-doc || die "Octave doc install failed"
	fi
	if use emacs; then
		cd emacs
		exeinto /usr/bin
		doexe otags || die
		doman otags.1 || die
		for emacsdir in /usr/share/emacs/site-lisp /usr/lib/xemacs/site-lisp; do
			insinto ${emacsdir}
			doins *.el || die
		done
		cd ..
	fi
	dodir /etc/env.d || die
	echo "LDPATH=/usr/lib/octave-${PV}" > "${D}"/etc/env.d/99octave || die

	# Fixes ls-R files to remove /var/tmp/portage references.
	sed -i -e "s:${D}::g" "${D}"/usr/libexec/${PN}/ls-R || die
	sed -i -e "s:${D}::g" "${D}"/usr/share/${PN}/ls-R || die
}

pkg_postinst() {
	echo
	einfo "Some users have reported failures at running simple tests if"
	einfo "octave was built with agressive optimisations. You can check if"
	einfo "your setup is affected by this bug by running the following test"
	einfo "(inside the octave interpreter):"
	einfo
	einfo "octave:1> y = [1 3 4 2 1 5 3 5 6 7 4 5 7 10 11 3];"
	einfo "octave:2> g = [1 1 1 1 1 1 1 1 2 2 2 2 2 3 3 3];"
	einfo "octave:3> anova(y, g)"
	einfo
	einfo "If these commands complete successfully with no error message,"
	einfo "your installation should be ok. Otherwise, try recompiling"
	einfo "octave using less agressive \"CFLAGS\" (combining \"-O3\" and"
	einfo "\"-march=pentium4\" is known to cause problems)."
	echo
}

octave-install-doc() {
	echo "Installing documentation..."
	insinto /usr/share/doc/${PF}
	doins doc/faq/Octave-FAQ.dvi || die
	doins doc/interpreter/octave.dvi || die
	doins doc/liboctave/liboctave.dvi || die
	doins doc/refcard/refcard-a4.dvi || die
	doins doc/refcard/refcard-legal.dvi || die
	doins doc/refcard/refcard-letter.dvi || die
}
