# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_STANDARD=90
PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake fortran-2 git-r3 python-any-r1 multilib

DESCRIPTION="An experimental suite of programs for linear scaling quantum chemistry"
HOMEPAGE="https://www.freeon.org"
EGIT_REPO_URI="https://github.com/FreeON/freeon.git"
EGIT_BRANCH="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	sci-libs/hdf5
	virtual/blas
	virtual/lapack
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"
