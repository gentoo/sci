# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit pypi distutils-r1

DESCRIPTION="Format click help output nicely with rich"
HOMEPAGE="https://pypi.org/project/rich-click/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]"

RESTRICT="test"
# ModuleNotFoundError: No module named 'tests.conftest'
#distutils_enable_tests pytest
