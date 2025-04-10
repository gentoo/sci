# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Chunked, compressed, N-dimensional arrays for Python"
HOMEPAGE="https://github.com/zarr-developers/zarr-python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/asciitree[${PYTHON_USEDEP}]
	dev-python/fasteners[${PYTHON_USEDEP}]
	<dev-python/numcodecs-16[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/msgpack[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# https://github.com/zarr-developers/zarr-python/issues/1819
	zarr/tests/test_storage.py::TestFSStore::test_hierarchy
	zarr/tests/test_storage.py::TestFSStore::test_complex
	zarr/tests/test_storage.py::TestFSStoreWithKeySeparator::test_hierarchy
	zarr/tests/test_storage.py::TestFSStoreFromFilesystem::test_hierarchy
	zarr/tests/test_storage.py::TestN5FSStore::test_hierarchy
	zarr/tests/test_storage.py::TestN5FSStore::test_complex
	zarr/tests/test_storage.py::TestNestedFSStore::test_hierarchy
)

distutils_enable_tests pytest
#distutils_enable_sphinx docs dev-python/numpydoc dev-python/sphinx-issues dev-python/sphinx-rtd-theme
