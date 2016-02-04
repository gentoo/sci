# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="Improved version of the old pydot project"
HOMEPAGE="http://pydotplus.readthedocs.org/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/${PN}-${MY_PV}"

src_test() {
	${PYTHON} -m unittest discover
}
