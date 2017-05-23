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
KEYWORDS="" # the install step is broken (python modules integration, upstream binary code)
IUSE=""

DEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	sci-libs/hdf5"
# TODO: more deps
# https://github.com/mateidavid/tclap.git
# https://github.com/mateidavid/hpptools.git
RDEPEND="${DEPEND}"

src_compile(){
	emake -C python develop-user
}

src_install(){
	dobin src/hufftk
	insinto /usr/include
	doins src/*.hpp
	dobin python/bin/* # bindled binaries
	dolib python/fast5.so # bundled library
}

python_install_all() {
	cd python || die
	distutils-r1_src_install_all
}
