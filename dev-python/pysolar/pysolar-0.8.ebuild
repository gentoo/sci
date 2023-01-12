# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

AUTHOR=pingswept

inherit distutils-r1

DESCRIPTION="Collection of Python libraries for simulating the irradiation by the sun"
HOMEPAGE="https://pysolar.org/"
SRC_URI="https://github.com/${AUTHOR}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

python_prepare_all() {
	sed \
		-e "s:'testsolar', ::" \
		-e "s:'shade_test', ::" \
		-i setup.py || die # don't install tests
	distutils-r1_python_prepare_all
}
