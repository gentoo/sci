# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1

DESCRIPTION="Object storage frontend to DBM/fs/mem/sqlite backends"
HOMEPAGE="https://github.com/lcrees/shove
	https://pypi.python.org/pypi/shove"
SRC_URI="https://github.com/lcrees/shove/archive/0.6.6.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
