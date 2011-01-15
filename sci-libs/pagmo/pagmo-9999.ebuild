# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit cmake-utils git

DESCRIPTION="Parallelization engine for optimization problems"
HOMEPAGE="http://pagmo.sourceforge.net/"
EGIT_REPO_URI="git://pagmo.git.sourceforge.net/gitroot/pagmo/pagmo"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
IUSE="gsl kepler mpi nlopt python test"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/boost[mpi?,python?]
	gsl? ( sci-libs/gsl )
	nlopt? ( sci-libs/nlopt )"
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
