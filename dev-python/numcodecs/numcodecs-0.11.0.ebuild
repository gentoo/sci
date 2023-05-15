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
# Fails to collect tests for yet unknown reasons:
# https://github.com/zarr-developers/numcodecs/issues/304
# --pyargs numcodecs fix proposed in thread doesn't seem to take effect.
RESTRICT="test"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
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

PATCHES=(
	"${FILESDIR}/${P}-nocov.patch"
)

distutils_enable_tests pytest
