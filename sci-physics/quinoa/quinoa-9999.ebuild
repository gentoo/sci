# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Adaptive computational fluid dynamics"
HOMEPAGE="http://quinoacomputing.org/"
EGIT_REPO_URI="git://github.com/quinoacomputing/${PN}.git https://github.com/quinoacomputing/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND=">=sci-libs/trilinos-12.10.1[netcdf]
	sci-libs/h5part
	>=sys-cluster/charm-6.7.1[mpi]
	dev-libs/boost
	dev-libs/boost-mpl-cartesian_product
	dev-libs/tut
	dev-libs/pugixml
	dev-cpp/pstreams
	sci-libs/hypre[mpi]
	<dev-libs/pegtl-2
	dev-cpp/random123
	virtual/lapacke
	dev-util/mad-numdiff"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src"
