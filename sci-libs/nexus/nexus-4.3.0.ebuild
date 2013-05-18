# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fortran-2 java-pkg-opt-2

DESCRIPTION="Data format for neutron and x-ray scattering data"
HOMEPAGE="http://nexusformat.org/"
SRC_URI="http://download.nexusformat.org/kits/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"

SLOT="0"

KEYWORDS="~amd64"

IUSE="xml doc fortran swig cbflib guile tcl java python"

FORTRAN_NEEDED=fortran

RDEPEND="sci-libs/hdf5
xml? ( dev-libs/minixml )
cbflib? ( sci-libs/cbflib )
guile? ( dev-scheme/guile )
python? ( dev-lang/python )"

DEPEND="${RDEPEND}
doc? ( app-doc/doxygen dev-tex/xcolor )
swig? ( dev-lang/swig )"
# N.B. the website says it depends on HDF4 too, but I find it builds fine without it

src_configure() {
	econf $(use_with doc doxygen) $(use_with fortran f90) $(use_with swig) $(use_with xml) $(use_with cbflib) $(use_with guile) $(use_with java) $(use_with python)
}

src_compile() {
	if use fortran
	then # Handling of dependencies between Fortran module files doesn't play well with parallel make
		emake -j1
	else
		emake
	fi
}
