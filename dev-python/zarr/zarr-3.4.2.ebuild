# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{13..14} )

inherit distutils-r1

DESCRIPTION="Chunked, compressed, N-dimensional arrays for Python"
HOMEPAGE="https://zarr.readthedocs.io/"
SRC_URI="https://github.com/zarr-developers/zarr-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/zarr-python-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/google-crc32c-1.5[${PYTHON_USEDEP}]
	>=dev-python/donfig-0.8[${PYTHON_USEDEP}]
	>=dev-python/msgspec-0.19[${PYTHON_USEDEP}]
	>=dev-python/numcodecs-0.16.6[${PYTHON_USEDEP}]
	>=dev-python/numpy-2[${PYTHON_USEDEP}]
	>=dev-python/packaging-22[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/tomlkit[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires pytest-benchmark and runs very slow benchmarks
		tests/benchmarks
		# network
		tests/test_store/test_core.py::test_make_store_path_fsspec
		# uv downloads/installs
		tests/test_examples.py::test_scripts_can_run
		tests/test_regression/test_v2_dtype_regression.py
	)
	epytest -o addopts= tests
}
