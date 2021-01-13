# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_CONFIG_NAME="${PN}.doxy"

inherit cmake docs git-r3

DESCRIPTION="Adaptive computational fluid dynamics"
HOMEPAGE="https://quinoacomputing.org/"
EGIT_REPO_URI="git://github.com/quinoacomputing/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-cpp/highwayhash
	dev-cpp/pstreams
	dev-cpp/random123
	dev-libs/boost
	dev-libs/boost-mpl-cartesian_product
	>=dev-libs/pegtl-2
	dev-libs/pugixml
	dev-libs/tut
	dev-util/mad-numdiff
	sci-libs/gmsh
	sci-libs/h5part
	sci-libs/hypre[mpi]
	sci-libs/mkl
	>=sci-libs/trilinos-12.10.1[netcdf]
	>=sys-cluster/charm-6.7.1[mpi]
	virtual/lapacke
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src"

src_compile() {
	docs_compile
	cmake_src_compile
}
