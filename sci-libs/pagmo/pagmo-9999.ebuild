# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Parallelization engine for optimization problems"
HOMEPAGE="https://github.com/esa/pagmo"
SRC_URI=""
EGIT_REPO_URI="https://github.com/esa/${PN}.git git://github.com/esa/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gsl kepler mpi nlopt python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost[mpi?]
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[${PYTHON_USEDEP}]
		)
	nlopt? ( sci-libs/nlopt )
	gsl? ( sci-libs/gsl )"
DEPEND="${RDEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		-DENABLE_SNOPT=OFF
		-DBUILD_MAIN=OFF
		$(cmake-utils_use_build python PYGMO)
		$(cmake-utils_use_enable gsl GSL)
		$(cmake-utils_use_enable kepler KEPLERIAN_TOOLBOX)
		$(cmake-utils_use_enable mpi MPI)
		$(cmake-utils_use_enable nlopt NLOPT)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}
