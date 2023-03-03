# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Allows you to load and manipulate AMPL/GLPK data as Python data structures"
HOMEPAGE="https://github.com/willu47/amply/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
