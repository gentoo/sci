# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1

FORTRAN_STANDARD=90

inherit autotools-utils fortran-2 git-2

DESCRIPTION="an experimental suite of programs for linear scaling quantum chemistry."
HOMEPAGE="http://www.freeon.org"
SRC_URI=""

EGIT_REPO_URI="http://git.savannah.gnu.org/r/freeon.git"
EGIT_BOOTSTRAP="fix_localversion.sh"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
	sci-libs/hdf5
	virtual/blas
	virtual/lapack"
DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Prevent the obsolete internal hdf5 breaking autoconf
	epatch "${FILESDIR}"/"${P}"-no_internal_hdf5.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-internal-hdf5
		--disable-static-binaries
		--disable-internal-lapack
		--with-lapacklibs="$($(tc-getPKG_CONFIG) --libs lapack)"
	)
	#TODO mv BasisSets from /usr to /usr/share/freeon/
	autotools-utils_src_configure
}
