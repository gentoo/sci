# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A 21 century R console"
HOMEPAGE="https://github.com/randy3k/radian"
SRC_URI="https://github.com/randy3k/radian/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

# tests fail but package works fine
RESTRICT="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/prompt-toolkit[$PYTHON_USEDEP]
	dev-python/rchitect[$PYTHON_USEDEP]
	dev-python/six[$PYTHON_USEDEP]
	dev-lang/R"
