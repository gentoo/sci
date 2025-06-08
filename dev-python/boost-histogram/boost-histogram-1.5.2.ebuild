# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=scikit-build-core
DISTUTILS_EXT=1
inherit cmake distutils-r1 pypi

DESCRIPTION="Python bindings for the C++14 Boost::Histogram library"
HOMEPAGE="
	https://github.com/scikit-hep/boost-histogram
	https://boost-histogram.readthedocs.io/en/latest/
	https://pypi.org/project/boost-histogram/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/pybind11-2.13.3[${PYTHON_USEDEP}]
	test? (
		dev-python/cloudpickle[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	default
	sed -i 's/\["pytest-benchmark"\]/[]/g' pyproject.toml || die
	# https://github.com/scikit-build/scikit-build-core/issues/912
	sed -i -e '/scikit-build-core/s:0\.11:0.8:' pyproject.toml || die
}

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	tests/test_benchmark_1d.py
	tests/test_benchmark_2d.py
	tests/test_benchmark_category_axis.py
	tests/test_pickle.py
	tests/test_threaded_fill.py
)
