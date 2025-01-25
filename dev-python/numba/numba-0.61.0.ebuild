# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="https://numba.pydata.org/"
SRC_URI="https://github.com/numba/numba/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
    dev-python/llvmlite[$PYTHON_USEDEP]
    <=dev-python/numpy-2.1[$PYTHON_USEDEP]
"
DEPEND="${RDEPEND}"

RESTRICT="test" # tests need to be run from "${BUILD_DIR}/build/lib.linux-x86_64-cpython-312"
distutils_enable_tests pytest
