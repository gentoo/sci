# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1 virtualx

MY_PN="props"

DESCRIPTION="Object attribute management for the FSLeyes viewer"
HOMEPAGE="https://git.fmrib.ox.ac.uk/fsl/fsleyes/fsleyes/tree/master"
SRC_URI="https://git.fmrib.ox.ac.uk/fsl/fsleyes/${MY_PN}/-/archive/${PV}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		)
	dev-python/setuptools[${PYTHON_USEDEP}]
	"
RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wxpython[${PYTHON_USEDEP}]
	sci-visualization/fsleyes-widgets[${PYTHON_USEDEP}]
	dev-python/fslpy[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/fsleyes-props-1.6.7-coverage.patch"
	"${FILESDIR}/fsleyes-props-1.6.7-tests.patch"
)

python_test() {
	virtx pytest --verbose || die
}
