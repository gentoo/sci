# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fortran-2

DESCRIPTION="Library to read xtc gromacs trajectory"
HOMEPAGE="http://wiki.gromacs.org/index.php/XTC_Library"
SRC_URI="ftp://ftp.gromacs.org/pub/contrib/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fortran"

DEPEND="
	fortran? ( virtual/fortran )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}b"

src_configure() {
	econf \
		$(use_enable fortran)
}
