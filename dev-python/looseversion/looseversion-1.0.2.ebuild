# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="A backwards/forwards-compatible fork of distutils' LooseVersion"
HOMEPAGE="https://github.com/effigies/looseversion"
SRC_URI="https://github.com/effigies/looseversion/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
BEPEND=""

distutils_enable_tests pytest

python_test() {
	epytest tests.py
}
