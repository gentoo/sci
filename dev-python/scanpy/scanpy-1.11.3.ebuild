# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Single-cell analysis in Python (scalable to >1M cells)"
HOMEPAGE="https://github.com/scverse/scanpy"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/anndata-0.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.24.1[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.7.5[${PYTHON_USEDEP}]
	>=dev-python/pandas-1.5.3[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.11.1[${PYTHON_USEDEP}]
	>=dev-python/seaborn-0.13.2[${PYTHON_USEDEP}]
	>=dev-python/h5py-3.7.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-1.1.3[${PYTHON_USEDEP}]
	>=dev-python/statsmodels-0.14.4[${PYTHON_USEDEP}]
	dev-python/patsy[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.7.1[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	>=dev-python/numba-0.57.1[${PYTHON_USEDEP}]
	>=dev-python/umap-learn-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/pynndescent-0.5.13[${PYTHON_USEDEP}]
	>=dev-python/packaging-21.3[${PYTHON_USEDEP}]
	dev-python/session-info2[${PYTHON_USEDEP}]
	>=dev-python/legacy-api-wrap-1.4.1[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# flaky got an unexpected keyword argument 'reruns'
	tests/test_backed.py::test_backed_error
	# related: https://github.com/scverse/scanpy/issues/1418
	tests/test_plotting.py
	tests/test_plotting_embedded/test_spatial.py
)
