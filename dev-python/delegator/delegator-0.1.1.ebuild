# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Subprocesses for Humans 2.0."
HOMEPAGE="https://github.com/amitt001/delegator.py"
SRC_URI="https://github.com/amitt001/delegator.py/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="test"

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	"
RDEPEND=""

S="${WORKDIR}/delegator.py-${PV}"

python_test() {
	pytest -vv || die "Tests failed under ${EPYTHON}"
}
