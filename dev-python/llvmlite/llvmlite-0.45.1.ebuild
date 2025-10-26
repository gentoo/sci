# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
LLVM_COMPAT=( 20 )
inherit distutils-r1 llvm-r1

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="https://github.com/numba/llvmlite"
SRC_URI="https://github.com/numba/llvmlite/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-build/cmake"
RDEPEND="
	sys-libs/zlib:0=
	$(llvm_gen_dep 'llvm-core/llvm:${LLVM_SLOT}=')
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_compile() {
	LLVMLITE_SHARED=ON LLVM_CONFIG="$(get_llvm_prefix)/bin/llvm-config" distutils-r1_python_compile
}

python_test() {
	LD_LIBRARY_PATH="$(get_llvm_prefix)/$(get_libdir)" \
		"${EPYTHON}" runtests.py -v || die "tests failed for ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install
	# numba compilation fails without this link
	ln -s "$(get_llvm_prefix)/$(get_libdir)/libLLVM-${LLVM_SLOT}.so" \
		"${D}/$(python_get_sitedir)/llvmlite/binding/libLLVM-${LLVM_SLOT}.so" || die
}
