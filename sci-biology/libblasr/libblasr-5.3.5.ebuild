# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Library for blasr"
HOMEPAGE="http://www.smrtcommunity.com/SMRT-Analysis/Algorithms/BLASR"
SRC_URI="https://github.com/PacificBiosciences/blasr_libcpp/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/blasr_libcpp-${PV}"

LICENSE="blasr"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"
DEPEND="
	sci-biology/pbbam
	sci-libs/hdf5[cxx]
"
RDEPEND="${DEPEND}"
