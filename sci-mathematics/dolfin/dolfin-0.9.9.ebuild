# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="python? 2"

inherit cmake-utils eutils python

DESCRIPTION="C++/Python interface of FEniCS"
HOMEPAGE="https://launchpad.net/dolfin/"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cgal cholmod gmp mpi parmetis python scotch umfpack zlib"
# scotch and parmetis require mpi; wait for EAPI 4

DEPEND="
	dev-libs/boost
	dev-libs/libxml2:2
	sci-libs/armadillo
	sci-mathematics/ufc
	python? (
		dev-python/ufl
		dev-python/ffc
		dev-python/fiat
		dev-python/instant
		dev-python/viper )"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-find-armadillo.patch
}

pkg_setup() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use cgal DOLFIN_ENABLE_CGAL)
		$(cmake-utils_use cholmod DOLFIN_ENABLE_CHOLMOD)
		$(cmake-utils_use gmp DOLFIN_ENABLE_GMP)
		$(cmake-utils_use mpi DOLFIN_ENABLE_MPI)
		$(cmake-utils_use parmetis DOLFIN_ENABLE_PARMETIS)
		$(cmake-utils_use python DOLFIN_ENABLE_PYTHON)
		$(cmake-utils_use scotch DOLFIN_ENABLE_SCOTCH)
		$(cmake-utils_use umfpack DOLFIN_ENABLE_UMFPACK)
		$(cmake-utils_use zlib DOLFIN_ENABLE_ZLIB)"
}
