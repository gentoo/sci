# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python library for accessing 2bit files"
HOMEPAGE="https://github.com/deeptools/py2bit"
SRC_URI="https://github.com/deeptools/py2bit/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-libs/lib2bit"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

python_test() {
	epytest py2bitTest/test.py
}
