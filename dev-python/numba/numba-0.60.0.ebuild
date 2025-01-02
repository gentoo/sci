# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DISTUTILS_EXT=1

DESCRIPTION="NumPy aware dynamic Python compiler using LLVM"
HOMEPAGE="https://numba.pydata.org/"
SRC_URI="https://github.com/numba/numba/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-python/llvmlite"
DEPEND="${RDEPEND}"

RESTRICT="test" # "from numba.core.typeconv import _typeconv" fails but works after install
distutils_enable_tests pytest
