# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
FORTRAN_STANDARD=90
PYTHON_COMPAT=( python{2_7,3_4} )

inherit autotools-utils fortran-2 git-r3 python-any-r1

DESCRIPTION="An experimental suite of programs for linear scaling quantum chemistry"
HOMEPAGE="http://www.freeon.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/FreeON/freeon.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="live"
KEYWORDS=""
IUSE=""

RDEPEND="
	sci-libs/hdf5
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_prepare() {
	bash fix_localversion.sh || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		"--enable-git-tag"
		"--prefix=/opt/freeon"
		"--mandir=/opt/freeon/share/man"
		"--infodir=/opt/freeon/share/info"
		"--datadir=/opt/freeon/share"
		"--sysconfdir=/opt/freeon/etc"
		"--libdir=/opt/freeon/lib64"
		"--docdir=/opt/freeon/share/doc"
	)
	autotools-utils_src_configure
}
