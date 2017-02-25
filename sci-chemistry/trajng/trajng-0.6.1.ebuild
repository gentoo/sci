# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="TrajNG - Trajectory compression library"
HOMEPAGE="http://www.uppmax.uu.se/Members/daniels/trajng-trajectory-compression-library"
SRC_URI="http://www.uppmax.uu.se/Members/daniels/trajng-trajectory-compression-library/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux"
IUSE="fortran mpi"

DEPEND="
	sci-libs/xdrfile
	fortran? ( virtual/fortran )
	mpi? ( virtual/mpi )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-xdrlib="${EPREFIX}/usr" \
		$(use_enable fortran) \
		$(use_enable mpi)
}
