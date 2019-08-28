# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 python3_7 )

inherit distutils-r1

DESCRIPTION="Draw Gantt charts from Python"
HOMEPAGE="https://pypi.org/project/python-gantt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/svgwrite[${PYTHON_USEDEP}]
	"

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
