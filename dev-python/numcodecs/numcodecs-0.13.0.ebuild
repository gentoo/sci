# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi flag-o-matic

DESCRIPTION="Data storage buffer compression and transformation codecs"
HOMEPAGE="https://github.com/zarr-developers/numcodecs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/py-cpuinfo[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/entrypoints[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# python segfault
	tests/test_blosc.py::test_encode_decode
	tests/test_blosc.py::test_partial_decode
	tests/test_blosc.py::test_compress_metainfo
	tests/test_blosc.py::test_compress_autoshuffle
	tests/test_blosc.py::test_multiprocessing
	tests/test_blosc.py::test_backwards_compatibility
	tests/test_blosc.py::test_max_buffer_size
)

distutils_enable_tests pytest

python_prepare_all() {
	filter-lto
	distutils-r1_python_prepare_all
}
