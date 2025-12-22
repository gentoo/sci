# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Pytest plugin with advanced doctest features"
HOMEPAGE="https://astropy.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

# Skip the remote tests
EPYTEST_DESELECT=(
	tests/test_doctestplus.py::test_remote_data_url
	tests/test_doctestplus.py::test_remote_data_float_cmp
	tests/test_doctestplus.py::test_remote_data_ignore_whitespace
	tests/test_doctestplus.py::test_remote_data_ellipsis
	tests/test_doctestplus.py::test_remote_data_requires
	tests/test_doctestplus.py::test_remote_data_ignore_warnings
)

distutils_enable_tests pytest
