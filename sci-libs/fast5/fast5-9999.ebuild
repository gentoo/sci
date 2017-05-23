# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="C++ header-only library for reading Oxford Nanopore Fast5 files"
HOMEPAGE="https://github.com/mateidavid/fast5"
EGIT_REPO_URI="https://github.com/mateidavid/fast5.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	sci-libs/hdf5"
RDEPEND="${DEPEND}"

src_compile(){
	emake -C python develop-user
}
