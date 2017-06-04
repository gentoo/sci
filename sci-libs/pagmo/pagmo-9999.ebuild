# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Parallelization engine for optimization problems"
HOMEPAGE="https://github.com/esa/pagmo"
SRC_URI=""
EGIT_REPO_URI="https://github.com/esa/${PN}2.git git://github.com/esa/${PN}2.git"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS=""
IUSE="eigen nlopt ipopt python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost
	eigen? ( dev-cpp/eigen:3 )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[${PYTHON_USEDEP}]
		)
	nlopt? ( sci-libs/nlopt )
	ipopt? ( sci-libs/ipopt )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		-DPAGMO_BUILD_PYGMO=$(usex python)
		-DPAGMO_WITH_EIGEN3=$(usex eigen)
		-DPAGMO_WITH_NLOPT=$(usex nlopt)
		-DPAGMO_WITH_IPOPT=$(usex ipopt)
		-DPAGMO_BUILD_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}
