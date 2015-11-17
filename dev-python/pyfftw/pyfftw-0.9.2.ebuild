# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

MY_PN="pyFFTW"

DESCRIPTION="FFTW wrapper for python"
HOMEPAGE="http://hgomersall.github.io/pyFFTW/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE="test"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	>=dev-python/numpy-1.8.0[${PYTHON_USEDEP}]
	>=sci-libs/fftw-3.3.3
	>=dev-python/cython-0.19.1[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp "${S}"/setup.py "${TEST_DIR}"/lib/ || die
	cp -r "${S}"/test "${TEST_DIR}"/lib/ || die
	esetup.py test || die
}
