# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="PEP 561 type stubs generator for pybind11 modules"
HOMEPAGE="https://github.com/sizmailov/pybind11-stubgen"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/pybind11[${PYTHON_USEDEP}]
"
