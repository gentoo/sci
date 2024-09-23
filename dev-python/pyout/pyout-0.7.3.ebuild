# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Terminal styling for structured data"
HOMEPAGE="https://github.com/pyout/pyout"
#SRC_URI="https://github.com/pyout/pyout/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/blessed[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

#PATCHES=( "${FILESDIR}/${PN}-0.7.2-blessed.patch"  )

python_prepare_all() {
	sed -i -e '/pytest-runner/d' setup.py || die
	distutils-r1_python_prepare_all
}
