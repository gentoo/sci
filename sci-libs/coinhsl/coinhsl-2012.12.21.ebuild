# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=yes
FORTRAN_STANDARD="77 90"
inherit autotools-utils fortran-2

DESCRIPTION="HSL mathematical software library for IPOPT"
HOMEPAGE="http://www.hsl.rl.ac.uk/"
SRC_URI="${P}.tar.gz"

LICENSE="HSL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

RESTRICT="mirror fetch"

src_compile() {
	autotools-utils_src_compile -j1
}
