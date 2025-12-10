# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Command line program to validate and convert CITATION.cff files."
HOMEPAGE="
	https://pypi.org/project/cffconvert/
	https://github.com/citation-fiel-format/cffconvert/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	<dev-python/click-9
	<dev-python/requests-3
	<dev-python/jsonschema-5
	>=dev-python/ruamel-yaml-0.16.0
	>=dev-python/pykwalify-1.6
"
PATCHES=(
	"${FILESDIR}"/$P-coverage.patch
)
EPYTEST_IGNORE=(
	# needs files that were stripped from pypi
	test/test_consistent_versioning.py
)

distutils_enable_tests pytest
