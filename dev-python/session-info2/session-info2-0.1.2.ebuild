# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Lightweight printout of current Python session information"
HOMEPAGE="https://github.com/flying-sheep/session-info2"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/hatch-docstring-description[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-subprocess[${PYTHON_USEDEP}]
		dev-python/jupyter-client[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# depends on specific system configuration
	tests/test_synthetic.py::test_repr
	tests/test_synthetic.py::test_gpu
)

distutils_enable_tests pytest
