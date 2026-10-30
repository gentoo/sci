# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

inherit distutils-r1

DESCRIPTION="Flexible parallel computing library for analytics"
HOMEPAGE="https://github.com/dask/dask"
SRC_URI="https://github.com/dask/dask/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pyarrow[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/fsspec[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/partd[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-mock pytest-rerunfailures pytest-timeout pytest-xdist )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# tests use pytest.raises for warnings; epytest clears warnings-as-errors
		dask/array/tests/test_reductions.py::test_nanquantile_all_nan
		dask/array/tests/test_array_core.py::test_zarr_risky_shards_warns
		# internet access
		dask/bytes/tests/test_http.py::test_read_csv
		dask/bytes/tests/test_http.py::test_parquet
		# missing files on some systems
		dask/tests/test_sizeof.py::test_register_backend_entrypoint
		dask/tests/test_traceback.py::test_compute_shorten_traceback[processes]
		dask/tests/test_traceback.py::test_persist_shorten_traceback[processes]
	)
	epytest -o addopts= -o xfail_strict=false -W default
}
