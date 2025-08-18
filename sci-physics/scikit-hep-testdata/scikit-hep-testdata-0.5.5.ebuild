# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="A package to provide example files for testing and developing packages against."
HOMEPAGE="https://github.com/scikit-hep/scikit-hep-testdata"
# pypi does not include the data nor tests
SRC_URI="https://github.com/scikit-hep/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
# Fails without this
S="${WORKDIR}/${P}"
# export is needed here!
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
# otherwise we don't install the data
export SKHEP_DATA=1

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_IGNORE=(
	test_remote_files.py # we are net sandboxed
)
EPYTEST_DESELECT=(
	tests/test_local_files.py::test_data_path_cached # https://github.com/scikit-hep/scikit-hep-testdata/issues/161
)

distutils_enable_tests pytest
