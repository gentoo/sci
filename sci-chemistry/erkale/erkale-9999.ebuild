# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic git-r3 multibuild toolchain-funcs

DESCRIPTION="Quantum chemistry program for atoms and molecules"
HOMEPAGE="https://code.google.com/p/erkale/"
EGIT_REPO_URI="https://github.com/susilehtola/erkale.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="openmp"

RDEPEND="
	sci-libs/gsl
	sci-libs/hdf5
	sci-libs/libint:1
	>=sci-libs/libxc-4.2.0
"
DEPEND="
	>=sci-libs/armadillo-4[blas,lapack]
	virtual/pkgconfig
	${RDEPEND}
"

MULTIBUILD_VARIANTS=( serial )

CMAKE_REMOVE_MODULES_LIST="FindBLAS FindLAPACK FindGSL"

src_prepare() {
	use openmp && MULTIBUILD_VARIANTS+=( omp )
	append-cxxflags "-DARMA_DONT_USE_ATLAS -DARMA_DONT_USE_WRAPPER"
	cmake-utils_src_prepare
}

src_configure() {
	my_configure() {
		local OMP=OFF && [[ ${MULTIBUILD_VARIANT} == "omp" ]] && OMP=ON
		local basis="${EROOT}/usr/share/${PN}/basis"
		local mycmakeargs=(
			-DUSE_OPENMP=${OMP}
			-DBUILD_SHARED_LIBS=ON
			-DERKALE_SYSTEM_LIBRARY="${basis/\/\///}"
			-DLAPACK_INCLUDE_DIRS="$($(tc-getPKG_CONFIG) blas lapack --cflags-only-I | sed 's/-I//g')"
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) blas lapack --libs)"
		)
		cmake-utils_src_configure
	}
	multibuild_foreach_variant my_configure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r "${S}/basis"

	multibuild_foreach_variant cmake-utils_src_install
}
