# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="PEP 561 type stubs generator for pybind11 modules"
HOMEPAGE="https://github.com/sizmailov/pybind11-stubgen"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-python/pybind11[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

# no tests in package
