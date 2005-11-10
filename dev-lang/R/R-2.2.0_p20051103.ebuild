# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/R/R-2.1.1.ebuild,v 1.5 2005/09/03 19:24:43 corsair Exp $

inherit fortran toolchain-funcs

IUSE="blas jpeg nls png readline tcltk X"
DESCRIPTION="R is GNU S - A language and environment for statistical computing and graphics."
MY_P="R-patched"
SRC_URI="ftp://ftp.stat.math.ethz.ch/Software/R/${MY_P}_2005-11-09.tar.bz2"
#SRC_URI="http://cran.r-project.org/src/base/R-2/${P}.tar.gz"
#There are daily release patches, don't know how to utilize these
#"ftp://ftp.stat.math.ethz.ch/Software/${PN}/${PN}-release.diff.gz"

HOMEPAGE="http://www.r-project.org/"
DEPEND="virtual/libc
		>=dev-lang/perl-5.6.1-r3
		readline? ( >=sys-libs/readline-4.1-r3 )
		jpeg? ( >=media-libs/jpeg-6b-r2 )
		png? ( >=media-libs/libpng-1.2.1 )
		blas? ( virtual/blas )
		X? ( virtual/x11 )
		tcltk? ( dev-lang/tk )"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	# Test for a 64 bit architecture - f2c won't work on 64 bit archs with R.
	# Thanks to vapier for providing the test.
	echo 'int main(){}' > test.c
	$(tc-getCC) -c test.c -o test.o
	if file test.o | grep -qs 64-bit ; then
		einfo "64 bit architecture detected, using g77."
		FORTRAN="g77"
	else
		FORTRAN="g77 f2c"
	fi
	fortran_pkg_setup
}

src_compile() {
	local myconf="--enable-R-profiling --enable-R-shlib --enable-linux-lfs"

	if use tcltk; then
		#configure needs to find the files tclConfig.sh and tkConfig.sh
		myconf="${myconf} --with-tcltk --with-tcl-config=/usr/lib/tclConfig.sh --with-tk-config=/usr/lib/tkConfig.sh"
	else
		myconf="${myconf} --without-tcltk"
	fi

	econf \
		$(use_enable nls) \
		$(use_with blas) \
		$(use_with jpeg jpeglib) \
		$(use_with png libpng) \
		$(use_with readline) \
		$(use_with X x) \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		rhome=${D}/usr/$(get_libdir)/R \
		install || die "Installation Failed"

	#fix the R wrapper script to have the correct R_HOME_DIR
	#sed regexp borrowed from included debian rules
	sed \
		-e "/^R_HOME_DIR=.*/s::R_HOME_DIR=/usr/$(get_libdir)/R:" \
		-i ${D}/usr/$(get_libdir)/R/bin/R \
		|| die "sed failed"

	#same for R_SHARE_DIR, R_INCLUDE_DIR and R_DOC_DIR

	sed \
		 -e "/^R_SHARE_DIR=.*/s::R_SHARE_DIR=/usr/$(get_libdir)/R/share:" \
		-i ${D}/usr/$(get_libdir)/R/bin/R \
		|| die "sed failed"

	sed \
		-e "/^R_INCLUDE_DIR=.*/s::R_INCLUDE_DIR=/usr/$(get_libdir)/R/include:" \
		-i ${D}/usr/$(get_libdir)/R/bin/R \
		|| die "sed failed"

	sed \
		-e "/^R_DOC_DIR=.*/s::R_DOC_DIR=/usr/$(get_libdir)/R/doc:" \
		-i ${D}/usr/$(get_libdir)/R/bin/R \
		|| die "sed failed"


	#R installs two identical wrappers under /usr/bin and /usr/lib/R/bin/
	#the 2nd one is corrected by above sed, for the 1st
	#I'll just symlink it into /usr/bin
	cd ${D}/usr/bin/
	rm R
	dosym ../$(get_libdir)/R/bin/R /usr/bin/R
	dodir /etc/env.d
	echo > ${D}/etc/env.d/99R "LDPATH=/usr/$(get_libdir)/R/lib"
	cd ${S}

	dodoc AUTHORS BUGS COPYING* ChangeLog FAQ *NEWS README \
		RESOURCES THANKS VERSION Y2K
}
