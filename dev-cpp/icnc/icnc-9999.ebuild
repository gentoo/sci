# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="Intel Concurrent Collections for C++ - Parallelism without the Pain"
HOMEPAGE="https://software.intel.com/en-us/articles/intel-concurrent-collections-for-cc"

if [[ $PV = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/icnc/icnc.git"
else
	SRC_URI="mirror://sourceforge/${PN}/${PV}/l_cnc_b_${PV}.tgz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-cpp/tbb-4.2[debug]
	sys-libs/glibc
	"
RDEPEND="${DEPEND}"

src_configure() {
#TODO has mpi support but broken with virtual/mpi
# 	local mycmakeargs=(
# 		$(cmake-utils_use mpi BUILD_LIBS_FOR_MPI)
# 	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mv "${ED}"/usr/{lib,$(get_libdir)} || die
}
