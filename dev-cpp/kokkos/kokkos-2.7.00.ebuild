# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs

DESCRIPTION="Kokkos C++ Performance Portability Programming EcoSystem"
HOMEPAGE="https://github.com/kokkos"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp +threads"
REQUIRED_USE="?? ( openmp threads )"

DEPEND="
	sys-apps/hwloc
	"
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && \
		use openmp && ! tc-has-openmp ; then
			die "Need an OpenMP capable compiler"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DKOKKOS_ENABLE_HWLOC=ON
		-DKOKKOS_HWLOC_DIR="${EPREFIX}/usr"
		-DKOKKOS_ENABLE_OPENMP=$(usex openmp)
		-DKOKKOS_ENABLE_PTHREAD=$(usex threads)
		-DKOKKOS_ENABLE_SERIAL=ON
		-DBUILD_SHARED_LIBS=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	[[ $(get_libdir) = lib ]] || mv "${ED}"/usr/{lib,"$(get_libdir)"} || die
}
