# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
FORTRAN_STANDARD=90

inherit autotools-utils fortran-2 git-2

DESCRIPTION="An experimental suite of programs for linear scaling quantum chemistry."
HOMEPAGE="http://www.freeon.org"
SRC_URI=""

EGIT_REPO_URI="https://github.com/FreeON/freeon.git"
EGIT_BOOTSTRAP="fix_localversion.sh"

LICENSE="GPL-3"
SLOT="live"
KEYWORDS="~amd64 ~x86"
IUSE="standalone-BCSR static-libs"

RDEPEND="
	sci-libs/hdf5
	virtual/blas
	virtual/lapack"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable standalone-BCSR)
	)
	autotools-utils_src_configure
}
