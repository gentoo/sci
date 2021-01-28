# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic git-r3 multibuild toolchain-funcs

DESCRIPTION="Quantum chemistry program for atoms and molecules"
HOMEPAGE="https://github.com/susilehtola/erkale"
EGIT_REPO_URI="https://github.com/susilehtola/erkale.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="openmp"

RDEPEND="
	sci-libs/gsl
	sci-libs/hdf5
	sci-libs/libint:2
	>=sci-libs/libxc-2.0.0
"
DEPEND="
	>=sci-libs/armadillo-4[blas,lapack]
	${RDEPEND}
"
BDEPEND="virtual/pkgconfig"

MULTIBUILD_VARIANTS=( serial )

src_prepare() {
	use openmp && MULTIBUILD_VARIANTS+=( omp )
	append-cxxflags "-DARMA_DONT_USE_ATLAS -DARMA_DONT_USE_WRAPPER"
	cmake_src_prepare
	# libint has renamed things
	find -type f -name "*.h" -exec sed -i -e 's/#include <libint\/libint.h>/#include <libint2.h>/g' {} + || die
	find -type f -name "*.h" -exec sed -i -e 's/#include <libderiv\/libderiv.h>/#include <libint2\/deriv_iter.h>/g' {} + || die
}

src_configure() {
	my_configure() {
		local OMP=OFF && [[ ${MULTIBUILD_VARIANT} == "omp" ]] && OMP=ON
		local basis="${EROOT}/usr/share/${PN}/basis"
		local mycmakeargs=(
			-DUSE_OPENMP=${OMP}
			-DBUILD_SHARED_LIBS=ON
			-DERKALE_SYSTEM_LIBRARY="${basis/\/\///}"
			-DLAPACK_INCLUDE_DIRS="$($(tc-getPKG_CONFIG) lapack --cflags-only-I | sed 's/-I//')"
		)
		cmake_src_configure
	}
	multibuild_foreach_variant my_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	my_test() {
		cd "${BUILD_DIR}/src/test"
		local OMP="" && [[ ${MULTIBUILD_VARIANT} == "omp" ]] && OMP="_omp"
		ERKALE_LIBRARY="${S}/basis" ./erkale_tests${OMP} || eerror "Tests failed!"
	}
	multibuild_foreach_variant my_test
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r "${S}/basis"

	multibuild_foreach_variant cmake_src_install
}
