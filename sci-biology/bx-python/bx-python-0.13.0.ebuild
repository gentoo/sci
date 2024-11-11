# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Library for rapid implementation of genome scale analyses"
HOMEPAGE="https://github.com/bxlab/bx-python"
SRC_URI="https://github.com/bxlab/bx-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( dev-python/python-lzo[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="dev-python/cython[${PYTHON_USEDEP}]"

# doctests have external deps
PATCHES=(
	"${FILESDIR}/no-doctest.patch"
)

distutils_enable_tests pytest

# https://github.com/bxlab/bx-python/issues/101
python_test() {
	cd "${BUILD_DIR}/build" || die
	ln -s "${S}/pytest.ini" . || die
	ln -s "${S}/test_data" . || die
	epytest
}
