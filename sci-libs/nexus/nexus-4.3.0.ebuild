# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Data format for neutron and x-ray scattering data"

HOMEPAGE="http://nexusformat.org/"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="http://download.nexusformat.org/kits/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"

SLOT="0"

KEYWORDS="~amd64"

IUSE="xml doc fortran swig cbflib guile tcl java python"

DEPEND="sci-libs/hdf5
xml? ( dev-libs/minixml ) 
doc? ( app-doc/doxygen dev-tex/xcolor )
swig? ( dev-lang/swig )
fortran? ( virtual/fortran )
cbflib? ( sci-libs/cbflib )
guile? ( dev-scheme/guile )
tcl? ( dev-lang/tcl )
java? ( virtual/jdk )
python? ( dev-lang/python )"

RDEPEND="sci-libs/hdf5
xml? ( dev-libs/minixml )
cbflib? ( sci-libs/cbflib )
guile? ( dev-scheme/guile ) 
java? ( virtual/jre )
python? ( dev-lang/python )"

src_configure() {
	econf $(use_with doc doxygen) $(use_with fortran f90) $(use_with swig) $(use_with xml) $(use_with cbflib) $(use_with guile) $(use_with java) $(use_with python)
}

