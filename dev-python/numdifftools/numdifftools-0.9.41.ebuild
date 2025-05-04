# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Solve automatic numerical differentiation problems in one or more variables"
HOMEPAGE="
	https://github.com/pbord/numdifftools
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.24[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.10[${PYTHON_USEDEP}]
"
# fail for some reason...
RESTRICT="test"
