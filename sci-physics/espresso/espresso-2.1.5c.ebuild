# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools savedconfig

DESCRIPTION="Extensible Simulation Package for Research on Soft matter"
HOMEPAGE="http://www.espresso.mpg.de"
SRC_URI="http://espressowiki.mpip-mainz.mpg.de/wiki/uploads/e/e6/Espresso-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X doc examples fftw mpi packages test -tk"

RDEPEND="dev-lang/tcl
	X? ( x11-libs/libX11 )
	fftw? ( sci-libs/fftw:3.0 )
	mpi? ( virtual/mpi )
	tk? ( >=dev-lang/tk-8.4.18-r1 )"

DEPEND="${DEPEND}
	doc? ( app-doc/doxygen
		virtual/latex-base )"

S="${WORKDIR}/${PN}-${PV:0:5}"

src_prepare() {
	AT_M4DIR="config" eautoreconf
	restore_config myconfig.h
}

src_configure() {
	econf \
		$(use_with fftw) \
		$(use_with mpi) \
		$(use_with tk) \
		$(use_with X x)
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "Installing failed"

	dodoc INSTALL README RELEASE_NOTES

	insinto /usr/share/${PN}
	doins myconfig-sample.h

	if [ -f myconfig.h ]; then
		save_config myconfig.h
	else
		save_config config/myconfig.h
	fi

	if use doc; then
		newdoc doc/ug/ug.pdf user_guide.pdf
		dohtml -r doc/dg/html/*
		newdoc doc/tutorials/tut2/tut2.pdf tutorial.pdf
	fi

	if use examples; then
		insinto /usr/share/${PN}/examples
		doins samples/*
		#the testsuite are also good examples
		rm testsuite/Makefile* testsuite/test.sh.in
		insinto /usr/share/${PN}/testsuite
		doins testsuite/*
	fi

	if use packages; then
		insinto /usr/share/${PN}/packages
		doins -r packages/*
	fi
}

pkg_postinst() {
	elog
	elog Please read and cite:
	elog ESPResSo, Comput. Phys. Commun. 174\(9\) ,704, 2006.
	elog http://dx.doi.org/10.1016/j.cpc.2005.10.005
	elog
	elog If you need more features, change
	elog /etc/portage/savedconfig/${CATEGORY}/"${PF}"
	elog and reemerge with USE=savedconfig
	elog
	elog "For a full feature list see:"
	elog "/usr/share/${PN}/myconfig-sample.h"
	elog
}
