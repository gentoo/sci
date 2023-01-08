# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="An easy, practical library for making python terminal apps"
HOMEPAGE="https://github.com/jquast/blessed https://pypi.org/project/blessed/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
	"

PATCHES=( "${FILESDIR}/${P}-no_coverage.patch" )

distutils_enable_sphinx docs
distutils_enable_tests pytest
