# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_CONFIG_NAME="DoxyConfig"

inherit cmake docs multilib

MYPN=SuperLU_DIST

DESCRIPTION="MPI distributed sparse LU factorization library"
HOMEPAGE="https://portal.nersc.gov/project/sparse/superlu/ https://github.com/xiaoyeli/superlu_dist"
SRC_URI="https://github.com/xiaoyeli/superlu_dist/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/parmetis[mpi(-)]
	virtual/mpi"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DTPL_PARMETIS_LIBRARIES="/usr/$(get_libdir)/libmetis.so"
		-DTPL_PARMETIS_INCLUDE_DIRS="/usr/include/"
		-Denable_examples=$(usex examples ON OFF)
		-Denable_tests=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	default
}
