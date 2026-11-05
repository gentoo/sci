# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Parsing the Command Line the Easy Way"
HOMEPAGE="
	https://github.com/ialbert/plac
	https://pypi.org/project/plac/
"
# The PyPI sdist omits the Python 3.13+ help fixtures used by the tests.
SRC_URI="https://github.com/ialbert/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# Running all tests requires network; run the same as upstream CI here
	epytest doc/test_plac.py doc/test_ishelve.py
}
