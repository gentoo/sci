# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Type hints for Numpy"
HOMEPAGE="
	https://pypi.org/project/nptyping/
	https://github.com/ramonhagenaars/nptyping/
"
SRC_URI="
	https://github.com/ramonhagenaars/nptyping/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pandas-stubs[${PYTHON_USEDEP}]
		dev-python/typeguard[${PYTHON_USEDEP}]
		dev-python/beartype[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# requires pyright, which is not yet packaged
	tests/test_pyright.py
	# requires Internet + feedparser, meaningless for users
	tests/test_package_info.py
	# relying on Internet access to fetch packages for pip
	tests/test_wheel.py
	tests/pandas_/test_fork_sync.py
)

EPYTEST_DESELECT=(
	# Reported upstream:
	# https://github.com/ramonhagenaars/nptyping/issues/113
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_ndarray_with_any
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_ndarray_with_shape
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_ndarray_with_structure
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_ndarrays_as_function_arguments
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_ndarrays_as_variable_hints
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_nptyping_types
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_numpy_types
	tests/test_mypy.py::MyPyTest::test_mypy_accepts_recarray_with_structure
	tests/test_mypy.py::MyPyTest::test_mypy_disapproves_ndarray_with_wrong_function_arguments
	tests/test_mypy.py::MyPyTest::test_mypy_knows_of_ndarray_methods
	tests/test_typeguard.py::TypeguardTest::test_success
	tests/pandas_/test_mypy_dataframe.py::MyPyDataFrameTest::test_mypy_accepts_dataframe
	tests/pandas_/test_mypy_dataframe.py::MyPyDataFrameTest::test_mypy_disapproves_dataframe_with_wrong_function_arguments
	tests/pandas_/test_mypy_dataframe.py::MyPyDataFrameTest::test_mypy_knows_of_dataframe_methods
)

distutils_enable_tests pytest
