# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 llvm

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="https://llvmlite.pydata.org/"
SRC_URI="https://github.com/numba/llvmlite/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples debug"

DISTUTILS_EXT=1
LLVM_MAX_SLOT=15

RDEPEND="
	sys-devel/llvm:${LLVM_MAX_SLOT}
	sys-libs/zlib:0=
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

python_test() {
	LD_LIBRARY_PATH="${EPREFIX}/usr/lib/llvm/${LLVM_MAX_SLOT}/lib64" \
		"${EPYTHON}" runtests.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	dosym "${EPREFIX}/usr/lib/llvm/${LLVM_MAX_SLOT}/lib64/libLLVM-${LLVM_MAX_SLOT}.so" \
		/usr/lib/$EPYTHON/site-packages/llvmlite/binding/libLLVM-${LLVM_MAX_SLOT}.so
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
