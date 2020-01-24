# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Needleman-Wunsch global sequence alignment in python3"
HOMEPAGE="https://github.com/briney/nwalign3"
SRC_URI="mirror://pypi/n/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/numpy
	dev-python/cython"
RDEPEND="${DEPEND}"
