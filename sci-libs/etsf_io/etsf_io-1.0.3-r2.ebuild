# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit fortran-2 multilib

DESCRIPTION="A library of F90 routines to read/write the ETSF file format"
HOMEPAGE="http://www.etsf.eu/resources/software/libraries_and_tools/"
SRC_URI="http://www.etsf.eu/sites/default/files/${P}.tar.gz -> ${P}.tar"

LICENSE="LGPL-2"
SLOT="0"
IUSE="examples"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| (
		sci-libs/netcdf[fortran]
		sci-libs/netcdf-fortran
	)
	virtual/fortran"
DEPEND="${RDEPEND}"

FORTRAN_STANDARD="90"

src_configure() {
	# fortran 90 uses FCFLAGS
	export FCFLAGS="${FFLAGS:--O2}"
	econf \
		$(use_enable examples build-tutorials) \
		--prefix="${EPREFIX}/usr" \
		--with-netcdf-ldflags="-L${EPREFIX}/usr/$(get_libdir) -lnetcdff" \
		--with-moduledir="${EPREFIX}/usr/include"
}
