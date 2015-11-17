# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90
PYTHON_COMPAT=( python2_7 )
inherit fortran-2 flag-o-matic python-single-r1

DESCRIPTION="Data format for neutron and x-ray scattering data"
HOMEPAGE="http://nexusformat.org/"
SRC_URI="http://download.nexusformat.org/kits/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cbf doc fortran guile java python swig tcl xml"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	sci-libs/hdf5
	python?	( ${PYTHON_DEPS} )
	xml? ( dev-libs/mxml )
	cbf? ( sci-libs/cbflib )
	guile? ( dev-scheme/guile:12 )
" # N.B. the website says it depends on HDF4 too, but I find it builds fine without it

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen dev-tex/xcolor )
	swig? ( dev-lang/swig:0 )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	# Handling of dependencies between Fortran module files doesn't play well with parallel make
	use fortran && export MAKEOPTS="${MAKEOPTS} -j1 "
	use fortran && fortran-2_pkg_setup
}

src_configure() {
	# Linking between Fortran libraries gives a relocation error, using workaround suggested at:
	# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3
	use fortran && append-fflags -fPIC

	econf \
		$(use_with doc doxygen) \
		$(use_with fortran f90) \
		$(use_with swig) \
		$(use_with xml) \
		$(use_with cbf cbflib) \
		$(use_with guile) \
		$(use_with java) \
		$(use_with python)
}
