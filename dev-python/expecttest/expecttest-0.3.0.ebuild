# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="This library implements expect tests (also known as \"golden\" tests)"
HOMEPAGE="https://github.com/pytorch/expecttest"
SRC_URI="
	https://github.com/pytorch/expecttest/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/flake8-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/hypothesis-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/mypy-0.910.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
