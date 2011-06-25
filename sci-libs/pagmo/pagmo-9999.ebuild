# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Parallelization engine for optimization problems"
HOMEPAGE="http://pagmo.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="git://pagmo.git.sourceforge.net/gitroot/pagmo/pagmo"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gsl kepler mpi nlopt python test"

RDEPEND="
	dev-libs/boost[mpi?,python?]
	nlopt? ( sci-libs/nlopt )
	gsl? ( sci-libs/gsl )"
DEPEND="${RDEPEND}"

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
