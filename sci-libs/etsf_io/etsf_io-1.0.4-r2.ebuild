# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2

DESCRIPTION="A library of F90 routines to read/write the ETSF file format"
HOMEPAGE="https://github.com/ElectronicStructureLibrary/libetsf_io"
SRC_URI="https://launchpad.net/etsf-io/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples pic"
RESTRICT="test"

RDEPEND="
	sci-libs/netcdf-fortran
	virtual/fortran"
DEPEND="${RDEPEND}"

FORTRAN_STANDARD="90"

src_configure() {
	# fortran 90 uses FCFLAGS
	export FCFLAGS="${FFLAGS:--O2}"
	use pic && export FCFLAGS="-fPIC ${FCFLAGS}"
	econf \
		$(use_enable examples build-tutorials) \
		--prefix="${EPREFIX}/usr" \
		--with-moduledir="${EPREFIX}/usr/include"
}
