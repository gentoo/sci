# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-2.1.73-r1.ebuild,v 1.2 2006/11/03 15:44:39 markusle Exp $

inherit flag-o-matic fortran autotools

# Copied shamelessly from markusle's devspace at http://dev.gentoo.org/~markusle/octave-overlay/

DESCRIPTION="GNU Octave is a high-level language (MatLab compatible) intended for numerical computations"
LICENSE="GPL-2"
HOMEPAGE="http://www.octave.org/"
SRC_URI="ftp://ftp.octave.org/pub/${PN}/${P}.tar.bz2"

SLOT="0"
IUSE="emacs readline zlib doc hdf5 curl"
# KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
KEYWORDS=""

DEPEND="dev-util/dejagnu
	virtual/blas
	virtual/lapack
	dev-libs/libpcre
	virtual/tetex
	>=sys-libs/ncurses-5.2-r3
	>=sci-visualization/gnuplot-3.7.1-r3
	>=sci-libs/fftw-3.1.2
	>=sci-mathematics/glpk-4.15
	>=dev-util/gperf-2.7.2
	zlib? ( sys-libs/zlib )
	hdf5? ( sci-libs/hdf5 )
	curl? ( net-misc/curl )
	!=app-text/texi2html-1.70"

FORTRAN="gfortran g77 f2c"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-disable-sparse-tests.patch
	epatch "${FILESDIR}"/${P}-test-fix.patch
}

src_compile() {
	local myconf="--localstatedir=/var/state/octave --enable-rpath"

	# force use of external blas, lapack, fftw
	myconf="${myconf} --with-blas=blas --with-lapack=lapack"
	myconf="${myconf} --with-fftw"
	myconf="${myconf} --enable-static --enable-shared --enable-dl"
	
	# disable sparse matrix stuff for now
	myconf="${myconf} --without-umfpack --without-colamd"
	myconf="${myconf} --without-ccolamd --without-cholmod --without-cxsparse"

	if [[ "${FORTRANC}" == "g77" ]]; then
		myconf="${myconf} --with-f77"
	elif [[ "${FORTRANC}" == "f2c" ]]; then
		myconf="${myconf} --with-f2c"
	fi

	econf \
		$(use_with hdf5) \
		$(use_with curl) \
		$(use_with zlib) \
		$(use_enable readline) \
		${myconf} \
		|| die "econf failed"

	emake -j1 || die "emake failed"
}

src_install() {
	cd "${S}"
	make install DESTDIR="${D}" || die "make install failed"
	if use doc; then
		octave-install-doc || die "Octave doc install failed"
	fi
	if use emacs; then
		cd emacs
		exeinto /usr/bin
		doexe octave-tags || die "Failed to install octave-tags"
		doman octave-tags.1 || die "Failed to install octave-tags.1"
		for emacsdir in /usr/share/emacs/site-lisp /usr/lib/xemacs/site-lisp; do
			insinto ${emacsdir}
			doins *.el || die "Failed to install emacs files"
		done
		cd ..
	fi
	dodir /etc/env.d || die
	echo "LDPATH=/usr/lib/octave-${PV}" > "${D}"/etc/env.d/99octave \
		|| die "Failed to set up env.d files"

	# Fixes ls-R files to remove /var/tmp/portage references.
	sed -i -e "s:${D}::g" "${D}"/usr/libexec/${PN}/ls-R && \
	sed -i -e "s:${D}::g" "${D}"/usr/share/${PN}/ls-R || \
		die "Failed to fix ls-R files."
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
	doins doc/faq/Octave-FAQ.pdf || die
	doins doc/interpreter/octave.pdf || die
	doins doc/liboctave/liboctave.pdf || die
	doins doc/refcard/refcard-a4.pdf || die
	doins doc/refcard/refcard-legal.pdf || die
	doins doc/refcard/refcard-letter.pdf || die
}
