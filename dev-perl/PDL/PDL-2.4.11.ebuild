# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PDL/PDL-2.4.7.ebuild,v 1.3 2010/08/23 13:39:54 tove Exp $

EAPI=4

MODULE_AUTHOR=CHM
inherit eutils fortran-2 perl-module

HOMEPAGE="http://pdl.perl.org/"
DESCRIPTION="Perl Data Language scientific computing"

LICENSE="Artistic as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="badval doc fftw gd gsl hdf netpbm opengl pdl2 proj pgplot plplot threads"

RDEPEND="sys-libs/ncurses
	app-arch/sharutils
	dev-perl/Astro-FITS-Header
	>=dev-perl/ExtUtils-F77-1.13
	dev-perl/File-Map
	dev-perl/Inline
	dev-perl/TermReadKey
	|| ( dev-perl/Term-ReadLine-Perl dev-perl/Term-ReadLine-Gnu )
	virtual/perl-Data-Dumper
	virtual/perl-PodParser
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Filter
	virtual/perl-Storable
	virtual/perl-Text-Balanced
	fftw? ( sci-libs/fftw:2.1 )
	gd? ( media-libs/gd )
	gsl? ( sci-libs/gsl )
	hdf? ( sci-libs/hdf )
	netpbm? ( media-libs/netpbm virtual/ffmpeg )
	pdl2? ( dev-perl/Devel-REPL )
	proj? ( sci-libs/proj )
	opengl? ( dev-perl/OpenGL )
	pgplot? ( dev-perl/PGPLOT )
	plplot? ( sci-libs/plplot )"

DEPEND="${RDEPEND}
	virtual/fortran"

mydoc="BUGS DEPENDENCIES DEVELOPMENT Known_problems MANIFEST* Release_Notes"

SRC_TEST="do"

#MAKEOPTS+=" -j1"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.2-makemakerfix.patch
	# Unconditional -fPIC for the lib (#55238, #180807, #250335)
	epatch "${FILESDIR}"/${PN}-2.4.4-PIC.patch
}

src_configure() {
	pdl_use() {
		local p=${2:-WITH_${1^^}}
		if use $1; then
			echo "-e \"/${p}/s/=>.*/=> 1/\""
		else
			echo "-e \"/${p}/s/=>.*/=> 0/\""
		fi
	}
	sed -i \
		-e '/USE_POGL/s/=>.*/=> 1,/' \
		-e '/WITH_MINUIT/s/=>.*/=> 1,/' \
		-e '/WITH_SLATEC/s/=>.*/=> 1,/' \
		-e "/WITH_BADVAL/s/=>.*/=> $(use badval && echo true || echo false),/" \
		-e "/HTML_DOCS/s/=>.*/=> $(use doc && echo 1 || echo 0),/" \
		-e "/WITH_FFTW/s/=>.*/=> $(use fftw && echo true || echo false),/" \
		-e "/WITH_GSL/s/=>.*/=> $(use gsl && echo true || echo false),/" \
		-e "/WITH_GD/s/=>.*/=> $(use gd && echo true || echo false),/" \
		-e "/WITH_HDF/s/=>.*/=> $(use hdf && echo true || echo false),/" \
		-e "/WITH_3D/s/=>.*/=> $(use opengl && echo true || echo false),/" \
		-e "/WITH_PGPLOT/s/=>.*/=> $(use pgplot && echo 1 || echo 0),/" \
		-e "/WITH_PLPLOT/s/=>.*/=> $(use plplot && echo 1 || echo 0),/" \
		-e "/WITH_PROJ/s/=>.*/=> $(use proj && echo true || echo false),/" \
		-e "/WITH_DEVEL_REPL/s/=>.*/=> $(use pdl2 && echo true || echo false),/" \
		-e "/WITH_POSIX_THREADS/s/=>.*/=> $(use threads && echo true || echo 0),/" \
		perldl.conf || die
	perl-module_src_configure
}

src_install() {
	perl-module_src_install
	insinto /${VENDOR_ARCH}/PDL/Doc
	doins Doc/{scantree.pl,mkhtmldoc.pl}
}

pkg_postinst() {
	if [[ ${EROOT} = / ]] ; then
		perl ${VENDOR_ARCH}/PDL/Doc/scantree.pl
		elog "Building perldl.db done. You can recreatethis at any time"
		elog "by running"
	else
		elog "You must create perldl.db by running"
	fi
	elog "perl ${VENDOR_ARCH}/PDL/Doc/scantree.pl"
	elog "PDL requires that glx and dri support be enabled in"
	elog "your X configuration for certain parts of the graphics"
	elog "engine to work. See your X's documentation for futher"
	elog "information."
}

pkg_prerm() {
	rm -rf "${EROOT}"/var/lib/pdl/html
	rm -f  "${EROOT}"/var/lib/pdl/pdldoc.db "${EROOT}"/var/lib/pdl/Index.pod
}
