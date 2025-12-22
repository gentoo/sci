# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

DESCRIPTION="Chunked, compressed, N-dimensional arrays for Python"
HOMEPAGE=https://zarr.readthedocs.io/
SRC_URI="https://github.com/zarr-developers/zarr-python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

S="${WORKDIR}/zarr-python-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/crc32c[${PYTHON_USEDEP}]
	dev-python/donfig[${PYTHON_USEDEP}]
	>=dev-python/numcodecs-0.14[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.25[${PYTHON_USEDEP}]
	dev-python/typing-extensions
"
DEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
# sphinx ebuilds not compatible with py3.13
#distutils_enable_sphinx docs dev-python/numpydoc dev-python/sphinx-issues \
#	dev-python/sphinx-autoapi dev-python/sphinx_copybutton dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	# network access + missing package ebuild
	tests/test_store/test_core.py::test_make_store_path_fsspec
)
