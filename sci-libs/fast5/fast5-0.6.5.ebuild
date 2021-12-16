# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DOCS_BUILDER="doxygen"
DOCS_DIR="${WORKDIR}/${P}"

inherit distutils-r1 docs

DESCRIPTION="C++ header-only library for reading Oxford Nanopore Fast5 files"
HOMEPAGE="https://github.com/mateidavid/fast5"
SRC_URI="https://github.com/mateidavid/fast5/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sci-libs/hdf5
	dev-python/cython[${PYTHON_USEDEP}]"

S="${WORKDIR}/${P}/python"

python_compile() {
	HDF5_DIR="${EPREFIX}"/usr HDF5_LIB_DIR="${EPREFIX}"/usr/$(get_libdir) distutils-r1_python_compile
}

python_compile_all(){
	docs_compile
}

python_install() {
	HDF5_DIR="${EPREFIX}"/usr HDF5_LIB_DIR="${EPREFIX}"/usr/$(get_libdir) distutils-r1_python_install
}
