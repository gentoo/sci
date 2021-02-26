# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit cmake python-any-r1

DESCRIPTION="BLAS/LAPACK wrapper library for runtime switching of backends"
HOMEPAGE="https://www.mpi-magdeburg.mpg.de/projects/flexiblas"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpimd-csc/flexiblas"
else
	SRC_URI="https://github.com/mpimd-csc/flexiblas/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3 MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( ${PYTHON_DEPS} )
"

src_configure() {
	local mycmakeargs=(
		-DTESTS=$(usex test)
		-DEXAMPLES=OFF
		-DCBLAS=ON
		-DLAPACK=ON
		-DBLAS_AUTO_DETECT=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dosym libflexiblas.so "/usr/$(get_libdir)/libblas.so"
	dosym libflexiblas.so "/usr/$(get_libdir)/libcblas.so"
	dosym libflexiblas.so "/usr/$(get_libdir)/liblapack.so"
}
