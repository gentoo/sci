# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Decorator for keeping backward-compatible Python APIs"
HOMEPAGE="https://github.com/flying-sheep/legacy-api-wrap"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# correctly raises warning, but is not recognized by test
	tests/test_basic.py::test_customize
)
