# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

MY_PN="pyFFTW"

DESCRIPTION="FFTW wrapper for python"
HOMEPAGE="http://hgomersall.github.io/pyFFTW/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="test"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	>=sci-libs/fftw-3.3.3
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

#current python_test() broken
RESTRICT="test"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die

	cp "${S}"/setup.py "${TEST_DIR}"/lib/ || die
	cp -r "${S}"/test "${TEST_DIR}"/lib/ || die
	esetup.py test || die
}
