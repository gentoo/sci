# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="Draw Gantt charts from Python"
HOMEPAGE="https://pypi.org/project/python-gantt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/svgwrite[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

python_test() {
	nosetests -v || die "nose tests fail with ${EPYTHON}"
}
