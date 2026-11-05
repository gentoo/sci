# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{13..15} )

inherit distutils-r1 pypi

DESCRIPTION="Hatchling plugin to read the description from a package docstring"
HOMEPAGE="https://github.com/flying-sheep/hatch-docstring-description"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/hatchling[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? ( dev-python/build[${PYTHON_USEDEP}] )
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
