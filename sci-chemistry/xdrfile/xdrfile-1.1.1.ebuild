# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_NEEDED="fortran"

inherit fortran-2

DESCRIPTION="Library to read xtc gromacs trajectory"
HOMEPAGE="http://www.gromacs.org/Developer_Zone/Programming_Guide/XTC_Library"
SRC_URI="ftp://ftp.gromacs.org/pub/contrib/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="fortran"

src_configure() {
	econf \
		$(use_enable fortran)
}
