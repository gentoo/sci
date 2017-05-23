# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="C++ header-only library for reading Oxford Nanopore Fast5 files"
HOMEPAGE="https://github.com/mateidavid/fast5"
SRC_URI="https://github.com/mateidavid/fast5/archive/v0.6.2.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	sci-libs/hdf5"
RDEPEND="${DEPEND}"

src_compile(){
	emake -C python develop-user
}
