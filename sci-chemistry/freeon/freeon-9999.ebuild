# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
FORTRAN_STANDARD=90
PYTHON_COMPAT=( python{2_6,2_7,3_1,3_2} )

inherit autotools-utils fortran-2 git-2 python-any-r1

DESCRIPTION="An experimental suite of programs for linear scaling quantum chemistry."
HOMEPAGE="http://www.freeon.org"
SRC_URI=""

EGIT_REPO_URI="https://github.com/FreeON/freeon.git"
EGIT_BOOTSTRAP="fix_localversion.sh"

LICENSE="GPL-3"
SLOT="live"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/hdf5
	virtual/blas
	virtual/lapack"
DEPEND="${DEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		"--enable-git-tag"
	)
	autotools-utils_src_configure
}
