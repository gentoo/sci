# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WX_GTK_VER="2.6"

inherit eutils fortran wxwidgets

DESCRIPTION="Scalable Performance Analysis of Large-Scale Applications"
HOMEPAGE="http://www.fz-juelich.de/jsc/scalasca/"
SRC_URI="http://www.fz-juelich.de/jsc/datapool/scalasca/${P}.tar.gz"

LICENSE="scalasca"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc examples fortran mpi openmp wxwindows"

DEPEND="mpi? ( virtual/mpi )
	x11-libs/qt-core:4
	wxwindows? ( x11-libs/wxGTK:2.6 )"

RDEPEND="${DEPEND}"

FORTRAN="g77 gfortran ifc"

pkg_setup() {
	use fortran && fortran_pkg_setup
	use wxwindows && wxwidgets_pkg_setup
}

src_prepare() {
	#rename szlib headers to avoid complication with zlib
	for file in zlib.h zconf.h; do
		find . -type f -exec grep -qH ${file} {} \; -a \
			-exec sed -i "s/${file}/s${file}/g" {} \;
		find . -type f -name ${file} -execdir mv {} s${file} \;
	done

	sed -e "s:CFLAGS   =.*:CFLAGS   = ${CFLAGS}:" \
	    -e "s:CXXFLAGS =.*:CXXFLAGS = ${CXXFLAGS}:" \
		-i mf/Makefile.defs.linux-gomp mf/Makefile.defs.linux-gnu \
		|| die "sed CFLAGS,CXXFLAGS failed"

	epatch "${FILESDIR}"/scalasca-1.1-installdirs.patch
}

src_configure() {
	local myconf

	if use openmp; then
		myconf="${myconf} --compiler=gomp"
	else
		myconf="${myconf} --compiler=gnu --disable-omp"
	fi

	use mpi || myconf="${myconf} --disable-mpi"

	./configure --prefix=/usr ${myconf} || die "configure failed"
}

src_compile() {
	cd build-*
	#multi job build is broken
	emake -j1 || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "Installing failed"
}

