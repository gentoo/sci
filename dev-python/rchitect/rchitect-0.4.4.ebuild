# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Interoperate R with Python"
HOMEPAGE="https://github.com/randy3k/rchitect"
SRC_URI="https://github.com/randy3k/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

# rchitect._cffi is occluded and causes test error
RESTRICT="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/cffi[$PYTHON_USEDEP]
	dev-python/six[${PYTHON_USEDEP}]"
