# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1 git-r3

MY_PN="pyFFTW"

DESCRIPTION="FFTW wrapper for python"
HOMEPAGE="http://hgomersall.github.io/pyFFTW/"
EGIT_REPO_URI="https://github.com/hgomersall/${MY_PN}.git git://github.com/hgomersall/${MY_PN}.git"

LICENSE="BSD"
SLOT="0"
IUSE="test"

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
