# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
LLVM_COMPAT=( 22 )

inherit cmake distutils-r1 llvm-r2 multiprocessing

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="https://github.com/numba/llvmlite"
SRC_URI="https://github.com/numba/llvmlite/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/zlib:0=
	$(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}=')
"
DEPEND="${RDEPEND}"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	LLVMLITE_SHARED=ON \
		LLVM_DIR="$(get_llvm_prefix)/$(get_libdir)/cmake/llvm" \
		CMAKE_BUILD_PARALLEL_LEVEL="$(makeopts_jobs)" \
		distutils-r1_python_compile
}

python_test() {
	LD_LIBRARY_PATH="$(get_llvm_prefix)/$(get_libdir)" \
		"${EPYTHON}" runtests.py -v || die "tests failed for ${EPYTHON}"
}
