# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2

DESCRIPTION="CCP4 ccif lib"
HOMEPAGE="https://www.ccp4.ac.uk/"
SRC_URI="ftp://ftp.ccp4.ac.uk/opensource/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-3"

RDEPEND="virtual/fortran"
DEPEND="${RDEPEND}"
