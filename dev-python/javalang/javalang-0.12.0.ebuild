# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Pure Python Java parser and tools"
HOMEPAGE="https://github.com/c2nes/javalang"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
