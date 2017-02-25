# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library for manipulation of chemical structures"
HOMEPAGE="http://bkchem.zirael.org/oasa_en.html"
SRC_URI="http://bkchem.zirael.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo"

DEPEND=""
RDEPEND="cairo? ( >=dev-python/pycairo-1.2[${PYTHON_USEDEP}] )"
