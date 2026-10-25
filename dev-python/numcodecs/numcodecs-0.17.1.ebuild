# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# pyzstd does not support Python 3.15 in ::gentoo yet
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1 pypi

DESCRIPTION="Data storage buffer compression and transformation codecs"
HOMEPAGE="https://github.com/zarr-developers/numcodecs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/c-blosc:=[lz4,zlib,zstd]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-1.6.0
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	virtual/pkgconfig
	test? (
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/pyzstd[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

DISTUTILS_ARGS=(
	-Dsystem_blosc=enabled
	-Dsystem_lz4=enabled
	-Dsystem_zstd=enabled
)

python_test() {
	# gentoo blosc provides unexpected Snappy results
	EPYTEST_DESELECT=( tests/test_blosc.py::test_compress_complib )
	# Same as upstream minus the cov tests
	epytest -o addopts='--strict-config --strict-markers --doctest-modules --doctest-glob=*.pyx'
}
