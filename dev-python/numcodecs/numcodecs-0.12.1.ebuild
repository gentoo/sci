# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Data storage buffer compression and transformation codecs"
HOMEPAGE="https://github.com/zarr-developers/numcodecs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	dev-python/hdmf-zarr[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/py-cpuinfo[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/entrypoints[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	cd "${T}" || die
	epytest --pyargs numcodecs
}
