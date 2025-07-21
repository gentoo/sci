# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Hatchling plugin that derives a project’s description from its package docstring"
HOMEPAGE="https://github.com/flying-sheep/hatch-docstring-description"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? ( dev-python/build[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
