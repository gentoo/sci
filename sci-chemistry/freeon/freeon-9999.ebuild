# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils fortran-2 git-2

DESCRIPTION="an experimental suite of programs for linear scaling quantum chemistry."
HOMEPAGE="http://www.freeon.org"

EGIT_REPO_URI="http://git.savannah.gnu.org/r/freeon.git"
EGIT_BOOTSTRAP="fix_localversion.sh"

AUTOTOOLS_AUTORECONF=1

FORTRAN_STANDARD=90

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	sys-libs/zlib
	sci-libs/hdf5
	virtual/fortran
	virtual/lapack"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--disable-internal-hdf5
		--disable-static-binaries
		--disable-internal-lapack
	)
	#TODO mv BasisSets from /usr to /usr/share/freeon/
	autotools-utils_src_configure
}
