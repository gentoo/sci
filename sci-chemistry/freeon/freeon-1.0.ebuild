# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1

FORTRAN_STANDARD=90

inherit autotools-utils fortran-2

DESCRIPTION="An experimental suite of programs for linear scaling quantum chemistry."
HOMEPAGE="http://www.freeon.org"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${PN}-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	sci-libs/hdf5
	virtual/blas
	virtual/lapack"
DEPEND="${DEPEND}
	virtual/pkgconfig"
