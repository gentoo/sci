# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_11 )
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Neuroimaging tools for Python"
HOMEPAGE="https://nipy.org/"
SRC_URI="https://github.com/nipy/nipy/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Test data unavailable:
# https://github.com/nipy/nipy/issues/561#event-11866547632
RESTRICT="test"

RDEPEND="
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	"
DEPEND=""

distutils_enable_tests pytest

python_test() {
	rm -rf nipy || die
	epytest
}
