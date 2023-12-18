# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit pypi distutils-r1

DESCRIPTION="Parsing the Command Line the Easy Way"
HOMEPAGE="https://pypi.org/project/plac/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

EPYTEST_DESELECT=(
	# Missing index.rst
	doc/test_plac.py::test_doctest
)

distutils_enable_tests pytest
