# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="a general purpose molecular dynamics simulation package"
HOMEPAGE="http://www.ccp5.ac.uk/DL_POLY/"
SRC_URI="https://gitlab.com/ccp5/dl-poly/-/archive/${PV}/${P}.tar.gz"

LICENSE="STFC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/mpi[fortran]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P//_/-}-f8aaa10e91f07107c6cc2a0501a7c5064ec598d6"
