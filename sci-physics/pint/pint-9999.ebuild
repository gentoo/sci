# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="Operate and manipulate physical quantities in Python"
HOMEPAGE="https://github.com/hgrecco/pint"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hgrecco/pint"
else
	inherit pypi
	KEYWORDS="~amd64"
fi

DEPEND="
	>=dev-python/platformdirs-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/flexcache-0.3[${PYTHON_USEDEP}]
	>=dev-python/flexparser-0.4[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	pint/testsuite/benchmarks
)

distutils_enable_tests pytest
