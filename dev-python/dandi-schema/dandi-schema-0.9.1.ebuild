# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Schemata for DANDI archive project"
HOMEPAGE="https://github.com/dandi/dandi-schema"
SRC_URI="https://github.com/dandi/dandi-schema/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Package has pydantic version restriction (2.4*), which, however, breaks the test suite:
# https://github.com/dandi/dandi-schema/issues/228
# Commented failing tests with upstream version restriction listed below.
RDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.5[${PYTHON_USEDEP}]
	dev-python/email-validator[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-coverage.patch"
)

src_configure() {
	echo "__version__ = '${PV}'" >> dandischema/_version.py
}

#EPYTEST_DESELECT=(
#	"dandischema/tests/test_metadata.py::test_asset"
#	"dandischema/tests/test_metadata.py::test_aggregate[files1-summary1]"
#	"dandischema/tests/test_metadata.py::test_aggregate[files2-summary2]"
#)

distutils_enable_tests pytest

python_test() {
	export DANDI_TESTS_NONETWORK=1
	epytest dandischema
}
