# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="Library for blasr"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
EGIT_REPO_URI="https://github.com/PacificBiosciences/blasr_libcpp.git"
#SRC_URI="https://github.com/PacificBiosciences/blasr_libcpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="blasr"
SLOT="0"
KEYWORDS=""

BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"
DEPEND="
	sci-libs/hdf5[cxx]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/blasr_libcpp-${PV}"
