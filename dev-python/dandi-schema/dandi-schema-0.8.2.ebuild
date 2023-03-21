# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Schemata for DANDI archive project"
HOMEPAGE="https://github.com/dandi/dandi-schema"
SRC_URI="https://github.com/dandi/dandi-schema/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/python-email-validator[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.4-coverage.patch"
)

src_configure() {
	echo "__version__ = '${PV}'" >> dandischema/_version.py
}

distutils_enable_tests pytest

python_test() {
	export DANDI_TESTS_NONETWORK=1
	pushd dandischema || die
		epytest tests
	popd
}
